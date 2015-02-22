//
//  LevelDBKeyValueEngine.h
//  
//
//  Created by Антон Буков on 17.02.15.
//
//

#import "im/actor/model/mvvm/KeyValueItem.h"
#import "im/actor/model/mvvm/KeyValueEngine.h"

@interface LevelDBKeyValueEngine : NSObject <AMKeyValueEngine>

- (instancetype)initWithName:(NSString *)name
                  serializer:(NSData *(^)(id<AMKeyValueItem> object))serializer
                deserializer:(id<AMKeyValueItem>(^)(NSData *data))deserializer;

- (void)addOrUpdateItemWithAMKeyValueItem:(id<AMKeyValueItem>)item;

- (void)addOrUpdateItemsWithJavaUtilList:(id<JavaUtilList>)values;

- (void)removeItemWithLong:(jlong)id_;

- (void)removeItemsWithLongArray:(IOSLongArray *)ids;

- (void)clear;

- (id<JavaUtilList>)getAll;

- (id)getValueWithLong:(jlong)id_;

@end
