//
//  SSLocationDetailViewController.h
//  SightSee
//
//  Created by Ross Beale on 19/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSLocation.h"

@interface SSLocationDetailViewController : UITableViewController

@property (nonatomic, weak) SSLocation *location;

@end
