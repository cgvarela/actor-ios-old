//
//  UserDefaultsPreferencesStorage.m
//  ActorModel
//
//  Created by Антон Буков on 17.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "J2ObjC_source.h"
#import "UserDefaultsPreferencesStorage.h"

@interface UserDefaultsPreferencesStorage ()

@property (nonatomic, strong) NSUserDefaults *defaults;

@end

@implementation UserDefaultsPreferencesStorage

- (NSUserDefaults *)defaults
{
    if (_defaults == nil)
        _defaults = [NSUserDefaults standardUserDefaults];
    return _defaults;
}

- (void)putLongWithNSString:(NSString *)key
                   withLong:(jlong)v
{
    [[NSUserDefaults standardUserDefaults] setObject:@(v) forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (jlong)getLongWithNSString:(NSString *)key
                    withLong:(jlong)def
{
    NSNumber *object = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return object ? object.longLongValue : def;
}

- (void)putIntWithNSString:(NSString *)key
                   withInt:(jint)v
{
    [[NSUserDefaults standardUserDefaults] setObject:@(v) forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (jint)getIntWithNSString:(NSString *)key
                   withInt:(jint)def
{
    NSNumber *object = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return object ? object.intValue : def;
}

- (void)putBoolWithNSString:(NSString *)key
                withBoolean:(jboolean)v
{
    [[NSUserDefaults standardUserDefaults] setBool:v forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (jboolean)getBoolWithNSString:(NSString *)key
                    withBoolean:(jboolean)def
{
    NSNumber *object = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return object ? object.boolValue : def;
}

- (void)putBytesWithNSString:(NSString *)key
               withByteArray:(IOSByteArray *)v
{
    [[NSUserDefaults standardUserDefaults] setObject:v.toNSData forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IOSByteArray *)getBytesWithNSString:(NSString *)key
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (data == nil) {
        return nil;
    } else {
        return [IOSByteArray arrayWithBytes:data.bytes count:data.length];
    }
}

- (void)putStringWithNSString:(NSString *)key
                 withNSString:(NSString *)v
{
    [[NSUserDefaults standardUserDefaults] setObject:v forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getStringWithNSString:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:key];
}

@end
