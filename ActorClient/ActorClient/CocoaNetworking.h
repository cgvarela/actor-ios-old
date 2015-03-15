//
//  CocoaNetworking.h
//  ActorModel
//
//  Created by Антон Буков on 16.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "im/actor/model/NetworkProvider.h"

@interface CocoaNetworking : NSObject <AMNetworkProvider>

- (void)createConnection:(jint)connectionId withEndpoint:(AMConnectionEndpoint *)endpoint withCallback:(id<AMConnectionCallback>)callback withCreateCallback:(id<AMCreateConnectionCallback>)createCallback;

@end
