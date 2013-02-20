//
//  SSMapAnnotation.m
//  SightSee
//
//  Created by Ross Beale on 19/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import "SSLocationMapAnnotation.h"

@implementation SSLocationMapAnnotation

- (id)initWithLocation:(SSLocation *)location
{
    self = [super init];
    if (self) {
        self.location = location;
        self.coordinate = CLLocationCoordinate2DMake([self.location.lat doubleValue], [self.location.lng doubleValue]);
    }
    return self;
}

- (NSString *)title
{
    return self.location.name;
}

- (NSString *)subtitle
{
    return self.location.desc;
}

@end
