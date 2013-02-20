//
//  SSMapAnnotation.h
//  SightSee
//
//  Created by Ross Beale on 19/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "SSLocation.h"

@interface SSLocationMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong) SSLocation *location;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

- (id)initWithLocation:(SSLocation *)location;

@end
