//
//  CocoaLogger.m
//  ActorClient
//
//  Created by Антон Буков on 23.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "CocoaLogger.h"

@implementation CocoaLogger

- (void)w:(NSString *)tag withMessage:(NSString *)message
{
    NSLog(@"[W] %@: %@", tag, message);
}

- (void)v:(NSString *)tag withError:(JavaLangThrowable *)throwable
{
    NSLog(@"[V] %@: %@", tag, throwable);
}

- (void)d:(NSString *)tag withMessage:(NSString *)message
{
    NSLog(@"[D] %@: %@", tag, message);
}

- (void)v:(NSString *)tag withMessage:(NSString *)message
{
    NSLog(@"[V] %@: %@", tag, message);
}

@end
