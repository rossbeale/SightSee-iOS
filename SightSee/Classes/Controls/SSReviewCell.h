//
//  SSReviewCell.h
//  SightSee
//
//  Created by Ross Beale on 22/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASStarRatingView.h"
#import "SSReview.h"

static NSString * const ReviewKeyPath = @"review";

@interface SSReviewCell : UITableViewCell {
@protected
    NSSet *ObservableKeys;
}

@property (nonatomic, weak) SSReview *review;

// UI elements
@property (weak, nonatomic) IBOutlet ASStarRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *posterLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

+ (CGFloat)heightForCellWithLocation:(SSReview *)review;

@end
