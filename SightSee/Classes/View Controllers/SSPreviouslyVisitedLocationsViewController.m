//
//  SSPreviouslyVisitedLocationsViewController.m
//  SightSee
//
//  Created by Ross Beale on 25/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import "SSPreviouslyVisitedLocationsViewController.h"
#import "SSLocationDetailViewController.h"
#import "SSLocationCell.h"

@interface SSPreviouslyVisitedLocationsViewController ()

@end

@implementation SSPreviouslyVisitedLocationsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.000 green:0.287 blue:0.459 alpha:1.000];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    if ([[[self fetchedResultsController] fetchedObjects] count] == 0) {
        [self closeView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"LocationInformation"]) {
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
        [self.navigationItem setBackBarButtonItem:backButton];
        
        SSLocationDetailViewController *destinationViewController = (SSLocationDetailViewController *)segue.destinationViewController;
        destinationViewController.hidesBottomBarWhenPushed = YES;
        destinationViewController.location = _tempLocation;
        _tempLocation = nil;
    }
}

#pragma mark - UI

- (IBAction)closeButtonPressed:(id)sender
{
    [self closeView];
}

- (void)closeView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Core Data methods

- (NSString *)entityName
{
    return NSStringFromClass([SSLocation class]);
}

- (NSArray *)sortDescriptors
{
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
    return @[sort];
}

- (NSPredicate *)predicate
{
    if ([SSPreferencesManager userDefaultForKey:kUserDefaultsKeyFilterID]) {
        SSCategory *category = [[SSCategory whereFormat:@"rid == %@", [SSPreferencesManager userDefaultForKey:kUserDefaultsKeyFilterID]] lastObject];
        return [NSPredicate predicateWithFormat:@"ANY categories == %@ AND visiting == %@", category, [NSNumber numberWithBool:YES]];
    } else {
        return [NSPredicate predicateWithFormat:@"visiting == %@", [NSNumber numberWithBool:YES]];
    }
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MAX(1, [super tableView:tableView numberOfRowsInSection:section]);
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    SSLocation *location = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    ((SSLocationCell *)cell).location = location;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[self fetchedResultsController] fetchedObjects] count] == 0) {
        return [self.tableView dequeueReusableCellWithIdentifier:@"EmptyCell" forIndexPath:indexPath];
    }
    
    SSLocationCell *cell = (SSLocationCell *)[self.tableView dequeueReusableCellWithIdentifier:@"LocationCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[self fetchedResultsController] fetchedObjects] count] == 0){
        return self.tableView.frame.size.height;
    }
    
    SSLocation *location = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    return [SSLocationCell heightForCellWithLocation:location];
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[self fetchedResultsController] fetchedObjects] count] == 0) return indexPath;
    
    SSLocation *location = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    _tempLocation = location;
    return indexPath;
}

@end
