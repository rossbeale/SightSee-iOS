// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SSReview.h instead.

#import <CoreData/CoreData.h>


extern const struct SSReviewAttributes {
	__unsafe_unretained NSString *comment;
	__unsafe_unretained NSString *reviewer;
	__unsafe_unretained NSString *rid;
	__unsafe_unretained NSString *score;
} SSReviewAttributes;

extern const struct SSReviewRelationships {
	__unsafe_unretained NSString *location;
} SSReviewRelationships;

extern const struct SSReviewFetchedProperties {
} SSReviewFetchedProperties;

@class SSLocation;






@interface SSReviewID : NSManagedObjectID {}
@end

@interface _SSReview : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SSReviewID*)objectID;





@property (nonatomic, strong) NSString* comment;



//- (BOOL)validateComment:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* reviewer;



//- (BOOL)validateReviewer:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* rid;



@property int16_t ridValue;
- (int16_t)ridValue;
- (void)setRidValue:(int16_t)value_;

//- (BOOL)validateRid:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* score;



@property float scoreValue;
- (float)scoreValue;
- (void)setScoreValue:(float)value_;

//- (BOOL)validateScore:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) SSLocation *location;

//- (BOOL)validateLocation:(id*)value_ error:(NSError**)error_;





@end

@interface _SSReview (CoreDataGeneratedAccessors)

@end

@interface _SSReview (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveComment;
- (void)setPrimitiveComment:(NSString*)value;




- (NSString*)primitiveReviewer;
- (void)setPrimitiveReviewer:(NSString*)value;




- (NSNumber*)primitiveRid;
- (void)setPrimitiveRid:(NSNumber*)value;

- (int16_t)primitiveRidValue;
- (void)setPrimitiveRidValue:(int16_t)value_;




- (NSNumber*)primitiveScore;
- (void)setPrimitiveScore:(NSNumber*)value;

- (float)primitiveScoreValue;
- (void)setPrimitiveScoreValue:(float)value_;





- (SSLocation*)primitiveLocation;
- (void)setPrimitiveLocation:(SSLocation*)value;


@end
