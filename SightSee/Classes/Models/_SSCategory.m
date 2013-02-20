// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SSCategory.m instead.

#import "_SSCategory.h"

const struct SSCategoryAttributes SSCategoryAttributes = {
	.name = @"name",
	.rid = @"rid",
};

const struct SSCategoryRelationships SSCategoryRelationships = {
	.locations = @"locations",
};

const struct SSCategoryFetchedProperties SSCategoryFetchedProperties = {
};

@implementation SSCategoryID
@end

@implementation _SSCategory

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SSCategory" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SSCategory";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SSCategory" inManagedObjectContext:moc_];
}

- (SSCategoryID*)objectID {
	return (SSCategoryID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"ridValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"rid"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic name;






@dynamic rid;



- (int16_t)ridValue {
	NSNumber *result = [self rid];
	return [result shortValue];
}

- (void)setRidValue:(int16_t)value_ {
	[self setRid:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveRidValue {
	NSNumber *result = [self primitiveRid];
	return [result shortValue];
}

- (void)setPrimitiveRidValue:(int16_t)value_ {
	[self setPrimitiveRid:[NSNumber numberWithShort:value_]];
}





@dynamic locations;

	
- (NSMutableSet*)locationsSet {
	[self willAccessValueForKey:@"locations"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"locations"];
  
	[self didAccessValueForKey:@"locations"];
	return result;
}
	






@end
