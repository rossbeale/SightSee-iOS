//
//  SSPreferencesManager.h
//  SightSee
//
//  Created by Ross Beale on 18/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kUserDefaultsKeyStartingTab = 100,
    kUserDefaultsKeyFilterID = 200,
    kUserDefaultKeyDeviceIdentifier = 300,
    kUserDefaultsKeyReviewUsername = 400
} kUserDefaultsKey;

@interface SSPreferencesManager : NSObject

+ (NSString *)userDefaultsKeyNameForKey:(kUserDefaultsKey)key;
+ (id)userDefaultForKey:(kUserDefaultsKey)key;
+ (void)setUserDefaultValue:(id)value forKey:(kUserDefaultsKey)key;

+ (NSString *)deviceIdentifier;
+ (NSString *)reviewUsername;
+ (void)setReviewUsername:(NSString *)username;

@end
