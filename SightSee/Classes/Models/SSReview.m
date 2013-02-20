#import "SSReview.h"


@interface SSReview ()

// Private interface goes here.

@end


@implementation SSReview

+ (id)createOfFindReviewWithJSON:(id)reviewJSON
{
    NSNumber *rid = [NSNumber numberWithInteger:[reviewJSON[@"id"] integerValue]];
    NSString *reviewer = reviewJSON[@"reviewer_name"];
    NSString *comment = reviewJSON[@"review_comment"];
    NSNumber *score = [NSNumber numberWithFloat:[reviewJSON[@"review_score"] floatValue]];
    
    SSReview *parsedReview;
    
    NSArray *duplicates = [SSReview whereFormat:@"rid == %@", rid];
    if ([duplicates count] > 0) {
        parsedReview = (SSReview *)[duplicates lastObject];
        parsedReview.reviewer = reviewer;
        parsedReview.comment = comment;
        parsedReview.score = score;
        DLog(@"Returning existing review");
    } else {
        parsedReview = [SSReview create:@{@"rid": rid, @"reviewer" : reviewer, @"comment" : comment, @"score" : score}];
        DLog(@"Returning new review");
    }
    return parsedReview;
}

@end
