//
//  CoreDataKeyValueStorage.m
//  ActorClient
//
//  Created by Антон Буков on 25.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#define MR_SHORTHAND 1
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "J2ObjC_source.h"
#import "java/util/ArrayList.h"
#import "CoreDataKeyValueStorage.h"

@interface CoreDataKeyValueStorage ()

@property (nonatomic, strong) Class mos;
@property (nonatomic, strong) NSData *(^serializer)(id<AMKeyValueItem> object);
@property (nonatomic, strong) id<AMKeyValueItem>(^deserializer)(NSData *data);
@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation CoreDataKeyValueStorage

- (NSManagedObjectContext *)context
{
    if (_context == nil) {
        _context = [NSManagedObjectContext MR_contextWithParent:[NSManagedObjectContext MR_defaultContext]];
    }
    return _context;
}

- (instancetype)initWithMOS:(Class)mos
                 serializer:(NSData *(^)(id<AMKeyValueItem> object))serializer
               deserializer:(id<AMKeyValueItem>(^)(NSData *data))deserializer
{
    if (self = [super init]) {
        self.mos = mos;
        self.serializer = serializer;
        self.deserializer = deserializer;
    }
    return self;
}

- (void)addOrUpdateItemWithLong:(jlong)id_
                  withByteArray:(IOSByteArray *)data
{
    @synchronized (self) {
        id object = [self.mos MR_findFirstByAttribute:@"key" withValue:@(id_) inContext:self.context];
        if (object == nil) {
            object = [self.mos MR_createInContext:self.context];
            [object setValue:@(id_) forKey:@"key"];
        }
        [object setValue:data.toNSData forKey:@"value"];
    }
}

- (void)addOrUpdateItemsWithJavaUtilList:(id<JavaUtilList>)values
{
    @synchronized (self) {
        for (id<AMKeyValueItem> item in values) {
            jlong key = [item getEngineId];
            NSData *value = self.serializer(item);
            
            id object = [self.mos MR_findFirstByAttribute:@"key" withValue:@(key) inContext:self.context];
            if (object == nil) {
                object = [self.mos MR_createInContext:self.context];
                [object setValue:@(key) forKey:@"key"];
            }
            [object setValue:value forKey:@"value"];
        }
    }
}

- (void)removeItemWithLong:(jlong)id_
{
    @synchronized (self) {
        id object = [self.mos MR_findFirstByAttribute:@"key" withValue:@(id_) inContext:self.context];
        [object MR_deleteEntity];
    }
}

- (void)removeItemsWithLongArray:(IOSLongArray *)ids
{
    NSMutableArray *keys = [NSMutableArray array];
    for (jint i = 0; i < ids.length; i++)
        [keys addObject:@([ids longAtIndex:i])];
    @synchronized (self) {
        [self.mos MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"key IN %@",keys]];
    }
}

- (void)clear
{
    @synchronized (self) {
        [self.mos MR_truncateAll];
    }
}

- (id)getValueWithLong:(jlong)id_
{
    @synchronized (self) {
        NSData *data = [self.mos MR_findFirstByAttribute:@"key" withValue:@(id_) inContext:self.context];
        return self.deserializer(data);
    }
}

@end
