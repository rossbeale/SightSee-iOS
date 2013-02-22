//
//  SSComposeReviewViewController.m
//  SightSee
//
//  Created by Ross Beale on 21/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import "SSComposeReviewViewController.h"
#import "SSDataManager.h"

@interface SSComposeReviewViewController ()

@end

@implementation SSComposeReviewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.ratingView setRating:0];
    self.ratingView.delegate = self;
    [self.nameInputTextField becomeFirstResponder];
    
    [self setupFonts];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupFonts
{
    [self.rateHelperLabel setFont:[UIFont fontWithName:@"PTSans-Regular" size:self.rateHelperLabel.font.pointSize]];
    [self.nameInputTextField setFont:[UIFont fontWithName:@"PTSans-Regular" size:self.nameInputTextField.font.pointSize]];
    [self.reviewInputTextField setFont:[UIFont fontWithName:@"PTSans-Regular" size:self.reviewInputTextField.font.pointSize]];
}

- (void)focusNameInputField
{
    [self.nameInputTextField becomeFirstResponder];
}

- (void)focusReviewInputField
{
    [self.reviewInputTextField becomeFirstResponder];
}

#pragma mark - ASStarRatingView delegate

- (void)ratingDidUpdate
{
    [self hideRatingHintLabel:YES];
}

- (void)hideRatingHintLabel:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.1 animations:^{
            self.rateHelperLabel.alpha = 0;
        } completion:^(BOOL finished) {
            self.rateHelperLabel.hidden = YES;
        }];
    } else {
        self.rateHelperLabel.hidden = YES;
    }
}

#pragma mark - TextView delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.reviewInputTextField becomeFirstResponder];
    return YES;
}

#pragma mark - utilities

- (NSString *)validatedNameText
{
    return [self.nameInputTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)validatedReviewText
{
    return [self.reviewInputTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark - UI interaction

- (IBAction)sendReviewButtonPressed:(id)sender
{
    if ([self validateFormValues]) {
        SSReview *createdReview = [SSReview create:@{@"score": [NSNumber numberWithFloat:self.ratingView.rating], @"reviewer" : [self validatedNameText], @"comment" : [self validatedReviewText]}];
        [[SSDataManager sharedInstance] postReviewToServer:createdReview forLocation:self.location withCompletion:^(BOOL success) {
            if (success) {
                [self popBack];
            } else {
                //TODO: not a success
            }
        }];
    }
}

- (BOOL)validateFormValues
{
    if (self.ratingView.rating == 0) {
        [self showAlertMessage:@"You must input a rating."];
        return NO;
    } else if ([self validatedNameText].length == 0) {
        [self showAlertMessage:@"You must input a name."];
        return NO;
    }
    return YES;
}

- (void)showAlertMessage:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

@end
