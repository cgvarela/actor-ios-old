//
//  AABubbleView+Ext.m
//  ActorClient
//
//  Created by Антон Буков on 04.03.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "ActorModel.h"

#import "AABubbleView+Ext.h"

@implementation AABubbleView (Ext)

- (void)bindMessage:(AMMessage *)message isMyMessage:(BOOL)isMyMessage
{
    AMUserVM *author = [[CocoaMessenger messenger].getUsers getWithLong:message.getSenderId];
    
    self.bubbleImage = isMyMessage ? [UIImage imageNamed:@"BubbleOutgoingFull"] : [UIImage imageNamed:@"BubbleIncomingFull"];
    self.authorName = isMyMessage ? nil : author.getName.get;
    self.date = [NSDate dateWithTimeIntervalSince1970:message.getDate];
    self.sent = (message.getMessageState.ordinal == AMMessageState_SENT);
    self.sent = (message.getMessageState.ordinal == AMMessageState_RECEIVED);
    self.sent = (message.getMessageState.ordinal == AMMessageState_READ);
}

@end
