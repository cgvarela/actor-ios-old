//
//  CoreDataKeyValueStorage.h
//  ActorClient
//
//  Created by Антон Буков on 25.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "im/actor/model/storage/KeyValueItem.h"
#import "im/actor/model/storage/KeyValueRecord.h"
#import "im/actor/model/storage/KeyValueStorage.h"

@interface CoreDataKeyValueStorage : NSObject <AMKeyValueStorage>

- (instancetype)initWithMOS:(Class)mos
                 serializer:(NSData *(^)(id<AMKeyValueItem> object))serializer
               deserializer:(IOSByteArray *(^)(NSData *data))deserializer;

- (void)addOrUpdateItemWithLong:(jlong)id_
                  withByteArray:(IOSByteArray *)data;

- (void)addOrUpdateItemsWithJavaUtilList:(id<JavaUtilList>)values;

- (void)removeItemWithLong:(jlong)id_;

- (void)removeItemsWithLongArray:(IOSLongArray *)ids;

- (void)clear;

- (id)getValueWithLong:(jlong)id_;

@end
