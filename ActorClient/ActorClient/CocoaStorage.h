//
//  CocoaStorage.h
//  ActorModel
//
//  Created by Антон Буков on 17.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "im/actor/model/Storage.h"
#import "AACDMessage+Ext.h"
#import "AACDContact+Ext.h"
#import "AACDDialog+Ext.h"
#import "AACDGroup.h"
#import "AACDUser.h"
#import "AACDDownload.h"

@interface CocoaStorage : NSObject <AMStorage>

- (id<AMPreferencesStorage>)createPreferencesStorage;

- (id<AMKeyValueStorage>)createUsersEngine;

- (id<AMKeyValueStorage>)createGroupsEngine;

- (id<AMListEngine>)createDialogsEngine;

- (id<AMListEngine>)createMessagesEngineWithAMPeer:(AMPeer *)peer;

@end
