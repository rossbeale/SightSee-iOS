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

#pragma mark - Core Data setup

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupMapView];
    [self setupFetchedResultsController];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.129 green:0.459 blue:0.000 alpha:1.000];
    if (_hasMoved) {
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
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStyleBordered target:nil action:nil];
        [self.navigationItem setBackBarButtonItem:backButton];
        
        SSLocationDetailViewController *destinationViewController = (SSLocationDetailViewController *)segue.destinationViewController;
        destinationViewController.hidesBottomBarWhenPushed = YES;
        destinationViewController.location = _tempLocation;
        _tempLocation = nil;
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
    
    for (SSLocation *location in [SSLocation all]) {
        [self addToMapViewLocation:location];
    }
    [self fitAllPointsOnMapView];
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

- (void)fitAllPointsOnMapView
{
    //http://stackoverflow.com/questions/4680649/zooming-mkmapview-to-fit-annotation-pins
    
    MKMapRect zoomRect = MKMapRectNull;
    if (self.mapView.userLocation) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(self.mapView.userLocation.coordinate);
        zoomRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
    }
    for (id <MKAnnotation> annotation in self.mapView.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        if (MKMapRectIsNull(zoomRect)) {
            zoomRect = pointRect;
        } else {
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
    }
    [self.mapView setVisibleMapRect:zoomRect animated:YES];
    _hasMoved = NO;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self fitAllPointsOnMapView];
    [mapView setUserTrackingMode:MKUserTrackingModeNone animated:NO];
}

#pragma mark - MapViewDelegate

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    _hasMoved = YES;
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    //TODO: failed
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

@end
