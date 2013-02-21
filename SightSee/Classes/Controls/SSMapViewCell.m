//
//  SSMapViewCell.m
//  SightSee
//
//  Created by Ross Beale on 21/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import "SSMapViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "SSLocationMapAnnotation.h"
#import "MKMapView+ZoomLevel.h"

@implementation SSMapViewCell

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![ObservableKeys containsObject:keyPath]) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    if ([LocationKeyPath isEqualToString:keyPath])
    {
        id oldObj = [change objectForKey:NSKeyValueChangeOldKey];
        id newObj = [change objectForKey:NSKeyValueChangeNewKey];
        
        if (![oldObj isEqual:newObj]) {
            
            // Update UI
            // Add a pin to Map
            SSLocationMapAnnotation *mapAnnotation = [[SSLocationMapAnnotation alloc] initWithLocation:self.location];
            [self.mapView addAnnotation:mapAnnotation];
            [self.mapView setCenterCoordinate:mapAnnotation.coordinate zoomLevel:3 animated:YES];
        }
    }
}

#pragma mark - UI

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.mapView.layer.cornerRadius = 8;
    self.clipsToBounds = YES;
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [mapView setUserTrackingMode:MKUserTrackingModeNone animated:NO];
}

@end
