//
//  AABubbleFactory.m
//  ActorClient
//
//  Created by Антон Буков on 04.03.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "AABubbleFactory.h"

@implementation AABubbleFactory

+ (Class)bubbleClassForContentType:(NSString *)contentType
{
    if ([contentType isEqualToString:@"TEXT"])
        return [AATextBubbleView class];
    return [AABubbleView class];
}

@end
