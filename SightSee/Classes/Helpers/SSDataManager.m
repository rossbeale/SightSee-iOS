//
//  SSDataManager.m
//  SightSee
//
//  Created by Ross Beale on 18/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import "SSDataManager.h"
#import "SSLocation.h"
#import "NSData+AES256.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"

@implementation SSDataManager

+ (id)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init
{
    self = [super init];
    if (self) {
        [[SSLocationManager sharedInstance] setDelegate:self];
    }
    return self;
}

#pragma mark - Fetching location and then data from Server methods

- (void)fetchData
{
    // First, display an overlay...
    //[SVProgressHUD showWithStatus:@"Fetching location..." maskType:SVProgressHUDMaskTypeGradient];
    
    // Then, fetch location...
    //[[SSLocationManager sharedInstance] startLocationServices];
}

- (void)locationManagedDidUpdateLocationTo:(CLLocation *)location
{
    [[SSLocationManager sharedInstance] setDelegate:nil];
    
    // Update overlay...
    [SVProgressHUD showWithStatus:@"Fetching data..." maskType:SVProgressHUDMaskTypeGradient];
    
    DLog(@"Fetching data for location: %@", location);
    [[SSSightSeeAPIHTTPClient sharedInstance] getLocationsWithLocation:location success:^(AFHTTPRequestOperation *operation, id JSON) {
        
        if ([JSON isKindOfClass:[NSDictionary class]]) {
            DLog(@"Encrypted JSON");
            JSON = [self decryptJSON:JSON[@"response"]];
            NSLog(@"%@", JSON);
        } else {
            DLog(@"Unencrypted JSON");
        }
        
        DLog(@"Fetched JSON: %@", JSON);
        [self parseAndStoreJSON:JSON];
        [SVProgressHUD showSuccessWithStatus:@"Fetched!"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //TODO: failure
    }];
}

- (void)locationManagerDidChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    //TODO: this
}

- (void)locationManagerDidFailWithError:(NSError *)error
{
    //TODO: this
}

#pragma mark - Posting reviews to server management

- (void)postReviewToServer:(SSReview *)review forLocation:(SSLocation *)location;
{
    [SVProgressHUD showWithStatus:@"Sending review..." maskType:SVProgressHUDMaskTypeGradient];
}

#pragma mark - Data management methods

- (id)decryptJSON:(id)JSON
{
    NSString *AESKey = @"1";
    
    NSData *decodedData = [JSON base64DecodedData];
    NSData *decryptedData = [decodedData AES256DecryptWithKeyString:AESKey andIv:nil];
    
    // remove control characters
    NSString *decryptedString = [[[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding] stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
    id decryptedJSON = [NSJSONSerialization JSONObjectWithData:[decryptedString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    return decryptedJSON;
}

- (void)parseAndStoreJSON:(id)JSON
{
    [self deleteAllData];
    DLog(@"Parsing...");
    for (id location in JSON) {
        [SSLocation parseLocationJSON:location];
    }
    DLog(@"Finished parsing");
    [self saveData];
}

- (void)deleteAllData
{
    DLog(@"Deleting all data...");
    // Delete all locations
    [SSLocation deleteAll];
    
    // Delete all reviews
    [SSReview deleteAll];
    
    // Delete all categories
    [SSCategory deleteAll];
    DLog(@"All data deleted...");
}

- (void)saveData
{
    if ([[CoreDataManager instance] saveContext]) {
        DLog(@"Data was saved.");
    } else {
        DLog(@"Data was NOT saved.");
    }
}

@end
