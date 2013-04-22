//
//  KIFTestScenario+RBAdditions.m
//  SightSee
//
//  Created by Ross Beale on 02/04/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import "KIFTestScenario+RBAdditions.h"
#import "KIFTestStep.h"
#import "KIFTestStep+RBAdditions.h"

@implementation KIFTestScenario (RBAdditions)

+ (id)scenarioToSync
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a user can successfully sync data."];
    [scenario addStep:[KIFTestStep stepToReset]];

    // Verify that the sync succeeded
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Data"]];
    
    return scenario;
}

+ (id)scenarioToViewReview
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a user can successfully view reviews."];
    [scenario addStep:[KIFTestStep stepToReset]];
    
    // Verify that the a review is present
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Data"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"View Reviews"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Review"]];
    
    return scenario;
}

+ (id)scenarioToAddReview
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a user can successfully add a review."];
    [scenario addStep:[KIFTestStep stepToReset]];
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Data"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Write Review"]];
    [scenario addStep:[KIFTestStep stepToEnterText:@"Test Name" intoViewWithAccessibilityLabel:@"Name"]];
    [scenario addStep:[KIFTestStep stepToEnterText:@"Test Review Comment" intoViewWithAccessibilityLabel:@"Review Comment"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Review Score"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Review"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Review"]];
    
    return scenario;
}

@end
