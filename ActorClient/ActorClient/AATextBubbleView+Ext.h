//
//  AATextBubbleView+Ext.h
//  ActorClient
//
//  Created by Антон Буков on 04.03.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "AABubbleView+Ext.h"
#import "AATextBubbleView.h"

@interface AATextBubbleView (Ext)

- (void)bindMessage:(AMMessage *)message isMyMessage:(BOOL)isMyMessage;

@end
