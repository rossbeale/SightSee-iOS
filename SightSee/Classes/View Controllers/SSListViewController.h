//
//  SSListViewController.h
//  SightSee
//
//  Created by Ross Beale on 18/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSCoreDataTableViewController.h"
#import "SSLocation.h"

@interface SSListViewController : SSCoreDataTableViewController <UIPickerViewDelegate> {
    SSLocation *_tempLocation;
}

- (IBAction)optionsButtonPressed:(id)sender;

@end
