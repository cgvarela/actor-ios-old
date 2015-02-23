//
//  AAMessage.h
//  ActorModel
//
//  Created by Антон Буков on 17.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AACDMessage : NSManagedObject

@property (nonatomic, retain) NSData * value;
@property (nonatomic) int64_t key;
@property (nonatomic) int64_t sortKey;
@property (nonatomic) int32_t zone_id;

@end
