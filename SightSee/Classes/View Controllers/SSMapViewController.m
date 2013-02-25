//
//  SSMapViewController.m
//  SightSee
//
//  Created by Ross Beale on 18/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import "SSMapViewController.h"
#import "SSLocationDetailViewController.h"
#import "SSLocation.h"
#import "SSDataManager.h"

#define kCategoryTableView 100

@interface SSMapViewController ()
/**
 * REQUIRED method, must be overriden by subclasses. Return the name of the entity
 * you want to display in the tableview.
 */
- (NSString *)entityName;
@end

@implementation SSMapViewController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize context = _context;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupMapView) name:kUpdateNotificationName object:nil];
    
    [self setupMapView];
    [self setupFetchedResultsController];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.129 green:0.459 blue:0.000 alpha:1.000];
    if (!_hasPushed) {
        [self setupMapView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"LocationInformation"]) {
        
        _hasPushed = YES;
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStyleBordered target:nil action:nil];
        [self.navigationItem setBackBarButtonItem:backButton];
        
        SSLocationDetailViewController *destinationViewController = (SSLocationDetailViewController *)segue.destinationViewController;
        destinationViewController.hidesBottomBarWhenPushed = YES;
        destinationViewController.location = _tempLocation;
        _tempLocation = nil;
    }
}

#pragma mark - Core Data setup

- (NSManagedObjectContext *)context
{
    // Lazy getter.
    if (!_context) {
        @synchronized(self) {
            if (!_context)
                [self setContext:[NSManagedObjectContext defaultContext]];
        }
    }
    
    return _context;
}

- (NSString *)entityName
{
    return NSStringFromClass([SSLocation class]);
}

- (NSString *)cacheName
{
    return NSStringFromClass([self class]);
}

- (NSArray *)sortDescriptors
{
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    return @[sort];
}

- (NSPredicate *)predicate
{
    if ([SSPreferencesManager userDefaultForKey:kUserDefaultsKeyFilterID]) {
        SSCategory *category = [[SSCategory whereFormat:@"rid == %@", [SSPreferencesManager userDefaultForKey:kUserDefaultsKeyFilterID]] lastObject];
        return [NSPredicate predicateWithFormat:@"ANY categories == %@ AND visiting == %@", category, [NSNumber numberWithBool:NO]];
    } else {
        return [NSPredicate predicateWithFormat:@"visiting == %@", [NSNumber numberWithBool:NO]];
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)setupFetchedResultsController
{
    @synchronized(self) {
        
        if (_fetchedResultsController)
            return _fetchedResultsController;
        
        // Create the fetch request for the entity.
        NSFetchRequest * fetchRequest = [NSFetchRequest new];
        // Edit the entity name as appropriate.
        NSEntityDescription * entity = [NSEntityDescription entityForName:[self entityName]
                                                   inManagedObjectContext:[self context]];
        [fetchRequest setEntity:entity];
        [fetchRequest setSortDescriptors:[self sortDescriptors]];
        
        NSFetchedResultsController * fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                           managedObjectContext:[self context]
                                                                                             sectionNameKeyPath:nil
                                                                                                      cacheName:[self cacheName]];
        fetchController.delegate = self;
        _fetchedResultsController = fetchController;
        
        NSError * error = nil;
        
        if (![_fetchedResultsController performFetch:&error]) {
            DLog(@"Core Data fetch error. Error: %@, %@", error, [error userInfo]);
        }
    }
    
    return _fetchedResultsController;
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self fetchedResultsChangeInsert:anObject];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self fetchedResultsChangeDelete:anObject];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self fetchedResultsChangeUpdate:anObject];
            break;
            
        case NSFetchedResultsChangeMove:
            //We do nothing here since we are not concerned with the index an object is at
            break;
    }
}

- (void)fetchedResultsChangeInsert:(NSObject *)anObject
{
    SSLocation *location = (SSLocation *)anObject;
    [self addToMapViewLocation:location];
}

