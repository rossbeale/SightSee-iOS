//
//  MKMapView+ZoomLevel.m
//  SightSee
//
//  Created by Ross Beale on 21/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import "MKMapView+ZoomLevel.h"

@implementation MKMapView (ZoomLevel)

/// zoomLevel for MKMapView. zoomLevel should be consistent across multiple map views. Use this to set multiple map views to the same zoom level. Does not currently map to Google Map zoom levels - but _could_ be easily.
- (double)zoomLevel
{
    // TODO define new type. TODO should zoomLevel be a CLLocationAccuracy or CLLocationDistance perhaps instead of a double?
    double theZoomLevel = log2(self.visibleMapRect.size.width / self.bounds.size.width);
    return(theZoomLevel);
}

- (void)setZoomLevel:(double)inZoomLevel
{
    [self setCenterCoordinate:self.centerCoordinate zoomLevel:inZoomLevel animated:NO];
}

- (void)setCenterCoordinate:(CLLocationCoordinate2D)inCoordinate zoomLevel:(double)inZoomLevel animated:(BOOL)inAnimated
{
    const MKMapPoint theCurrentCenter = MKMapPointForCoordinate(inCoordinate);
    const double theFector = exp2(inZoomLevel);
    const MKMapSize theSize = {
        .width = self.bounds.size.width * theFector,
        .height = self.bounds.size.height * theFector,
    };
    const MKMapPoint theOrigin = {
        .x = theCurrentCenter.x - theSize.width * 0.5,
        .y = theCurrentCenter.y - theSize.height * 0.5,
    };
    
    self.visibleMapRect =  [self mapRectThatFits:(MKMapRect){ .origin = theOrigin, .size = theSize }];
}

@end
