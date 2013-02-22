//
//  SSReviewInformationCell.h
//  SightSee
//
//  Created by Ross Beale on 21/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSBaseLocationCell.h"
#import "ASStarRatingView.h"

@interface SSReviewInformationCell : SSBaseLocationCell

// UI elements
@property (weak, nonatomic) IBOutlet UIView *ratingsDisplayView;
@property (weak, nonatomic) IBOutlet ASStarRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *reviewCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *noReviewsLabel;

@end