- (void)fetchedResultsChangeDelete:(NSObject *)anObject
{
    SSLocation *location = (SSLocation *)anObject;
    [self removeFromMapViewLocation:location];
}

- (void)fetchedResultsChangeUpdate:(NSObject *)anObject
{
    //Takes a little bit of overheard but it is simple
    [self fetchedResultsChangeDelete:anObject];
    [self fetchedResultsChangeInsert:anObject];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self setupMapView];
}

#pragma mark - MapView methods

- (void)setupMapView
{
    self.mapView.showsUserLocation = YES;
    
    [self clearMapView];
    
    NSArray *locations;
    if ([SSPreferencesManager userDefaultForKey:kUserDefaultsKeyFilterID]) {
        SSCategory *category = [[SSCategory whereFormat:@"rid == %@", [SSPreferencesManager userDefaultForKey:kUserDefaultsKeyFilterID]] lastObject];
        locations = [SSLocation where:[NSPredicate predicateWithFormat:@"ANY categories = %@ AND visiting == %@", category, [NSNumber numberWithBool:NO]]];
    } else {
        locations = [SSLocation where:[NSPredicate predicateWithFormat:@"visiting == %@", [NSNumber numberWithBool:NO]]];
    }
    if ([locations count] == 0) {
        [SVProgressHUD showErrorWithStatus:@"No locations were found"];
    } else {
        for (SSLocation *location in locations) {
            [self addToMapViewLocation:location];
        }
    }
    [self.mapView fitAllPoints:YES];
}

- (void)clearMapView
{
    for (id annotation in self.mapView.annotations) {
        
        if (annotation != self.mapView.userLocation) {
            
            [self.mapView removeAnnotation:annotation];
        }
    }
}

- (void)addToMapViewLocation:(SSLocation *)location
{
    SSLocationMapAnnotation *mapAnnotation = [[SSLocationMapAnnotation alloc] initWithLocation:location];
    [self.mapView addAnnotation:mapAnnotation];
}

- (void)removeFromMapViewLocation:(SSLocation *)location
{
    NSMutableArray *toRemove = [NSMutableArray arrayWithCapacity:1];
    for (id annotation in self.mapView.annotations) {
        
        if (annotation != self.mapView.userLocation) {
            SSLocationMapAnnotation *pinAnnotation = annotation;
            if ([pinAnnotation.location.rid isEqual:location.rid]) {
                [toRemove addObject:annotation];
            }
        }
    }
    [self.mapView removeAnnotations:toRemove];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [mapView fitAllPoints:YES];
    [mapView setUserTrackingMode:MKUserTrackingModeNone animated:NO];
}

#pragma mark - MapViewDelegate

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Maps had trouble loading." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKUserLocation class]]) return nil;
    
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"LocationPin"];
    SSLocation *annotationLocation = ((SSLocationMapAnnotation *)annotationView.annotation).location;
    
    annotationView.pinColor = MKPinAnnotationColorGreen;
    
    if ([annotationLocation.reviews count] > 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, 20, 32)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:12.f];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 2;
        label.text = [NSString stringWithFormat:@"★\n%0.1f", [[annotationLocation averageRating] floatValue]];
        label.shadowColor = [UIColor blackColor];
        label.shadowOffset = CGSizeMake(0.0, -1.0);
        [label sizeToFit];
        
        UIView *leftCAV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 32)];
        leftCAV.backgroundColor = [UIColor clearColor];
        [leftCAV addSubview:label];
        [leftCAV sizeToFit];
        annotationView.leftCalloutAccessoryView = leftCAV;
    }
    
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];;
    annotationView.canShowCallout = YES;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    SSLocationMapAnnotation *annotation = (SSLocationMapAnnotation *)view.annotation;
    _tempLocation = annotation.location;
    [self performSegueWithIdentifier:@"LocationInformation" sender:self];
}

#pragma mark - options button

- (IBAction)optionsButtonPressed:(id)sender
{
    [self presentOptions];
}

