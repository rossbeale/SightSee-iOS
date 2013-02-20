// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SSCategory.h instead.

#import <CoreData/CoreData.h>


extern const struct SSCategoryAttributes {
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *rid;
} SSCategoryAttributes;

extern const struct SSCategoryRelationships {
	__unsafe_unretained NSString *locations;
} SSCategoryRelationships;

extern const struct SSCategoryFetchedProperties {
} SSCategoryFetchedProperties;

@class SSLocation;




@interface SSCategoryID : NSManagedObjectID {}
@end

@interface _SSCategory : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SSCategoryID*)objectID;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* rid;



@property int16_t ridValue;
- (int16_t)ridValue;
- (void)setRidValue:(int16_t)value_;

//- (BOOL)validateRid:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *locations;

- (NSMutableSet*)locationsSet;





@end

@interface _SSCategory (CoreDataGeneratedAccessors)

- (void)addLocations:(NSSet*)value_;
- (void)removeLocations:(NSSet*)value_;
- (void)addLocationsObject:(SSLocation*)value_;
- (void)removeLocationsObject:(SSLocation*)value_;

@end

@interface _SSCategory (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitiveRid;
- (void)setPrimitiveRid:(NSNumber*)value;

- (int16_t)primitiveRidValue;
- (void)setPrimitiveRidValue:(int16_t)value_;





- (NSMutableSet*)primitiveLocations;
- (void)setPrimitiveLocations:(NSMutableSet*)value;


@end
