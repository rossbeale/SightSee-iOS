//
//  SSLocationCell.h
//  SightSee
//
//  Created by Ross Beale on 19/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASStarRatingView.h"
#import "SSBaseCell.h"

@interface SSLocationCell : SSBaseCell

// UI elements
@property (weak, nonatomic) IBOutlet UILabel *locationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationDistanceLabel;
@property (weak, nonatomic) IBOutlet ASStarRatingView *locationRatingBar;
@property (weak, nonatomic) IBOutlet UILabel *locationNoReviewsLabel;

+ (CGFloat)heightForCellWithLocation:(SSLocation *)location;

@end
