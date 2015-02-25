//
//  CoreDataListEngine.m
//  ActorModel
//
//  Created by Антон Буков on 17.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#define MR_SHORTHAND 1
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "J2ObjC_source.h"
#import "java/util/ArrayList.h"
#import "ZonedCoreDataListEngine.h"

@interface ZonedCoreDataListEngine ()

@property (nonatomic, strong) Class mos;
@property (nonatomic, assign) jint zone_id;
@property (nonatomic, strong) NSData *(^serializer)(id<AMListEngineItem> object);
@property (nonatomic, strong) id<AMListEngineItem>(^deserializer)(NSData *data);
@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation ZonedCoreDataListEngine

- (NSManagedObjectContext *)context
{
    if (_context == nil) {
        _context = [NSManagedObjectContext MR_contextWithParent:[NSManagedObjectContext MR_defaultContext]];
    }
    return _context;
}

- (instancetype)initWithMOS:(Class)mos
                    zone_id:(jint)zone_id
                 serializer:(NSData *(^)(id<AMListEngineItem> object))serializer
               deserializer:(id<AMListEngineItem>(^)(NSData *data))deserializer
{
    if (self = [super init]) {
        self.mos = mos;
        self.zone_id = zone_id;
        self.serializer = serializer;
        self.deserializer = deserializer;
    }
    return self;
}

- (void)addOrUpdateItemWithAMListEngineItem:(id<AMListEngineItem>)item
{
    jlong key = [item getListId];
    jlong sortKey = [item getListSortKey];
    id value = self.serializer(item);
    
    @synchronized (self) {
        id object = [self.mos MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"zone_id = %@ AND key = %@", @(self.zone_id), @(key)] inContext:self.context];
        if (object == nil) {
            object = [self.mos MR_createInContext:self.context];
            [object setValue:@(key) forKey:@"key"];
        }
        [object setValue:@(sortKey) forKey:@"sortKey"];
        [object setValue:value forKey:@"value"];
    }
}

- (void)addOrUpdateItemsWithJavaUtilList:(id<JavaUtilList>)values
{
    @synchronized (self) {
        for (id<AMListEngineItem> item in values) {
            jlong key = [item getListId];
            jlong sortKey = [item getListSortKey];
            id value = self.serializer(item);
            
            id object = [self.mos MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"zone_id = %@ AND key = %@", @(self.zone_id), @(key)] inContext:self.context];
            if (object == nil) {
                object = [self.mos MR_createInContext:self.context];
                [object setValue:@(key) forKey:@"key"];
            }
            [object setValue:@(sortKey) forKey:@"sortKey"];
            [object setValue:value forKey:@"value"];
        }
    }
}

- (void)replaceItemsWithJavaUtilList:(id<JavaUtilList>)values
{
    [self clear];
    [self addOrUpdateItemsWithJavaUtilList:values];
}

- (void)removeItemWithLong:(jlong)id_
{
    @synchronized (self) {
        id object = [self.mos MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"zone_id = %@ AND key = %@", @(self.zone_id), @(id_)] inContext:self.context];
        [object MR_deleteEntity];
    }
}

- (void)removeItemsWithLongArray:(IOSLongArray *)ids
{
    NSMutableArray *keys = [NSMutableArray array];
    for (jint i = 0; i < ids.length; i++)
        [keys addObject:@([ids longAtIndex:i])];
    @synchronized (self) {
        [self.mos MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"zone_id = %@ AND key IN %@", @(self.zone_id), keys] inContext:self.context];
    }
}

- (void)clear
{
    @synchronized (self) {
        [self.mos MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"zone_id = %@", @(self.zone_id)] inContext:self.context];
    }
}

- (id)getValueWithLong:(jlong)id_
{
    @synchronized (self) {
        NSData *data = [self.mos MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"zone_id = %@ AND key = %@", @(self.zone_id),@(id_)] inContext:self.context];
        return self.deserializer(data);
    }
}

- (id)getHeadValue
{
    @synchronized (self) {
        NSData *data = [self.mos MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"zone_id = %@", @(self.zone_id)] sortedBy:@"sortKey" ascending:NO inContext:self.context];
        return self.deserializer(data);
    }
}

- (jint)getCount
{
    @synchronized (self) {
        return (jint)[self.mos MR_countOfEntitiesWithPredicate:[NSPredicate predicateWithFormat:@"zone_id = %@",@(self.zone_id)]];
    }
}

@end
