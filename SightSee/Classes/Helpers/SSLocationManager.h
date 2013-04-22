//
//  SSManager.h
//  SightSee
//
//  Created by Ross Beale on 18/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSLocation.h"

@protocol SSLocationManagerDelegate <NSObject>
@optional
- (void)locationManagerDidUpdateLocationTo:(CLLocation *)location;
- (void)locationManagerDidFailWithError:(NSError *)error;
- (void)locationManagerDidChangeAuthorizationStatus:(CLAuthorizationStatus)status;
@end

@interface SSLocationManager : NSObject <CLLocationManagerDelegate> {
    CLLocationManager *_locationManager;
    CLLocation *_location;
}

@property (nonatomic, weak) id<SSLocationManagerDelegate> delegate;

+ (id)sharedInstance;

- (void)startLocationServices;
- (void)stopLocationServices;

- (void)trackLocation:(SSLocation *)location;
- (void)cancelTrackLocation:(SSLocation *)location;
- (void)cancelAllTracking;

@end
