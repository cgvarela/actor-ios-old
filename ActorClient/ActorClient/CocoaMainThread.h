//
//  CocoaMainThread.h
//  ActorClient
//
//  Created by Антон Буков on 25.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "im/actor/model/MainThread.h"

@interface CocoaMainThread : NSObject <AMMainThread>

- (void)runOnUiThread:(id<JavaLangRunnable>)runnable;

@end
