//
//  MessageCoreDataListEngine.m
//  ActorModel
//
//  Created by Антон Буков on 17.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "DBMessage.h"
#import "J2ObjC_source.h"
#import "im/actor/model/entity/Peer.h"
#import "im/actor/model/entity/Message.h"

#import "MessageZonedCoreDataListEngine.h"

@implementation MessageZonedCoreDataListEngine

- (instancetype)initWithPeer:(AMPeer *)peer
{
    return self = [super initWithMOS:[DBMessage class]
                             zone_id:peer.getPeerId
                          serializer:^NSData *(AMMessage *object) {
                              return object.toByteArray.toNSData;
                          } deserializer:^AMMessage *(NSData *data) {
                              IOSByteArray *byteArray = [IOSByteArray arrayWithBytes:data.bytes count:data.length];
                              return [AMMessage fromBytesWithByteArray:byteArray];
                          }];
}

@end
