//
//  AABubbleView+Ext.m
//  ActorClient
//
//  Created by Антон Буков on 04.03.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "im/actor/model/entity/User.h"
#import "im/actor/model/entity/Message.h"
#import "im/actor/model/entity/MessageState.h"
#import "im/actor/model/entity/content/AbsContent.h"
#import "im/actor/model/mvvm/MVVMCollection.h"
#import "CocoaMessenger.h"

#import "AABubbleView+Ext.h"

@implementation AABubbleView (Ext)

- (void)configureWithMessage:(AMMessage *)message
                 isMyMessage:(BOOL)isMyMessage
{
    AMUser *author = [[CocoaMessenger messenger].getUsers getWithLong:message.getSenderId];
    
    self.bubbleImage = isMyMessage ? [UIImage imageNamed:@"BubbleOutgoingFull"] : [UIImage imageNamed:@"BubbleIncomingFull"];
    self.authorName = author.getName;
    self.date = [NSDate dateWithTimeIntervalSince1970:message.getDate];
    self.sent = (message.getMessageState.ordinal == AMMessageState_SENT);
    self.sent = (message.getMessageState.ordinal == AMMessageState_RECEIVED);
    self.sent = (message.getMessageState.ordinal == AMMessageState_READ);
}

@end
