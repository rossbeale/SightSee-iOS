//
//  SSCoreDataViewController.h
//  SightSee
//
//  Created by Ross Beale on 27/01/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SSCoreDataViewControllerDataSource <NSObject>
@required
- (NSString *)entityName;
- (NSArray *)sortDescriptors;
@optional
- (NSPredicate *)predicate;
- (NSInteger)batchSize;
- (NSString *)cacheName;
- (NSString *)sectionNameKeyPath;
@end

@interface SSCoreDataTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end
