//
//  SSComposeReviewViewController.h
//  SightSee
//
//  Created by Ross Beale on 21/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASStarRatingView.h"
#import "SSPlaceholderTextView.h"
#import "SSLocation.h"

@interface SSComposeReviewViewController : UIViewController <ASStarRatingViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) SSLocation *location;

// UI elements
@property (weak, nonatomic) IBOutlet ASStarRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *rateHelperLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameInputTextField;
@property (weak, nonatomic) IBOutlet SSPlaceholderTextView *reviewInputTextField;

- (IBAction)sendReviewButtonPressed:(id)sender;

@end
