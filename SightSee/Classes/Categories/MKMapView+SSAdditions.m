//
//  MKMapView+SSAdditions.m
//  SightSee
//
//  Created by Ross Beale on 25/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import "MKMapView+SSAdditions.h"

@implementation MKMapView (SSAdditions)

- (void)fitAllPoints:(BOOL)animated
{
    MKMapRect zoomRect = MKMapRectNull;
    if (self.userLocation) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(self.userLocation.coordinate);
        zoomRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
    }
    
    for (id <MKAnnotation> annotation in self.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    [self setVisibleMapRect:zoomRect edgePadding:UIEdgeInsetsMake(20, 20, 20, 20) animated:animated];
}

@end
