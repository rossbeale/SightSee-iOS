#import "_SSLocation.h"
#import "SSCategory.h"
#import "SSReview.h"

@interface SSLocation : _SSLocation

+ (void)parseLocationJSON:(id)locationJSON;

+ (id)createOfFindLocationWithJSON:(id)locationJSON;

- (BOOL)hasDescription;

- (BOOL)hasReviews;

- (NSNumber *)averageRating;

@end
