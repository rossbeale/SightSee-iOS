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

@interface SSDataManager : NSObject <SSLocationManagerDelegate>

+ (id)sharedInstance;

- (void)fetchData;

@end
