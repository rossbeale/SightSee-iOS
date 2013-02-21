//
//  SSReviewInformationCell.h
//  SightSee
//
//  Created by Ross Beale on 21/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSBaseCell.h"
#import "ASStarRatingView.h"

@interface SSReviewInformationCell : SSBaseCell

// UI elements
@property (weak, nonatomic) IBOutlet UIView *ratingsDisplayView;
@property (weak, nonatomic) IBOutlet ASStarRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *reviewCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *noReviewsLabel;

@end
