//
//  CocoaCryptoProvider.m
//  ActorClient
//
//  Created by Антон Буков on 27.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "J2ObjC_source.h"
#import "CocoaCryptoProvider.h"

@implementation CocoaCryptoProvider

- (IOSByteArray *)SHA256WithByteArray:(IOSByteArray *)data
{
    IOSByteArray *ret = [IOSByteArray arrayWithLength:32];
    CC_SHA256(data.buffer, data.length, ret.buffer);
    return ret;
}

@end
