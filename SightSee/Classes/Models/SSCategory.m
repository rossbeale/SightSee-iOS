#import "SSCategory.h"


@interface SSCategory ()

// Private interface goes here.

@end


@implementation SSCategory

+ (id)createOfFindCategoryWithJSON:(id)categoryJSON
{
    NSNumber *rid = [NSNumber numberWithInteger:[categoryJSON[@"id"] integerValue]];
    NSString *name = categoryJSON[@"name"];
    
    SSCategory *parsedCategory;
    NSArray *duplicates = [SSCategory whereFormat:@"rid == %@", rid];
    if ([duplicates count] > 0) {
        parsedCategory = (SSCategory *)[duplicates lastObject];
        parsedCategory.name = name;
        DLog(@"Returning existing category");
    } else {
        parsedCategory = [SSCategory create:@{@"rid": rid, @"name" : name}];
        DLog(@"Returning new category");
    }
    return parsedCategory;
}

@end
