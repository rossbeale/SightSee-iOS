//
//  NSData+AES256.m
//  SightSee
//
//  Created by Ross Beale on 20/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import "NSData+AES256.h"
#import "NSString+Base64.h"

@implementation NSData (AES256)

- (NSData *)AES256EncryptWithKey:(NSString *)key
{
	// 'key' should be 32 bytes for AES256, will be null-padded otherwise
	char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
	bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
	
	// fetch key data
	[key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
	
	NSUInteger dataLength = [self length];
	
	//See the doc: For block ciphers, the output size will always be less than or 
	//equal to the input size plus the size of one block.
	//That's why we need to add the size of one block here
	size_t bufferSize = dataLength + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
	
	size_t numBytesEncrypted = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
										  keyPtr, kCCKeySizeAES256,
										  NULL /* initialization vector (optional) */,
										  [self bytes], dataLength, /* input */
										  buffer, bufferSize, /* output */
										  &numBytesEncrypted);
	if (cryptStatus == kCCSuccess) {
		//the returned NSData takes ownership of the buffer and will free it on deallocation
		return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
	}
	
	free(buffer); //free the buffer;
	return nil;
}

+ (unsigned char *)sha256:(NSString *)string
{
    NSData *dataIn = [string dataUsingEncoding:NSASCIIStringEncoding];
    NSMutableData *macOut = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    
    return CC_SHA256(dataIn.bytes, dataIn.length,  macOut.mutableBytes);
}

// If iv is nil, the first 16 bytes of the data is used
- (NSData *)AES256DecryptWithKey:(NSData *)key andIv:(NSData *)iv
{
    NSData *data = self;
    if (!iv) {
        // pull off the IV as the first 16 bytes
        iv = [self subdataWithRange:NSMakeRange(0, 16)];
        
        // And therefore the data to decrypt is everything from the 16th byte
        data = [self subdataWithRange:NSMakeRange(16, self.length-16)];
    }
    
	//See the doc: For block ciphers, the output size will always be less than or
	//equal to the input size plus the size of one block.
	//That's why we need to add the size of one block here
	size_t bufferSize = data.length + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
	
	size_t numBytesDecrypted = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, 0,
										  [key bytes], kCCKeySizeAES256,
										  [iv bytes], /* initialization vector (optional) */
										  [data bytes], data.length, /* input */
										  buffer, bufferSize, /* output */
										  &numBytesDecrypted);
	
	if (cryptStatus == kCCSuccess) {
		//the returned NSData takes ownership of the buffer and will free it on deallocation
		return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
	} else {
        DLog(@"Crypt error status: %i", cryptStatus);
    }
	
	free(buffer); //free the buffer;
	return nil;    
}

- (NSData *)AES256DecryptWithKeyString:(NSString *)key andIv:(NSData *)iv
{
    // The server SHA256 the key
    NSData *dataIn = [key dataUsingEncoding:NSASCIIStringEncoding];
    NSMutableData *macOut = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    unsigned char *keyPtr = CC_SHA256(dataIn.bytes, dataIn.length, macOut.mutableBytes);
    NSData *dataKey = [NSData dataWithBytes:(const void *)keyPtr length:kCCKeySizeAES256];
    
    return [self AES256DecryptWithKey:dataKey andIv:iv];
}

@end
