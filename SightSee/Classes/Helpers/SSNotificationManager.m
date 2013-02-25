//
//  SSNotificationManager.m
//  SightSee
//
//  Created by Ross Beale on 25/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import "SSNotificationManager.h"

@implementation SSNotificationManager

+ (void)presentNotificationWithBody:(NSString *)body andAction:(NSString *)action andUserInfo:(NSDictionary *)userInfo
{
    // Send local notification
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = body;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.alertAction = action;
    localNotification.userInfo = userInfo;
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

@end
