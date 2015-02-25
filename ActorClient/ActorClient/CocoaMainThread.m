//
//  CocoaMainThread.m
//  ActorClient
//
//  Created by Антон Буков on 25.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "java/lang/Runnable.h"

#import "CocoaMainThread.h"

@implementation CocoaMainThread

- (void)runOnUiThread:(id<JavaLangRunnable>)runnable
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [runnable run];
    });
}

@end
