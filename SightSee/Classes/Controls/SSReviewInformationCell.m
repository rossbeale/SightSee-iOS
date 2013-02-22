//
//  SSReviewInformationCell.m
//  SightSee
//
//  Created by Ross Beale on 21/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import "SSReviewInformationCell.h"

@implementation SSReviewInformationCell

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![ObservableKeys containsObject:keyPath]) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    if ([LocationKeyPath isEqualToString:keyPath])
    {
        if ([self.location hasReviews]) {
            self.noReviewsLabel.hidden = YES;
            self.ratingsDisplayView.hidden = NO;
            self.ratingView.rating = [[self.location averageRating] floatValue];
        } else {
            self.ratingsDisplayView.hidden = YES;
            self.noReviewsLabel.hidden = NO;
        }
    }
}

#pragma mark - UI

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.ratingView.canEdit = NO;
}

- (void)prepareForReuse
{
    
}

@end
