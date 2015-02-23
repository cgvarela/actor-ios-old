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
    NSLog(@"w:withMessage: %@ %@", tag, message);
}

- (void)v:(NSString *)tag withError:(JavaLangThrowable *)throwable
{
    NSLog(@"v:withError: %@ %@", tag, throwable);
}

- (void)d:(NSString *)tag withMessage:(NSString *)message
{
    NSLog(@"d:withMessage: %@ %@", tag, message);
}

- (void)v:(NSString *)tag withMessage:(NSString *)message
{
    NSLog(@"v:withMessage: %@ %@", tag, message);
}

@end
