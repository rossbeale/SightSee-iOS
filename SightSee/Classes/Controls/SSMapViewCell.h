//
//  SSMapViewCell.h
//  SightSee
//
//  Created by Ross Beale on 21/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SSBaseLocationCell.h"

@interface SSMapViewCell : SSBaseLocationCell <MKMapViewDelegate>

// UI elements
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
