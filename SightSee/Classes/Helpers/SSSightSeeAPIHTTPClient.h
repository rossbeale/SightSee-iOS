//
//  SSSightSeeAPIHTTPClient.h
//  SightSee
//
//  Created by Ross Beale on 18/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

@interface SSSightSeeAPIHTTPClient : AFHTTPClient

+ (id)sharedInstance;

- (void)getLocationsWithLocation:(CLLocation *)location success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
