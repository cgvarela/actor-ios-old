//
//  AADialog.h
//  ActorModel
//
//  Created by Антон Буков on 17.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DBDialog : NSManagedObject

@property (nonatomic) int64_t key;
@property (nonatomic) int64_t sortKey;
@property (nonatomic, retain) NSData * value;

@end
