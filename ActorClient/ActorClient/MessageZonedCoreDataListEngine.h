//
//  MessageCoreDataListEngine.h
//  ActorModel
//
//  Created by Антон Буков on 17.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "ZonedCoreDataListEngine.h"

@class AMPeer;

@interface MessageZonedCoreDataListEngine : ZonedCoreDataListEngine

- (instancetype)initWithPeer:(AMPeer *)peer;

@end
