//
//  NSManagedObject+ActiveRecord.m
//  WidgetPush
//
//  Created by Marin Usalj on 4/15/12.
//  Copyright (c) 2012 http://mneorr.com. All rights reserved.
//

#import "NSManagedObject+ActiveRecord.h"

@implementation NSManagedObjectContext (ActiveRecord)

+ (NSManagedObjectContext *)defaultContext {
    return [[CoreDataManager instance] managedObjectContext];
}
@end

@implementation NSManagedObject (ActiveRecord)

#pragma mark - Finders

+ (NSArray *)all {
    return [self allOrderBy:nil ascending:NO inContext:[NSManagedObjectContext defaultContext]];
}

+ (NSArray *)allOrderBy:(NSString *)orderBy ascending:(BOOL)ascending {
    return [self allOrderBy:orderBy ascending:ascending inContext:[NSManagedObjectContext defaultContext]];
}

+ (NSArray *)allOrderBy:(NSString *)orderBy ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context {
    
    if (orderBy) {
        return [self fetchWithPredicate:nil andDescriptor:[NSSortDescriptor sortDescriptorWithKey:orderBy ascending:ascending] inContext:context];
    } else {
        
        return [self fetchWithPredicate:nil andDescriptor:nil inContext:context];
    }
}

+ (NSArray *)whereFormat:(NSString *)format, ... {
    va_list va_arguments;
    va_start(va_arguments, format);
    NSString *condition = [[NSString alloc] initWithFormat:format arguments:va_arguments];
    va_end(va_arguments);

    return [self where:condition];
}

+ (NSArray *)where:(id)condition {
    
    return [self where:condition
             inContext:[NSManagedObjectContext defaultContext]];
}

+ (NSArray *)where:(id)condition inContext:(NSManagedObjectContext *)context {
    
    NSPredicate *predicate = ([condition isKindOfClass:[NSPredicate class]]) ? condition :
                                                [self predicateFromStringOrDict:condition];
    
    return [self fetchWithPredicate:predicate
                          andDescriptor:nil
                          inContext:context];
}


#pragma mark - Creation / Deletion

+ (id)create {
    return [self createInContext:[NSManagedObjectContext defaultContext]];
}

+ (id)create:(NSDictionary *)attributes {
    return [self create:attributes
              inContext:[NSManagedObjectContext defaultContext]];
}

+ (id)create:(NSDictionary *)attributes inContext:(NSManagedObjectContext *)context {
    NSManagedObject *newEntity = [self createInContext:context];
    
    [newEntity setValuesForKeysWithDictionary:attributes];
    return newEntity;
}

+ (id)createInContext:(NSManagedObjectContext *)context {
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self)
                                         inManagedObjectContext:context];
}

- (BOOL)save {
    return [self saveTheContext];
}

- (void)delete {
    [self.managedObjectContext deleteObject:self];
    [self saveTheContext];
}

+ (void)deleteAll {
    
    [self deleteAllInContext:[NSManagedObjectContext defaultContext]];
}

+ (void)deleteAllInContext:(NSManagedObjectContext *)context {
    
    [[self allOrderBy:nil ascending:nil inContext:context] each:^(id object) {
        [object delete];
    }];
}

#pragma mark - Private

+ (NSString *)queryStringFromDictionary:(NSDictionary *)conditions {
    NSMutableString *queryString = [NSMutableString new];
    
    [conditions.allKeys each:^(id attribute) {
        [queryString appendFormat:@"%@ == '%@'", attribute, [conditions valueForKey:attribute]];

        if (attribute == conditions.allKeys.last) return;
        [queryString appendString:@" AND "];
    }];
    
    return queryString;
}

+ (NSPredicate *)predicateFromStringOrDict:(id)condition {
    
    if ([condition isKindOfClass:[NSString class]])
        return [NSPredicate predicateWithFormat:condition];
    
    else if ([condition isKindOfClass:[NSDictionary class]])
        return [NSPredicate predicateWithFormat:[self queryStringFromDictionary:condition]];
    
    return nil;
}

+ (NSFetchRequest *)createFetchRequestInContext:(NSManagedObjectContext *)context {
    
    NSFetchRequest *request = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(self)
                                              inManagedObjectContext:context];
    [request setEntity:entity];
    return request;
}

+ (NSArray *)fetchWithPredicate:(NSPredicate *)predicate andDescriptor:(NSSortDescriptor *)descriptor inContext:(NSManagedObjectContext *)context {
    
    NSFetchRequest *request = [self createFetchRequestInContext:context];
    [request setPredicate:predicate];
    if (descriptor) {
        [request setSortDescriptors:@[descriptor]];
    }
    
    NSArray *fetchedObjects = [context executeFetchRequest:request error:nil];
    if (fetchedObjects.count > 0) return fetchedObjects;
    return nil;
}

- (BOOL)saveTheContext {

    if (self.managedObjectContext == nil ||
        ![self.managedObjectContext hasChanges]) return YES;
    
    NSError *error = nil;
    BOOL save = [self.managedObjectContext save:&error];

    if (!save || error) {
        NSLog(@"Unresolved error in saving context for entity: %@!\n Error: %@", self, error);
        return NO;
    }
    
    return YES;
}

@end