//
//  CocoaTcpConnection.m
//  ActorModel
//
//  Created by Антон Буков on 16.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import <zlib.h>
#import <CocoaAsyncSocket/GCDAsyncSocket.h>
#import "J2ObjC_source.h"
#import "im/actor/model/network/ConnectionEndpoint.h"
#import "im/actor/model/network/ConnectionCallback.h"
#import "SASerializationHelpers.h"
#import "CocoaTcpConnection.h"

@interface CocoaTcpConnection () <GCDAsyncSocketDelegate>

@property (nonatomic, strong) AMConnectionEndpoint *endpoint;
@property (nonatomic, strong) id<AMConnectionCallback> callback;
@property (nonatomic, strong) GCDAsyncSocket *socket;

@property (nonatomic, strong) NSMutableData *buffer;
@property (nonatomic, strong) NSMutableData *outBuffer;
@property (nonatomic, assign) uint32_t packetIndex;

@end

@implementation CocoaTcpConnection

- (NSMutableData *)buffer
{
    if (_buffer == nil)
        _buffer = [NSMutableData data];
    return _buffer;
}

- (NSMutableData *)outBuffer
{
    if (_outBuffer == nil)
        _outBuffer = [NSMutableData data];
    return _outBuffer;
}

#pragma mark - GCD Async Socket

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"socket:didConnectToHost:port:");
    self.buffer = nil;
    if (self.endpoint.getType.ordinal == AMConnectionEndpoint_Type_TCP_TLS) {
        [sock startTLS:@{//(id)kCFStreamSSLAllowsExpiredCertificates:@NO,
                         //(id)kCFStreamSSLAllowsExpiredRoots:@NO,
                         //(id)kCFStreamSSLAllowsAnyRoot:@YES,
                         //(id)kCFStreamSSLValidatesCertificateChain:@YES,
                         (id)kCFStreamSSLPeerName:@"actor.im",
                         //(id)kCFStreamSSLLevel:(id)kCFStreamSocketSecurityLevelNegotiatedSSL,
                         }];
    } else {
        [sock readDataWithTimeout:-1 tag:0];
        if (self.outBuffer.length > 0) {
            [sock writeData:self.outBuffer withTimeout:-1 tag:0];
            self.outBuffer = nil;
        }
    }
}

- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
    NSLog(@"socketDidSecure");
    [sock readDataWithTimeout:-1 tag:0];
    if (self.outBuffer.length > 0) {
        [sock writeData:self.outBuffer withTimeout:-1 tag:0];
        self.outBuffer = nil;
    }
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    [self.buffer appendData:data];
    [self tryToGetMessageFromBuffer];
    [sock readDataWithTimeout:-1 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"socketDidDisconnect:withError: %@", err);
    [self.callback onConnectionDie];
}

#pragma mark - Tcp Connection

- (void)tryToGetMessageFromBuffer
{
    NSInteger offset = 0;
    const uint8_t *bytes = self.buffer.bytes;
    
    uint32_t packetLength;
    uint32_t packetIndex;
    if (self.buffer.length < sizeof(packetLength))
        return;
    packetLength = extract_uint(bytes, &offset);
    if (self.buffer.length < sizeof(packetLength) + packetLength)
        return;
    packetIndex = extract_uint(bytes, &offset);
    
    uint32_t checksum = (int32_t)crc32(0, bytes, (int32_t)(packetLength));
    uint32_t *checksumOriginalPtr = (uint32_t *)(bytes+4+packetLength-4);
    uint32_t checksumOriginal = ntohl(*checksumOriginalPtr);
    
    // If checksum valid
    if (checksum == checksumOriginal) {
        IOSByteArray *arr = [IOSByteArray arrayWithBytes:self.buffer.bytes count:self.buffer.length];
        [self.callback onMessage:arr withOffset:8 withLen:packetLength-8];
    } else {
        NSLog(@"CRC-32 error");
        [self close];
        return;
    }
    
    [self.buffer replaceBytesInRange:NSMakeRange(0, 4+packetLength) withBytes:NULL length:0];
    [self tryToGetMessageFromBuffer];
}

- (instancetype)initWithConnectionId:(jint)connectionId
                  connectionEndpoint:(AMConnectionEndpoint *)endpoint
                  connectionCallback:(id<AMConnectionCallback>)callback
{
    if (self = [super init]) {
        self.endpoint = endpoint;
        self.callback = callback;
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        NSError *error;
        [self.socket connectToHost:self.endpoint.getHost onPort:self.endpoint.getPort error:&error];
        if (error)
            NSLog(@"Socket connection error: %@", error);
    }
    return self;
}

- (void)post:(IOSByteArray *)data withOffset:(jint)offset withLen:(jint)len
{
    NSMutableData *buffer = [NSMutableData dataWithCapacity:4+4+len+4];
    
    insert_uint(buffer, 4 + (uint32_t)data.length + 4);
    insert_uint(buffer, self.packetIndex++);
    [buffer appendData:[data.toNSData subdataWithRange:NSMakeRange(offset, len)]];
    insert_uint(buffer, (uint32_t)crc32(0, buffer.bytes, (int32_t)buffer.length));
    
    if (!self.socket.isConnected) {
        [self.outBuffer appendData:buffer];
        return;
    }
    [self.socket writeData:buffer withTimeout:-1 tag:0];
}

- (jboolean)isClosed
{
    return self.socket.isDisconnected;
}

- (void)close
{
    [self.socket disconnect];
}

@end
