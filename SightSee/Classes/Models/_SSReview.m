// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SSReview.m instead.

#import "_SSReview.h"

const struct SSReviewAttributes SSReviewAttributes = {
	.comment = @"comment",
	.reviewer = @"reviewer",
	.rid = @"rid",
	.score = @"score",
};

const struct SSReviewRelationships SSReviewRelationships = {
	.location = @"location",
};

const struct SSReviewFetchedProperties SSReviewFetchedProperties = {
};

@implementation SSReviewID
@end

@implementation _SSReview

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SSReview" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SSReview";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SSReview" inManagedObjectContext:moc_];
}

- (SSReviewID*)objectID {
	return (SSReviewID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"ridValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"rid"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"scoreValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"score"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic comment;






@dynamic reviewer;






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





@dynamic score;



- (float)scoreValue {
	NSNumber *result = [self score];
	return [result floatValue];
}

- (void)setScoreValue:(float)value_ {
	[self setScore:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveScoreValue {
	NSNumber *result = [self primitiveScore];
	return [result floatValue];
}

- (void)setPrimitiveScoreValue:(float)value_ {
	[self setPrimitiveScore:[NSNumber numberWithFloat:value_]];
}





@dynamic location;

	






@end
