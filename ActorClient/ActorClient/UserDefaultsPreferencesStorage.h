//
//  UserDefaultsPreferencesStorage.h
//  ActorModel
//
//  Created by Антон Буков on 17.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "im/actor/model/storage/PreferencesStorage.h"

@interface UserDefaultsPreferencesStorage : NSObject <AMPreferencesStorage>

- (void)putLongWithNSString:(NSString *)key
                   withLong:(jlong)v;

- (jlong)getLongWithNSString:(NSString *)key
                    withLong:(jlong)def;

- (void)putIntWithNSString:(NSString *)key
                   withInt:(jint)v;

- (jint)getIntWithNSString:(NSString *)key
                   withInt:(jint)def;

- (void)putBoolWithNSString:(NSString *)key
                withBoolean:(jboolean)v;

- (jboolean)getBoolWithNSString:(NSString *)key
                    withBoolean:(jboolean)def;

- (void)putBytesWithNSString:(NSString *)key
               withByteArray:(IOSByteArray *)v;

- (IOSByteArray *)getBytesWithNSString:(NSString *)key;

- (void)putStringWithNSString:(NSString *)key
                 withNSString:(NSString *)v;

- (NSString *)getStringWithNSString:(NSString *)key;

@end
