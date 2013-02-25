//
//  SSPreferencesManager.m
//  SightSee
//
//  Created by Ross Beale on 18/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import "SSPreferencesManager.h"

@implementation SSPreferencesManager

#pragma mark - NSUserDefaults

+ (NSString *)userDefaultsKeyNameForKey:(kUserDefaultsKey)key
{
    return [NSString stringWithFormat:@"UserDefaultKey%i", key];
}

+ (id)userDefaultForKey:(kUserDefaultsKey)key
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:[self userDefaultsKeyNameForKey:key]];
}

+ (void)setUserDefaultValue:(id)value forKey:(kUserDefaultsKey)key
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:value forKey:[self userDefaultsKeyNameForKey:key]];
    [ud synchronize];
}

#pragma mark - UDID

+ (NSString *)deviceIdentifier
{
    NSString *deviceId = [self userDefaultForKey:kUserDefaultKeyDeviceIdentifier];
    
    if (!deviceId) {
        CFUUIDRef theUUID = CFUUIDCreate(NULL);
        deviceId = (__bridge_transfer NSString*)CFUUIDCreateString(NULL, theUUID);
        CFRelease(theUUID);
        [self setUserDefaultValue:deviceId forKey:kUserDefaultKeyDeviceIdentifier];
    }
    
    return deviceId;
}

+ (NSString *)reviewUsername
{
    return [self userDefaultForKey:kUserDefaultsKeyReviewUsername];
}

+ (void)setReviewUsername:(NSString *)username
{
    [self setUserDefaultValue:username forKey:kUserDefaultsKeyReviewUsername];
}

@end
