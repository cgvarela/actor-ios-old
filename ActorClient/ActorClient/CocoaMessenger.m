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
#import "im/actor/model/cocoa/CocoaThreading.h"
#import "im/actor/model/MainThread.h"
#import "im/actor/model/MessengerCallback.h"
#import "im/actor/model/ConfigurationBuilder.h"

#import "CocoaLogger.h"
#import "CocoaNetworking.h"
#import "CocoaStorage.h"

#import "CocoaMessenger.h"

@interface CocoaMessenger () <AMMessengerCallback>

//@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation CocoaMessenger

/*- (NSManagedObjectContext *)context
{
    if (_context == nil) {
        NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_coordinatorWithInMemoryStore];
        [NSManagedObjectContext MR_contextWithStoreCoordinator:coordinator];
    }
    return _context;
}*/

- (instancetype)init
{
    self = [super initWithAMConfiguration:^{
        AMConfigurationBuilder *confBuilder = [[AMConfigurationBuilder alloc] init];
        [confBuilder setLog:[[CocoaLogger alloc] init]];
        [confBuilder setNetworking:[[CocoaNetworking alloc] init]];
        [confBuilder setThreading:[[AMCocoaThreading alloc] init]];
        [confBuilder setStorage:[[CocoaStorage alloc] init]];
        [confBuilder setCallback:self];
        [confBuilder setMainThread:MM_CREATE(MM_REUSE,^(Class class){
            [class addMethod:@selector(runOnUiThread:)
                fromProtocol:@protocol(AMMainThread)
                    blockImp:^(id this, id<JavaLangRunnable> runnable){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [runnable run];
                        });
                    }];
        })];
        [confBuilder addEndpoint:@"tcp://mtproto-api.actor.im:8080"];
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

#pragma mark - Messenger Callback

- (void)onUserOnline:(jint)uid
{
    
}

- (void)onUserOffline:(jint)uid
{
    
}

- (void)onUserLastSeen:(jint)uid withLastSeen:(jlong)lastSeen
{
    
}

- (void)onGroupOnline:(jint)gid withUserCount:(jint)count
{
    
}

- (void)onTypingStart:(jint)uid
{
    
}

- (void)onTypingEnd:(jint)uid
{
    
}

- (void)onGroupTyping:(jint)gid withUsers:(IOSIntArray *)uids
{
    
}

@end
