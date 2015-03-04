//
//  AACDMessage2.m
//  ActorClient
//
//  Created by Антон Буков on 04.03.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "J2ObjC_source.h"
#import "AACDMessage+Ext.h"

@implementation AACDMessage (Ext)

- (AMMessage *)message
{
    IOSByteArray *byteArray = [IOSByteArray arrayWithBytes:self.value.bytes count:self.value.length];
    return [AMMessage fromBytesWithByteArray:byteArray];
}

@end
