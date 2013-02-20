//
//  SSLocationCell.h
//  SightSee
//
//  Created by Ross Beale on 19/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASStarRatingView.h"
#import "SSLocation.h"

static NSString * const LocationKeyPath = @"location";

@interface SSLocationCell : UITableViewCell {
@protected
    NSSet *ObservableKeys;
}

@property (nonatomic, weak) SSLocation *location;

// UI elements
@property (weak, nonatomic) IBOutlet UILabel *locationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationDistanceLabel;
@property (weak, nonatomic) IBOutlet ASStarRatingView *locationRatingBar;

+ (CGFloat)heightForCellWithLocation:(SSLocation *)location;

@end
