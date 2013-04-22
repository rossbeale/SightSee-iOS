//
//  SSCoreDataViewController.m
//  SightSee
//
//  Created by Ross Beale on 27/01/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import "SSCoreDataTableViewController.h"

@interface SSCoreDataTableViewController ()

/**
 * REQUIRED method, must be overriden by subclasses. Return the name of the entity
 * you want to display in the tableview.
 */
- (NSString *)entityName;

/**
 * Returns the predicate to use to filter the fetch.
 */
- (NSPredicate *)predicate;

/**
 * The number of results to return in one fetch. Set to slightly more than one
 * screen full of content.
 */
- (NSInteger)batchSize;

/**
 * REQUIRED, return any sort descriptors you want to use to sort your data.
 */
- (NSArray *)sortDescriptors;

/**
 * The name to use for a cache. If you don't want to cache your data, then
 * return nil.
 */
- (NSString *)cacheName;

/**
 * Return the keypath to use for sections. If you don't want to use sections,
 * return nil.
 */
- (NSString *)sectionNameKeyPath;

@end

@implementation SSCoreDataTableViewController

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

#pragma mark - Template methods

- (NSString *)entityName
{
    return nil;
}

- (NSPredicate *)predicate
{
    return nil;
}

- (NSInteger)batchSize
{
    return 20;
}

- (NSArray *)sortDescriptors
{
    return nil;
}

- (NSString *)cacheName
{
    return NSStringFromClass([self class]);
}

- (NSString *)sectionNameKeyPath
{
    return nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[[self fetchedResultsController] sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    // Subclasses should override this method.
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Subclasses should override this method.
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
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
        [fetchRequest setFetchBatchSize:[self batchSize]];
        [fetchRequest setSortDescriptors:[self sortDescriptors]];
        [fetchRequest setPredicate:[self predicate]];
        
        NSFetchedResultsController * fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                           managedObjectContext:[self context]
                                                                                             sectionNameKeyPath:[self sectionNameKeyPath]
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

#pragma mark - Fetched results controller delegate

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{    
    [self.tableView reloadData];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{    
    [self.tableView reloadData];
}

@end
