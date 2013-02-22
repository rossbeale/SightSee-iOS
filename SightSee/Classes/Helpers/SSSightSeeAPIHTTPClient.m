//
//  SSSightSeeAPIHTTPClient.m
//  SightSee
//
//  Created by Ross Beale on 18/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import "SSSightSeeAPIHTTPClient.h"
#import "SSPreferencesManager.h"
#import "NSString+SHA1.h"

#define kDiffbotAPIBaseURLString @"http://localhost:3000"

@implementation SSSightSeeAPIHTTPClient

+ (id)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] initWithBaseURL:[NSURL URLWithString:self.baseURL]];
    });
    return _sharedObject;
}

+ (NSString *)baseURL
{
    return kDiffbotAPIBaseURLString;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self setParameterEncoding:AFJSONParameterEncoding];
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

- (void)getLocationsWithLocation:(CLLocation *)location success:(void (^)(AFHTTPRequestOperation *operation, id JSON))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSNumber *lat = [NSNumber numberWithDouble:location.coordinate.latitude];
    NSNumber *lng = [NSNumber numberWithDouble:location.coordinate.longitude];
    [self getPath:@"locations" parameters:@{@"lat" : lat, @"lng" : lng, @"uid" : [[SSPreferencesManager deviceIdentifier] SHA1]} success:success failure:failure];
}

- (void)postReviewWithName:(NSString *)name andReview:(NSString *)review andScore:(NSString *)score forLocation:(NSString *)locationID success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self postPath:@"reviews" parameters:@{@"review_location" : locationID, @"reviewer_name" : name, @"review_comment" : review, @"review_score" : score, @"uid" : [[SSPreferencesManager deviceIdentifier] SHA1]} success:success failure:failure];
}

@end
