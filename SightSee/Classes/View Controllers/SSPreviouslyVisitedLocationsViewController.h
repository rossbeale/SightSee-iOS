//
//  SSPreviouslyVisitedLocationsViewController.h
//  SightSee
//
//  Created by Ross Beale on 25/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import "SSCoreDataTableViewController.h"
#import "SSLocation.h"

@interface SSPreviouslyVisitedLocationsViewController : SSCoreDataTableViewController {
    SSLocation *_tempLocation;
}

- (IBAction)closeButtonPressed:(id)sender;

@end
