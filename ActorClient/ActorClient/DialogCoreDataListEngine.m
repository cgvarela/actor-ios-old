//
//  DialogCoreDataListEngine.m
//  ActorModel
//
//  Created by Антон Буков on 17.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "AACDDialog.h"
#import <J2ObjC_source.h>
#import "im/actor/model/entity/Dialog.h"

#import "DialogCoreDataListEngine.h"

@implementation DialogCoreDataListEngine

- (instancetype)init
{
    return self = [super initWithMOS:[AACDDialog class]
                          serializer:^NSData *(AMDialog *object) {
                              return object.toByteArray.toNSData;
                          } deserializer:^AMDialog *(NSData *data) {
                              IOSByteArray *byteArray = [IOSByteArray arrayWithBytes:data.bytes count:data.length];
                              return byteArray.length ? [AMDialog fromBytesWithByteArray:byteArray] : nil;
                          }];
}

@end
