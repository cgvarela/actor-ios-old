//
//  AACDMessage.h
//  ActorClient
//
//  Created by Антон Буков on 27.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AACD_List.h"


@interface AACDMessage : AACD_List

@property (nonatomic) int32_t zone_id;

@end
