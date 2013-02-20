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

@end
