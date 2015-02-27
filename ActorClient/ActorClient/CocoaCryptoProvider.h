//
//  CocoaCryptoProvider.h
//  ActorClient
//
//  Created by Антон Буков on 27.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "im/actor/model/CryptoProvider.h"

@interface CocoaCryptoProvider : NSObject <AMCryptoProvider>

- (IOSByteArray *)SHA256WithByteArray:(IOSByteArray *)data;

@end
