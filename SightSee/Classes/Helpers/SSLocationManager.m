//
//  SSManager.m
//  SightSee
//
//  Created by Ross Beale on 18/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import "SSLocationManager.h"

@implementation SSLocationManager

+ (id)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init
{
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.pausesLocationUpdatesAutomatically = YES;
    }
    return self;
}

#pragma mark - SSLocationManager methods

- (void)startLocationServices
{
    [_locationManager startUpdatingLocation];
}

- (void)stopLocationServices
{
    [_locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    // forward on to delegate
    if ([self.delegate respondsToSelector:@selector(locationManagerDidChangeAuthorizationStatus:)]) {
        [self.delegate locationManagerDidChangeAuthorizationStatus:status];
    }
    
    switch (status) {
        case kCLAuthorizationStatusAuthorized:
            NSLog(@"Location authorisation changed to: AUTHORIZED");
            break;
            
        case kCLAuthorizationStatusDenied:
            NSLog(@"Location authorisation changed to: DENIED");
            break;
            
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"Location authorisation changed to: NOT DETERMINED");
            break;
            
        case kCLAuthorizationStatusRestricted:
            NSLog(@"Location authorisation changed to: RESTRICTED");
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //TODO: make this stop only when accurate
    NSLog(@"Location Update Detected");
    [self stopLocationServices];
    
    _location = [locations lastObject];
    [self updatedLocation];
}

- (void)updatedLocation
{
    // forward on to delegate
    if ([self.delegate respondsToSelector:@selector(locationManagedDidUpdateLocationTo:)]) {
        [self.delegate locationManagedDidUpdateLocationTo:_location];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // forward on to delegate
    if ([self.delegate respondsToSelector:@selector(locationManagerDidFailWithError:)]) {
        [self.delegate locationManagerDidFailWithError:error];
    }
}

@end