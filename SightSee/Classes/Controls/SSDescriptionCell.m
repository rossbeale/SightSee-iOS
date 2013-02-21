//
//  SSDescriptionCell.m
//  SightSee
//
//  Created by Ross Beale on 21/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import "SSDescriptionCell.h"

#define kTextFrameWidth 278
#define kTextFrameLeftOffset 12
#define kTextFrameTopOffset 11
#define kTextFrameBottomOffset 11

@implementation SSDescriptionCell

+ (CGFloat)heightForCellWithDescription:(NSString *)description
{
    CGSize constraint = CGSizeMake(kTextFrameWidth, 20000.0f);
    if (description.length == 0) {
        return 0.f;
    }
    CGSize size = [description sizeWithFont:[UIFont fontWithName:@"PTSans-Regular" size:14.f] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    size.height += (kTextFrameTopOffset + kTextFrameBottomOffset);
    return size.height;
}

@end
