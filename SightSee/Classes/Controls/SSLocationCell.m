//
//  SSLocationCell.m
//  SightSee
//
//  Created by Ross Beale on 19/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import "SSLocationCell.h"

#define kTextFrameWidth 300
#define kTextFrameLeftOffset 10
#define kTextFrameBottomOffset 5
#define kCellHeightWithoutDesc 88
#define kCellOtherHeight 95

@implementation SSLocationCell

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![ObservableKeys containsObject:keyPath]) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    if ([LocationKeyPath isEqualToString:keyPath])
    {
        // Update UI
        self.locationNameLabel.text = self.location.name;
        CGSize constraint = CGSizeMake(kTextFrameWidth, 20000.0f);
        CGSize size = [self.location.desc sizeWithFont:[UIFont fontWithName:@"PTSans-Regular" size:self.locationDescriptionLabel.font.pointSize] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        self.locationDescriptionLabel.frame = CGRectMake(self.locationDescriptionLabel.frame.origin.x, self.locationDescriptionLabel.frame.origin.y, size.width, size.height);
        self.locationDescriptionLabel.text = self.location.desc;
        self.locationDistanceLabel.frame = CGRectMake(kTextFrameLeftOffset, self.locationDescriptionLabel.frame.origin.y + self.locationDescriptionLabel.frame.size.height + ((self.location.desc.length == 0 ? 0 : kTextFrameBottomOffset)), self.locationDistanceLabel.frame.size.width, self.locationDistanceLabel.frame.size.height);
        self.locationDistanceLabel.text = [NSString stringWithFormat:@"%0.2f miles away", [self.location.distance floatValue]];
        
        if ([self.location hasReviews]) {
            self.locationNoReviewsLabel.hidden = YES;
            self.locationRatingBar.hidden = NO;
            self.locationRatingBar.frame = CGRectMake(kTextFrameLeftOffset, self.locationDistanceLabel.frame.origin.y + self.locationDistanceLabel.frame.size.height + kTextFrameBottomOffset, self.locationRatingBar.frame.size.width, self.locationRatingBar.frame.size.height);
            self.locationRatingBar.rating = [[self.location averageRating] floatValue];
        } else {
            self.locationRatingBar.hidden = YES;
            self.locationNoReviewsLabel.hidden = NO;
            self.locationNoReviewsLabel.frame = CGRectMake(kTextFrameLeftOffset, self.locationDistanceLabel.frame.origin.y + self.locationDistanceLabel.frame.size.height + kTextFrameBottomOffset, self.locationNoReviewsLabel.frame.size.width, self.locationNoReviewsLabel.frame.size.height);
        }
    }
}

#pragma mark - UI

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.locationRatingBar.canEdit = NO;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
}

+ (CGFloat)heightForCellWithLocation:(SSLocation *)location
{
    CGSize constraint = CGSizeMake(kTextFrameWidth, 20000.0f);
    if (location.desc.length == 0) {
        return kCellHeightWithoutDesc;
    }
    CGSize size = [location.desc sizeWithFont:[UIFont fontWithName:@"PTSans-Regular" size:14.f] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    size.height += kCellOtherHeight;
    return size.height;
}

@end
