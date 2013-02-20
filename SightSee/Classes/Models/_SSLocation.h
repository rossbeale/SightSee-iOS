// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SSLocation.h instead.

#import <CoreData/CoreData.h>


extern const struct SSLocationAttributes {
	__unsafe_unretained NSString *desc;
	__unsafe_unretained NSString *distance;
	__unsafe_unretained NSString *lat;
	__unsafe_unretained NSString *lng;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *rid;
} SSLocationAttributes;

extern const struct SSLocationRelationships {
	__unsafe_unretained NSString *categories;
	__unsafe_unretained NSString *reviews;
} SSLocationRelationships;

extern const struct SSLocationFetchedProperties {
} SSLocationFetchedProperties;

@class SSCategory;
@class SSReview;








@interface SSLocationID : NSManagedObjectID {}
@end

@interface _SSLocation : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SSLocationID*)objectID;





@property (nonatomic, strong) NSString* desc;



//- (BOOL)validateDesc:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* distance;



@property float distanceValue;
- (float)distanceValue;
- (void)setDistanceValue:(float)value_;

//- (BOOL)validateDistance:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* lat;



@property double latValue;
- (double)latValue;
- (void)setLatValue:(double)value_;

//- (BOOL)validateLat:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* lng;



@property double lngValue;
- (double)lngValue;
- (void)setLngValue:(double)value_;

//- (BOOL)validateLng:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* rid;



@property int16_t ridValue;
- (int16_t)ridValue;
- (void)setRidValue:(int16_t)value_;

//- (BOOL)validateRid:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *categories;

- (NSMutableSet*)categoriesSet;




@property (nonatomic, strong) NSSet *reviews;

- (NSMutableSet*)reviewsSet;





@end

@interface _SSLocation (CoreDataGeneratedAccessors)

- (void)addCategories:(NSSet*)value_;
- (void)removeCategories:(NSSet*)value_;
- (void)addCategoriesObject:(SSCategory*)value_;
- (void)removeCategoriesObject:(SSCategory*)value_;

- (void)addReviews:(NSSet*)value_;
- (void)removeReviews:(NSSet*)value_;
- (void)addReviewsObject:(SSReview*)value_;
- (void)removeReviewsObject:(SSReview*)value_;

@end

@interface _SSLocation (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveDesc;
- (void)setPrimitiveDesc:(NSString*)value;




- (NSNumber*)primitiveDistance;
- (void)setPrimitiveDistance:(NSNumber*)value;

- (float)primitiveDistanceValue;
- (void)setPrimitiveDistanceValue:(float)value_;




- (NSNumber*)primitiveLat;
- (void)setPrimitiveLat:(NSNumber*)value;

- (double)primitiveLatValue;
- (void)setPrimitiveLatValue:(double)value_;




- (NSNumber*)primitiveLng;
- (void)setPrimitiveLng:(NSNumber*)value;

- (double)primitiveLngValue;
- (void)setPrimitiveLngValue:(double)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitiveRid;
- (void)setPrimitiveRid:(NSNumber*)value;

- (int16_t)primitiveRidValue;
- (void)setPrimitiveRidValue:(int16_t)value_;





- (NSMutableSet*)primitiveCategories;
- (void)setPrimitiveCategories:(NSMutableSet*)value;



- (NSMutableSet*)primitiveReviews;
- (void)setPrimitiveReviews:(NSMutableSet*)value;


@end
