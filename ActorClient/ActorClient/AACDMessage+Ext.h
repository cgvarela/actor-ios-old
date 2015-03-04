//
//  AACDMessage2.h
//  ActorClient
//
//  Created by Антон Буков on 04.03.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "im/actor/model/entity/Message.h"
#import "AACDMessage.h"

@interface AACDMessage (Ext)

@property (nonatomic, readonly) AMMessage *message;

@end
