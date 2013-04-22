//
//  SSManager.m
//  SightSee
//
//  Created by Ross Beale on 18/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import "SSLocationManager.h"
#import "SSNotificationManager.h"

#define kDistanceFilter 500

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
        _locationManager.distanceFilter = kDistanceFilter;
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
            DLog(@"Location authorisation changed to: AUTHORIZED");
            break;
            
        case kCLAuthorizationStatusDenied:
            DLog(@"Location authorisation changed to: DENIED");
            break;
            
        case kCLAuthorizationStatusNotDetermined:
            DLog(@"Location authorisation changed to: NOT DETERMINED");
            break;
            
        case kCLAuthorizationStatusRestricted:
            DLog(@"Location authorisation changed to: RESTRICTED");
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    DLog(@"Location update detected...");
    
    [self stopLocationServices];
        
    _location = [locations lastObject];
    [self updatedLocation];
}

- (void)updatedLocation
{
    // forward on to delegate
    if ([self.delegate respondsToSelector:@selector(locationManagerDidUpdateLocationTo:)]) {
        [self.delegate locationManagerDidUpdateLocationTo:_location];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self stopLocationServices];
    
    // forward on to delegate
    if ([self.delegate respondsToSelector:@selector(locationManagerDidFailWithError:)]) {
        [self.delegate locationManagerDidFailWithError:error];
    }
}

#pragma mark - location manager

- (void)trackLocation:(SSLocation *)location
{
    CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:CLLocationCoordinate2DMake([location.lat doubleValue], [location.lng doubleValue]) radius:kDistanceFilter identifier:[location.rid stringValue]];
    [_locationManager startMonitoringForRegion:region];
}

- (void)cancelTrackLocation:(SSLocation *)location
{
    for (CLRegion *region in [_locationManager monitoredRegions]) {
        if ([region.identifier isEqualToString:[location.rid stringValue]]) {
            [_locationManager stopMonitoringForRegion:region];
        }
    }
}

- (void)cancelAllTracking
{
    for (CLRegion *region in [_locationManager monitoredRegions]) {
        [_locationManager stopMonitoringForRegion:region];
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    // Stop monitoring
    [_locationManager stopMonitoringForRegion:region];
    
    SSLocation *trackedLocation = [[SSLocation whereFormat:@"rid == %@", region.identifier] lastObject];
    [trackedLocation markAsVisited];
    
    [SSNotificationManager presentNotificationWithBody:[NSString stringWithFormat:@"Review %@!", trackedLocation.name] andAction:@"Review" andUserInfo:@{@"locationID": [trackedLocation.rid stringValue]}];
}

@end
