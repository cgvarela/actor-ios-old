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
#import "im/actor/model/MainThread.h"
#import "im/actor/model/LocaleProvider.h"
#import "im/actor/model/ConfigurationBuilder.h"

#import "CocoaLogger.h"
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
        [confBuilder setMainThread:MM_CREATE(MM_REUSE,^(Class class){
            [class addMethod:@selector(runOnUiThread:)
                fromProtocol:@protocol(AMMainThread)
                    blockImp:^(id this, id<JavaLangRunnable> runnable){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [runnable run];
                        });
                    }];
        })];
        [confBuilder addEndpoint:@"tls://mtproto-api.actor.im:443"];
        [confBuilder setLocale:MM_CREATE(MM_REUSE, ^(Class class) {
            [class addMethod:@selector(loadLocale)
                fromProtocol:@protocol(AMLocaleProvider)
                    blockImp:^(id this){
                        static JavaUtilHashMap *map = nil;
                        if (map == nil) {
                            map = [[JavaUtilHashMap alloc] init];
                            NSError *error = nil;
                            NSString *text = [NSString stringWithContentsOfFile:@"AppText.properties" encoding:NSUTF8StringEncoding error:&error];
                            for (NSString *line in [text componentsSeparatedByString:@"\n"]) {
                                NSArray *tokens = [line componentsSeparatedByString:@"="];
                                if (tokens.count == 2)
                                    [map putWithId:tokens[0] withId:tokens[1]];
                            }
                            
                        }
                        return map;
                    }];
        })];
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
