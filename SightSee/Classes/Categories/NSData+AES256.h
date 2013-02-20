//
//  SNSData+AES256.h
//  SightSee
//
//  Created by Ross Beale on 20/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES256)

+ (unsigned char *)sha256:(NSString *)string;
- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKeyString:(NSString *)key andIv:(NSData *)iv;
- (NSData *)AES256DecryptWithKey:(NSData *)key andIv:(NSData *)iv;

@end
