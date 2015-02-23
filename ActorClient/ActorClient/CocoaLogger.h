//
//  CocoaLogger.h
//  ActorClient
//
//  Created by Антон Буков on 23.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "im/actor/model/LogCallback.h"

@interface CocoaLogger : NSObject <AMLogCallback>

- (void)w:(NSString *)tag withMessage:(NSString *)message;
- (void)v:(NSString *)tag withError:(JavaLangThrowable *)throwable;
- (void)d:(NSString *)tag withMessage:(NSString *)message;
- (void)v:(NSString *)tag withMessage:(NSString *)message;

@end
