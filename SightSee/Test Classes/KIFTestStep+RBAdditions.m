//
//  KIFTestStep+RBAdditions.m
//  SightSee
//
//  Created by Ross Beale on 02/04/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import "KIFTestStep+RBAdditions.h"

@implementation KIFTestStep (RBAdditions)

+ (id)stepToReset;
{
    return [KIFTestStep stepWithDescription:@"Reset the application state." executionBlock:^(KIFTestStep *step, NSError **error) {
        BOOL successfulReset = YES;
        
        // Do the actual reset for your app. Set successfulReset = NO if it fails.
        
        KIFTestCondition(successfulReset, error, @"Failed to reset the application.");
        
        return KIFTestStepResultSuccess;
    }];
}

@end
