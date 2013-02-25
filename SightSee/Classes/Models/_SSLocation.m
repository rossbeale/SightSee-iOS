// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SSLocation.m instead.

#import "_SSLocation.h"

const struct SSLocationAttributes SSLocationAttributes = {
	.desc = @"desc",
	.distance = @"distance",
	.lat = @"lat",
	.lng = @"lng",
	.name = @"name",
	.rid = @"rid",
	.visiting = @"visiting",
};

const struct SSLocationRelationships SSLocationRelationships = {
	.categories = @"categories",
	.reviews = @"reviews",
};

const struct SSLocationFetchedProperties SSLocationFetchedProperties = {
};

@implementation SSLocationID
@end

@implementation _SSLocation

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SSLocation" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SSLocation";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SSLocation" inManagedObjectContext:moc_];
}

- (SSLocationID*)objectID {
	return (SSLocationID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"distanceValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"distance"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"latValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"lat"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"lngValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"lng"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"ridValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"rid"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"visitingValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"visiting"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic desc;






@dynamic distance;



- (float)distanceValue {
	NSNumber *result = [self distance];
	return [result floatValue];
}

- (void)setDistanceValue:(float)value_ {
	[self setDistance:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveDistanceValue {
	NSNumber *result = [self primitiveDistance];
	return [result floatValue];
}

- (void)setPrimitiveDistanceValue:(float)value_ {
	[self setPrimitiveDistance:[NSNumber numberWithFloat:value_]];
}





@dynamic lat;



- (double)latValue {
	NSNumber *result = [self lat];
	return [result doubleValue];
}

- (void)setLatValue:(double)value_ {
	[self setLat:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLatValue {
	NSNumber *result = [self primitiveLat];
	return [result doubleValue];
}

- (void)setPrimitiveLatValue:(double)value_ {
	[self setPrimitiveLat:[NSNumber numberWithDouble:value_]];
}





@dynamic lng;



- (double)lngValue {
	NSNumber *result = [self lng];
	return [result doubleValue];
}

- (void)setLngValue:(double)value_ {
	[self setLng:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLngValue {
	NSNumber *result = [self primitiveLng];
	return [result doubleValue];
}

- (void)setPrimitiveLngValue:(double)value_ {
	[self setPrimitiveLng:[NSNumber numberWithDouble:value_]];
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





@dynamic visiting;



- (BOOL)visitingValue {
	NSNumber *result = [self visiting];
	return [result boolValue];
}

- (void)setVisitingValue:(BOOL)value_ {
	[self setVisiting:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveVisitingValue {
	NSNumber *result = [self primitiveVisiting];
	return [result boolValue];
}

- (void)setPrimitiveVisitingValue:(BOOL)value_ {
	[self setPrimitiveVisiting:[NSNumber numberWithBool:value_]];
}





@dynamic categories;

	
- (NSMutableSet*)categoriesSet {
	[self willAccessValueForKey:@"categories"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"categories"];
  
	[self didAccessValueForKey:@"categories"];
	return result;
}
	

@dynamic reviews;

	
- (NSMutableSet*)reviewsSet {
	[self willAccessValueForKey:@"reviews"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"reviews"];
  
	[self didAccessValueForKey:@"reviews"];
	return result;
}
	






@end
