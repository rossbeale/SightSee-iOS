//
//  SSNotificationManager.h
//  SightSee
//
//  Created by Ross Beale on 25/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSNotificationManager : NSObject

+ (void)presentNotificationWithBody:(NSString *)body andAction:(NSString *)action andUserInfo:(NSDictionary *)userInfo;

@end
