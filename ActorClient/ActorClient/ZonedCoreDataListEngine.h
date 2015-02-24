//
//  CoreDataListEngine.h
//  ActorModel
//
//  Created by Антон Буков on 17.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "im/actor/model/mvvm/ListEngine.h"
#import "im/actor/model/mvvm/ListEngineItem.h"

@interface ZonedCoreDataListEngine : NSObject <AMListEngine>

- (instancetype)initWithMOS:(Class)mos
                    zone_id:(jint)zone_id
                 serializer:(NSData *(^)(id<AMListEngineItem> object))serializer
               deserializer:(id<AMListEngineItem>(^)(NSData *data))deserializer;

- (void)addOrUpdateItemWithAMListEngineItem:(id<AMListEngineItem>)item;

- (void)addOrUpdateItemsWithJavaUtilList:(id<JavaUtilList>)values;

- (void)replaceItemsWithJavaUtilList:(id<JavaUtilList>)values;

- (void)removeItemWithLong:(jlong)id_;

- (void)removeItemsWithLongArray:(IOSLongArray *)ids;

- (void)clear;

- (id)getValueWithLong:(jlong)id_;

- (id)getHeadValue;

- (jint)getCount;

@end