//
//  CocoaConfigurationBuilder.m
//  ActorClient
//
//  Created by Антон Буков on 23.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "NSObject+MMAnonymousClass.h"
#import "java/lang/Runnable.h"
#import "java/util/HashMap.h"
#import "im/actor/model/cocoa/CocoaThreading.h"
#import "im/actor/model/ConfigurationBuilder.h"

#import "CocoaLogger.h"
#import "CocoaLocale.h"
#import "CocoaMainThread.h"
#import "CocoaNetworking.h"
#import "CocoaStorage.h"

#import "CocoaMessenger.h"

@interface CocoaMessenger ()

@end

@implementation CocoaMessenger

- (instancetype)init
{
    self = [super initWithConfig:^{
        AMConfigurationBuilder *confBuilder = [[AMConfigurationBuilder alloc] init];
        [confBuilder setLog:[[CocoaLogger alloc] init]];
        [confBuilder setNetworking:[[CocoaNetworking alloc] init]];
        [confBuilder setThreading:[[AMCocoaThreading alloc] init]];
        [confBuilder setStorage:[[CocoaStorage alloc] init]];
        [confBuilder setMainThread:[[CocoaMainThread alloc] init]];
        [confBuilder addEndpoint:@"tls://mtproto-api.actor.im:443"];
        [confBuilder setLocale:[[CocoaLocale alloc] init]];
        return [confBuilder build];
    }()];
    return self;
}

+ (instancetype)messenger
{
    static CocoaMessenger *msgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        msgr = [[CocoaMessenger alloc] init];
    });
    return msgr;
}

@end
