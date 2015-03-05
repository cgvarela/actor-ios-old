//
//  AACDContact+Ext.m
//  ActorClient
//
//  Created by Антон Буков on 04.03.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "J2ObjC_source.h"
#import "AACDContact+Ext.h"

@implementation AACDContact (Ext)

- (AMContact *)contact
{
    IOSByteArray *byteArray = [IOSByteArray arrayWithBytes:self.value.bytes count:self.value.length];
    return [AMContact fromBytesWithByteArray:byteArray];
}

@end