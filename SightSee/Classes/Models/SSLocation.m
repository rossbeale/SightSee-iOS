#import "SSLocation.h"
#import "SSLocationManager.h"

@interface SSLocation ()
@end


@implementation SSLocation

+ (void)parseLocationJSON:(id)locationJSON
{
    SSLocation *parsedLocation = [self createOfFindLocationWithJSON:locationJSON];
    
    NSArray *categories = locationJSON[@"categories"];
    for (id category in categories) {
        SSCategory *createdCategory = [SSCategory createOfFindCategoryWithJSON:category];
        [parsedLocation addCategoriesObject:createdCategory];
    }
    
    NSArray *reviews = locationJSON[@"reviews"];
    for (id review in reviews) {
        SSReview *createdReview = [SSReview createOfFindReviewWithJSON:review];
        [parsedLocation addReviewsObject:createdReview];
    }
    
}

+ (id)createOfFindLocationWithJSON:(id)locationJSON
{
    NSNumber *rid = [NSNumber numberWithInteger:[locationJSON[@"id"] integerValue]];
    NSString *desc = locationJSON[@"description"];
    NSString *name = locationJSON[@"name"];
    NSNumber *distance = [NSNumber numberWithDouble:[locationJSON[@"distance_formatted"] doubleValue]];
    NSNumber *lat = [NSNumber numberWithDouble:[locationJSON[@"lat"] doubleValue]];
    NSNumber *lng = [NSNumber numberWithDouble:[locationJSON[@"lng"] doubleValue]];
    
    SSLocation *parsedLocation;
    
    NSArray *duplicates = [SSLocation whereFormat:@"rid == %@", rid];
    if ([duplicates count] > 0) {
        
        parsedLocation = (SSLocation *)[duplicates lastObject];
        parsedLocation.name = name;
        parsedLocation.desc = desc;
        parsedLocation.distance = distance;
        parsedLocation.lat = lat;
        parsedLocation.lng = lng;
        
        DLog(@"Returning (existing) location");
        
    } else {
        
        parsedLocation = [SSLocation create:@{@"rid" : rid, @"desc" : desc, @"name" : name, @"distance" : distance, @"lat" : lat, @"lng" : lng}];
        
        DLog(@"Returning new location");
    }
    
    return parsedLocation;
}

- (BOOL)hasDescription
{
    return ([self.desc length] > 0);
}

- (BOOL)hasReviews
{
    return ([self.reviews count] > 0);
}

- (NSNumber *)averageRating
{
    return [self.reviews valueForKeyPath:@"@avg.score"];
}

- (BOOL)isVisiting
{
    return [self.visiting boolValue];
}

- (void)cancelVisiting
{
    self.visiting = [NSNumber numberWithBool:NO];
    [[SSLocationManager sharedInstance] cancelTrackLocation:self];
}

- (void)markAsVisiting
{
    self.visiting = [NSNumber numberWithBool:YES];
    [[SSLocationManager sharedInstance] trackLocation:self];
}

- (void)markAsVisited
{
    self.visiting = [NSNumber numberWithBool:NO];
}

@end
