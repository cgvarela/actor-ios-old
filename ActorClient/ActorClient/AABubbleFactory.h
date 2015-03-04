//
//  AABubbleFactory.h
//  ActorClient
//
//  Created by Антон Буков on 04.03.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AABubbleView+Ext.h"
#import "AATextBubbleView+Ext.h"

@interface AABubbleFactory : NSObject

+ (Class)bubbleClassForContentType:(NSString *)contentType;

@end
