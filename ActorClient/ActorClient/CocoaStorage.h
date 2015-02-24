//
//  CocoaStorage.h
//  ActorModel
//
//  Created by Антон Буков on 17.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "im/actor/model/Storage.h"

@interface CocoaStorage : NSObject <AMStorage>

- (id<AMPreferencesStorage>)createPreferencesStorage;

- (id<AMKeyValueStorage>)createUsersEngine;

- (id<AMKeyValueStorage>)createGroupsEngine;

- (id<AMListEngine>)createDialogsEngine;

- (id<AMListEngine>)createMessagesEngineWithAMPeer:(AMPeer *)peer;

- (id<AMKeyValueStorage>)pendingMessagesWithAMPeer:(AMPeer *)peer;

@end
