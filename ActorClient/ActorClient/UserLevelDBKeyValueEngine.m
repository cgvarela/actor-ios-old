//
//  UserLevelDBKeyValueEngine.m
//  ActorModel
//
//  Created by Антон Буков on 17.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "J2ObjC_source.h"
#import "im/actor/model/entity/User.h"

#import "UserLevelDBKeyValueEngine.h"

@implementation UserLevelDBKeyValueEngine

- (instancetype)initWithName:(NSString *)name;
{
    return self = [super initWithName:name
                           serializer:^NSData *(AMUser *object) {
                               return [object toByteArray].toNSData;
                           } deserializer:^id<AMKeyValueItem>(NSData *data) {
                               IOSByteArray *bytesArray = [IOSByteArray arrayWithBytes:data.bytes count:data.length];
                               return [AMUser fromBytesWithByteArray:bytesArray];
                           }];
}

@end
