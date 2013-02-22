//
//  SSLocationReviewsViewController.h
//  SightSee
//
//  Created by Ross Beale on 22/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSLocation.h"

@interface SSLocationReviewsViewController : UITableViewController {
    BOOL _secondLoad;
}

@property (nonatomic, weak) SSLocation *location;

@end
