//
//  SSDataManager.h
//  SightSee
//
//  Created by Ross Beale on 18/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSLocationManager.h"
#import "SSSightSeeAPIHTTPClient.h"
#import "SSReview.h"

#define kUpdateNotificationName @"UpdateNotification"

typedef void (^CompletionWithBooleanBlock)(BOOL success, NSError *error);

@interface SSDataManager : NSObject <SSLocationManagerDelegate>

+ (id)sharedInstance;

- (void)fetchData;

- (void)postReviewToServer:(SSReview *)review forLocation:(SSLocation *)location withCompletion:(CompletionWithBooleanBlock)completionBlock;

@end
