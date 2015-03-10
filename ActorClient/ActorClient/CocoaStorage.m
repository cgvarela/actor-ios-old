//
//  CocoaStorage.m
//  ActorModel
//
//  Created by Антон Буков on 17.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "J2ObjC_source.h"
#import "im/actor/model/entity/Peer.h"
#import "im/actor/model/entity/User.h"
#import "im/actor/model/entity/Group.h"
#import "im/actor/model/entity/Dialog.h"
#import "im/actor/model/entity/Contact.h"
#import "im/actor/model/entity/Message.h"
#import "im/actor/model/modules/messages/entity/PendingMessagesStorage.h"
#import "UserDefaultsPreferencesStorage.h"
#import "CoreDataKeyValueStorage.h"
#import "CoreDataListEngine.h"
#import "ZonedCoreDataListEngine.h"
#import "CocoaStorage.h"

#import "AACDDialog.h"
#import "AACDDownload.h"
#import "AACDMessage.h"
#import "AACDUser.h"
#import "AACDGroup.h"
#import "AACDContact.h"

@implementation CocoaStorage

- (id<AMPreferencesStorage>)createPreferencesStorage
{
    return [[UserDefaultsPreferencesStorage alloc] init];
}

- (id<AMKeyValueStorage>)createUsersEngine
{
    return [[CoreDataKeyValueStorage alloc] initWithMOS:[AACDUser class]];
}

- (id<AMKeyValueStorage>)createGroupsEngine
{
    return [[CoreDataKeyValueStorage alloc] initWithMOS:[AACDGroup class]];
}

- (id<AMKeyValueStorage>)createDownloadsEngine
{
    return [[CoreDataKeyValueStorage alloc] initWithMOS:[AACDDownload class]];
}

- (id<AMListEngine>)createContactsEngine
{
    return [[CoreDataListEngine alloc] initWithMOS:[AACDContact class] serializer:^NSData *(AMContact *object) {
        return object.toByteArray.toNSData;
    } deserializer:^AMContact *(NSData *data) {
        IOSByteArray *byteArray = [IOSByteArray arrayWithBytes:data.bytes count:data.length];
        return byteArray.length ? [AMContact fromBytesWithByteArray:byteArray] : nil;
    }];
}

- (id<AMListEngine>)createDialogsEngine
{
    return [[CoreDataListEngine alloc] initWithMOS:[AACDDialog class] serializer:^NSData *(AMDialog *object) {
        return object.toByteArray.toNSData;
    } deserializer:^AMDialog *(NSData *data) {
        IOSByteArray *byteArray = [IOSByteArray arrayWithBytes:data.bytes count:data.length];
        return byteArray.length ? [AMDialog fromBytesWithByteArray:byteArray] : nil;
    }];
}

- (id<AMListEngine>)createMessagesEngineWithAMPeer:(AMPeer *)peer
{
    return [[ZonedCoreDataListEngine alloc] initWithMOS:[AACDMessage class] zone_id:peer.getPeerId serializer:^NSData *(AMMessage *object) {
        return object.toByteArray.toNSData;
    } deserializer:^AMMessage *(NSData *data) {
        IOSByteArray *byteArray = [IOSByteArray arrayWithBytes:[data bytes] count:[data length]];
        return byteArray.length ? [AMMessage fromBytesWithByteArray:byteArray] : nil;
    }];
}

@end
