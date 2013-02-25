//
//  SSListViewController.m
//  SightSee
//
//  Created by Ross Beale on 18/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import "SSListViewController.h"
#import "SSLocationCell.h"
#import "SSLocationDetailViewController.h"
#import "SSDataManager.h"

#define kCategoryTableView 100

@interface SSListViewController ()

@end

@implementation SSListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self.searchDisplayController setActive:NO animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _filteredArray = [NSMutableArray array];
    [self.searchDisplayController.searchResultsTableView setRowHeight:112];
    [self didReloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFilter) name:kUpdateNotificationName object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.000 green:0.287 blue:0.459 alpha:1.000];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        return [NSPredicate predicateWithFormat:@"ANY categories == %@", category];
    } else {
        return nil;
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == kCategoryTableView) {
        return [[SSCategory allOrderBy:@"name" ascending:YES] count] + 1;
    }
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_filteredArray count];
    }
    return MAX(1, [super tableView:tableView numberOfRowsInSection:section]);
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    SSLocation *location = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    ((SSLocationCell *)cell).location = location;
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
    
    if ([[[self fetchedResultsController] fetchedObjects] count] == 0) {
        return [self.tableView dequeueReusableCellWithIdentifier:@"EmptyCell" forIndexPath:indexPath];
    }
    
    SSLocationCell *cell = (SSLocationCell *)[self.tableView dequeueReusableCellWithIdentifier:@"LocationCell" forIndexPath:indexPath];
    if (tableView == self.tableView) {
        [self configureCell:cell atIndexPath:indexPath];
    } else {
        SSLocation *location = [_filteredArray objectAtIndex:indexPath.row];
        cell.location = location;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == kCategoryTableView) {
        return 44.f;
    }
    
    if ([[[self fetchedResultsController] fetchedObjects] count] == 0){
        return self.tableView.frame.size.height - 44.f;
    }
    
    SSLocation *location;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        location = [_filteredArray objectAtIndex:indexPath.row];
    } else {
        location = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    }
    return [SSLocationCell heightForCellWithLocation:location];
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == kCategoryTableView) return indexPath;
    
    SSLocation *location = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    _tempLocation = location;
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == kCategoryTableView) {
        if (indexPath.row == 0) {
            [SSPreferencesManager setUserDefaultValue:nil forKey:kUserDefaultsKeyFilterID];
        } else {
            SSCategory *category = [[SSCategory allOrderBy:@"name" ascending:YES] objectAtIndex:indexPath.row - 1];
            [SSPreferencesManager setUserDefaultValue:category.rid forKey:kUserDefaultsKeyFilterID];
        }
        [self reloadFilter];
        [tableView reloadData];
    }
}

- (void)didReloadData
{
    self.searchBar.hidden = ([[[self fetchedResultsController] fetchedObjects] count] == 0);
    self.tableView.scrollEnabled = !self.searchBar.hidden;
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
        [[SSDataManager sharedInstance] fetchData];
    }];
    
    if ([[SSLocation all] count] > 0 && [[SSCategory all] count] > 0) {
        [actionSheet addButtonWithTitle:@"Filter" onTapped:^{
            [self showCategoryFilter];
        }];
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

- (void)reloadFilter
{
    [NSFetchedResultsController deleteCacheWithName:nil];
    self.fetchedResultsController = nil;
    [self.tableView reloadData];
}

#pragma mark - Search

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString];
    return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText
{
    _filteredArray = [[self filteredSearchLocations:searchText] copy];
}

- (NSArray *)filteredSearchLocations:(NSString *)searchText
{
    if ([SSPreferencesManager userDefaultForKey:kUserDefaultsKeyFilterID]) {
        SSCategory *category = [[SSCategory whereFormat:@"rid == %@", [SSPreferencesManager userDefaultForKey:kUserDefaultsKeyFilterID]] lastObject];
        return [SSLocation where:[NSPredicate predicateWithFormat:@"ANY categories = %@ AND (name contains[cd] %@ OR desc contains[cd] %@)", category, searchText, searchText]];
    } else {
        return [SSLocation whereFormat:@"name contains[cd] '%@' OR desc contains[cd] '%@'", searchText, searchText];
    }
}

@end
