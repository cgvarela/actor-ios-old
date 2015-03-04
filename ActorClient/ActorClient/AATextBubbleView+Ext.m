//
//  AATextBubbleView+Ext.m
//  ActorClient
//
//  Created by Антон Буков on 04.03.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "J2ObjC_source.h"
#import "im/actor/model/entity/Message.h"
#import "im/actor/model/entity/MessageState.h"
#import "im/actor/model/entity/content/AbsContent.h"

#import "AATextBubbleView+Ext.h"

@implementation AATextBubbleView (Ext)

- (void)configureWithMessage:(AMMessage *)message
                 isMyMessage:(BOOL)isMyMessage
{
    [super configureWithMessage:message isMyMessage:isMyMessage];
    self.text = [NSString stringWithBytes:message.getContent.toByteArray];
}

@end
