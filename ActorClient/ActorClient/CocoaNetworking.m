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

@interface CocoaNetworking ()

@property (nonatomic, strong) NSMutableArray *connections;

@end

@implementation CocoaNetworking

- (NSMutableArray *)connections
{
    if (_connections == nil)
        _connections = [NSMutableArray array];
    return _connections;
}

- (void)createConnection:(jint)connectionId withEndpoint:(AMConnectionEndpoint *)endpoint withCallback:(id<AMConnectionCallback>)callback withCreateCallback:(id<AMCreateConnectionCallback>)createCallback
{
    CocoaTcpConnection *connection = [[CocoaTcpConnection alloc] initWithConnectionId:connectionId connectionEndpoint:endpoint connectionCallback:callback createCallback:createCallback];
    [self.connections addObject:connection];
}

@end
