//
//  AACDUser.h
//  ActorClient
//
//  Created by Антон Буков on 25.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AACDUser : NSManagedObject

@property (nonatomic) int64_t key;
@property (nonatomic, retain) NSData * value;

@end
