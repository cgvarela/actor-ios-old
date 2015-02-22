//
//  CocoaNetworking.m
//  ActorModel
//
//  Created by Антон Буков on 16.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "im/actor/model/network/CreateConnectionCallback.h"

#import "CocoaNetworking.h"
#import "CocoaTcpConnection.h"

@implementation CocoaNetworking

- (void)createConnection:(jint)connectionId withEndpoint:(AMConnectionEndpoint *)endpoint withCallback:(id<AMConnectionCallback>)callback withCreateCallback:(id<AMCreateConnectionCallback>)createCallback
{
    CocoaTcpConnection *connection = [[CocoaTcpConnection alloc] initWithConnectionId:connectionId connectionEndpoint:endpoint connectionCallback:callback];
    @try {
        [createCallback onConnectionCreated:connection];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
        [createCallback onConnectionCreateError];
    }
}

@end
