//
//  AABubbleView+Ext.h
//  ActorClient
//
//  Created by Антон Буков on 04.03.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "AABubbleView.h"

@class AMMessage;

@interface AABubbleView (Ext)

- (void)bindMessage:(AMMessage *)message isMyMessage:(BOOL)isMyMessage;

@end
