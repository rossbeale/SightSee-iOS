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
            [self fitAllPointsOnMapView:NO];
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

- (void)fitAllPointsOnMapView:(BOOL)animated
{
    //http://stackoverflow.com/questions/4680649/zooming-mkmapview-to-fit-annotation-pins
    
    MKMapRect zoomRect = MKMapRectNull;
    if (self.mapView.userLocation) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(self.mapView.userLocation.coordinate);
        zoomRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
    }
    for (id <MKAnnotation> annotation in self.mapView.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        if (MKMapRectIsNull(zoomRect)) {
            zoomRect = pointRect;
        } else {
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
    }
    [self.mapView setVisibleMapRect:zoomRect animated:animated];
}

@end
