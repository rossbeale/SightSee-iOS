//
//  SSMapViewController.h
//  SightSee
//
//  Created by Ross Beale on 18/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SSLocationMapAnnotation.h"

@interface SSMapViewController : UIViewController <NSFetchedResultsControllerDelegate, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate> {
    SSLocation *_tempLocation;
    BOOL _hasPushed;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (IBAction)optionsButtonPressed:(id)sender;

@end
