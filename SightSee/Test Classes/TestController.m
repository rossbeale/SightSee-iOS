//
//  TestController.m
//  SightSee
//
//  Created by Ross Beale on 02/04/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import "TestController.h"
#import "KIFTestScenario+RBAdditions.h"

@implementation TestController

- (void)initializeScenarios;
{
    [self addScenario:[KIFTestScenario scenarioToSync]];
}

@end
