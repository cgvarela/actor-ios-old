//
//  UserLevelDBKeyValueEngine.h
//  ActorModel
//
//  Created by Антон Буков on 17.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "LevelDBKeyValueEngine.h"

@interface UserLevelDBKeyValueEngine : LevelDBKeyValueEngine

- (instancetype)initWithName:(NSString *)name;

@end
