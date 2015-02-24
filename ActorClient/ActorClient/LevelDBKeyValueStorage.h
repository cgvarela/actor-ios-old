//
//  LevelDBKeyValueEngine.h
//  
//
//  Created by Антон Буков on 17.02.15.
//
//

#import "im/actor/model/storage/KeyValueItem.h"
#import "im/actor/model/storage/KeyValueStorage.h"

@class AMPeer;
id<AMKeyValueStorage> createUserLevelDBKeyValueStorage();
id<AMKeyValueStorage> createGroupLevelDBKeyValueStorage();
id<AMKeyValueStorage> createPendingMessageLevelDBKeyValueStorage(AMPeer *peer);

@interface LevelDBKeyValueStorage : NSObject <AMKeyValueStorage>

- (instancetype)initWithName:(NSString *)name
                  serializer:(NSData *(^)(id<AMKeyValueItem> object))serializer
                deserializer:(id<AMKeyValueItem>(^)(NSData *data))deserializer;

- (void)addOrUpdateItemWithLong:(jlong)id_
                  withByteArray:(IOSByteArray *)data;

- (void)addOrUpdateItemsWithJavaUtilList:(id<JavaUtilList>)values;

- (void)removeItemWithLong:(jlong)id_;

- (void)removeItemsWithLongArray:(IOSLongArray *)ids;

- (void)clear;

- (id)getValueWithLong:(jlong)id_;

@end