- (void)presentOptions
{
    MEActionSheet *actionSheet = [[MEActionSheet alloc] initWithTitle:nil];
    
    [actionSheet addButtonWithTitle:@"Refresh Location" onTapped:^{
        
        if (![[[[NSBundle mainBundle] infoDictionary] objectForKey:@"DeleteOldData"] boolValue] && [[SSLocation all] count] > 0) {
            
            [UIAlertView alertViewWithTitle:@"Clear Data?" message:@"This will clear all existing data and stop tracking." cancelButtonTitle:@"Keep Data" otherButtonTitles:@[@"Clear Data"] onDismiss:^(int buttonIndex) {
                if (buttonIndex == 0) {
                    [[SSDataManager sharedInstance] deleteAllData];
                    [[SSDataManager sharedInstance] fetchData];
                }
            } onCancel:^{
                [[SSDataManager sharedInstance] fetchData];
            }];
            
        }
        
    }];
    
    if ([[SSLocation all] count] > 0 && [[SSCategory all] count] > 0) {
        [actionSheet addButtonWithTitle:@"Filter" onTapped:^{
            [self showCategoryFilter];
        }];
        
        BOOL hasPreviouslyVisited = NO;
        if ([SSPreferencesManager userDefaultForKey:kUserDefaultsKeyFilterID]) {
            SSCategory *category = [[SSCategory whereFormat:@"rid == %@", [SSPreferencesManager userDefaultForKey:kUserDefaultsKeyFilterID]] lastObject];
            NSInteger visitedCount = [[SSLocation where:[NSPredicate predicateWithFormat:@"ANY categories = %@", category]] count];
            if (visitedCount != [[[self fetchedResultsController] fetchedObjects] count]) {
                hasPreviouslyVisited = YES;
            }
        } else {
            if ([[SSLocation all] count] != [[[self fetchedResultsController] fetchedObjects] count]) {
                hasPreviouslyVisited = YES;
            }
        }
        
        if (hasPreviouslyVisited) {
            [actionSheet addButtonWithTitle:@"View Previously Visited" onTapped:^{
                [self performSegueWithIdentifier:@"ViewPreviouslyVisited" sender:self];
            }];
        }
    }
    
    // Add the cancel button to the end
    [actionSheet setDestructiveButtonWithTitle:@"Cancel" onTapped:nil];
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}


#pragma mark - Category filter

- (void)showCategoryFilter
{
    SBTableAlert *tableAlert = [[SBTableAlert alloc] initWithTitle:@"Filter" cancelButtonTitle:@"Close" messageFormat:nil];
    tableAlert.tableView.tag = kCategoryTableView;
    tableAlert.tableViewDataSource = self;
    tableAlert.tableViewDelegate = self;
    [tableAlert show];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == kCategoryTableView) {
        return [[SSCategory allOrderBy:@"name" ascending:YES] count] + 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == kCategoryTableView) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.textLabel.text = @"All";
            if (![SSPreferencesManager userDefaultForKey:kUserDefaultsKeyFilterID]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        } else {
            SSCategory *category = [[SSCategory allOrderBy:@"name" ascending:YES] objectAtIndex:indexPath.row - 1];
            if ([[SSPreferencesManager userDefaultForKey:kUserDefaultsKeyFilterID] isEqual:category.rid]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            cell.textLabel.text = category.name;
        }
        return cell;
    }
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == kCategoryTableView) {
        if (indexPath.row == 0) {
            [SSPreferencesManager setUserDefaultValue:nil forKey:kUserDefaultsKeyFilterID];
        } else {
            SSCategory *category = [[SSCategory allOrderBy:@"name" ascending:YES] objectAtIndex:indexPath.row - 1];
            [SSPreferencesManager setUserDefaultValue:category.rid forKey:kUserDefaultsKeyFilterID];
        }
        [tableView reloadData];
        [self setupMapView];
    }
}

@end
