//
//  LevelDBKeyValueEngine.m
//  
//
//  Created by Антон Буков on 17.02.15.
//
//

#import <Objective-LevelDB/LevelDB.h>
#import "J2ObjC_source.h"
#import "im/actor/model/util/DataInput.h"
#import "im/actor/model/util/DataOutput.h"
#import "java/io/ByteArrayInputStream.h"
#import "java/io/ByteArrayOutputStream.h"
#import "java/io/ObjectInput.h"
#import "java/io/ObjectOutput.h"
#import "java/io/ObjectInputStream.h"
#import "java/io/ObjectOutputStream.h"
#import "java/util/ArrayList.h"
#import "LevelDBKeyValueStorage.h"

@interface LevelDBKeyValueStorage ()

@property (nonatomic, strong) LevelDB *ldb;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSData *(^serializer)(id<AMKeyValueItem> object);
@property (nonatomic, strong) id<AMKeyValueItem>(^deserializer)(NSData *data);

@end

@implementation LevelDBKeyValueStorage

- (LevelDB *)ldb
{
    @synchronized (self) {
        if (_ldb == nil) {
            NSString *filename = [NSString stringWithFormat:@"kv_%@.ldb",self.name];
            _ldb = [LevelDB databaseInLibraryWithName:filename];
            __weak typeof(self) weakSelf = self;
            _ldb.encoder = ^NSData*(LevelDBKey *key, id<AMKeyValueItem> object) {
                return weakSelf.serializer(object);
            };
            _ldb.decoder = ^ id (LevelDBKey *key, NSData * data) {
                return weakSelf.deserializer(data);
            };
        }
        return _ldb;
    }
}

- (instancetype)initWithName:(NSString *)name
                  serializer:(NSData *(^)(id<AMKeyValueItem> object))serializer
                deserializer:(id<AMKeyValueItem>(^)(NSData *data))deserializer
{
    if (self = [super init]) {
        self.name = name;
        self.serializer = serializer;
        self.deserializer = deserializer;
    }
    return self;
}

- (void)addOrUpdateItemWithLong:(jlong)id_
                  withByteArray:(IOSByteArray *)data
{
    @synchronized (self) {
        NSData *key = [NSData dataWithBytes:&id_ length:sizeof(id_)];
        [self.ldb setObject:data.toNSData forKey:key];
    }
}

- (void)addOrUpdateItemWithAMKeyValueItem:(id<AMKeyValueItem>)item
{
    @synchronized (self) {
        jlong keyLong = [item getEngineId];
        NSData *key = [NSData dataWithBytes:&keyLong length:sizeof(keyLong)];
        [self.ldb setObject:item forKey:key];
    }
}

- (void)addOrUpdateItemsWithJavaUtilList:(id<JavaUtilList>)values
{
    @synchronized (self) {
        for (id<AMKeyValueItem> item in values) {
            jlong keyLong = [item getEngineId];
            NSData *key = [NSData dataWithBytes:&keyLong length:sizeof(keyLong)];
            [self.ldb setObject:item forKey:key];
        }
    }
}

- (void)removeItemWithLong:(jlong)id_
{
    NSData *key = [NSData dataWithBytes:&id_ length:sizeof(id_)];
    @synchronized (self) {
        [self.ldb removeObjectForKey:key];
    }
}

- (void)removeItemsWithLongArray:(IOSLongArray *)ids
{
    NSMutableArray *keys = [NSMutableArray array];
    for (NSInteger i = 0; i < ids.length; i++) {
        jlong *keyLongRef = [ids longRefAtIndex:i];
        NSData *key = [NSData dataWithBytes:keyLongRef length:sizeof(*keyLongRef)];
        [keys addObject:key];
    }
    @synchronized (self) {
        [self.ldb removeObjectsForKeys:keys];
    }
}

- (void)clear
{
    @synchronized (self) {
        [self.ldb removeAllObjects];
    }
}

- (id)getValueWithLong:(jlong)id_
{
    NSData *key = [NSData dataWithBytes:&id_ length:sizeof(id_)];
    @synchronized (self) {
        return [self.ldb objectForKey:key];
    }
}

@end
