//
//  NSString+SHA1.m
//  SightSee
//
//  Created by Ross Beale on 22/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import "NSString+SHA1.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (SHA1)

- (NSString *)SHA1
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

@end
