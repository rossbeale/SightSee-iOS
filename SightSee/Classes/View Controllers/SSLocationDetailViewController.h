//
//  SSLocationDetailViewController.h
//  SightSee
//
//  Created by Ross Beale on 19/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSLocation.h"

typedef enum {
    kCellTypeMapView = 100,
    kCellTypeName = 110,
    kCellTypeDescription = 120,
    kCellTypeDistance = 130,
    kCellTypeReview = 140
} kCellType;

@interface SSLocationDetailViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) SSLocation *location;

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end
