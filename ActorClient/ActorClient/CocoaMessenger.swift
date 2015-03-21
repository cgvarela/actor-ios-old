//
//  CocoaMessenger.swift
//  ActorClient
//
//  Created by Stepan Korshakov on 10.03.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

import Foundation

private var holder:CocoaMessenger?;

var MSG : CocoaMessenger {
get{
    if (holder == nil){
        var dbPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)[0].stringByAppendingPathComponent("actor.db");
//        var db = FMDatabase(path: dbPath);
//        db.open()
        var builder = AMConfigurationBuilder();
    

        // Providers
        
        builder.setLogProvider(CocoaLogProvider())
        builder.setNetworkProvider(SwiftCocoaNetworkProvider())
        builder.setThreadingProvider(AMCocoaThreadingProvider())
        builder.setStorageProvider(CocoaStorage(dbPath: dbPath))
        builder.setMainThreadProvider(CocoaMainThreadProvider())
        builder.setLocaleProvider(CocoaLocale())
        builder.setPhoneBookProvider(CocoaPhoneBookProvider())
        builder.setCryptoProvider(BCBouncyCastleProvider())
        builder.setFileSystemProvider(CocoaFileSystem())
        builder.setNotificationProvider(iOSNotificationProvider())
        builder.setEnableNetworkLogging(true)
        
        // Connection
        builder.addEndpoint("tls://mtproto-api.actor.im:443");
        
        var value: UInt8 = 0xFF
        var convHash = IOSByteArray.newArrayWithLength(32)
        var buf = UnsafeMutablePointer<UInt8>(convHash.buffer());
        for i in 1..<32 {
            buf.memory = UInt8(arc4random_uniform(255));
            buf++;
//            convHash.buffer()[i] = jbyte(0xFF);
        }
        
        builder.setApiConfiguration(AMApiConfiguration(NSString: "Actor iOS", withInt: 1, withNSString: "???", withNSString: "My Device", withByteArray: convHash))

        holder = CocoaMessenger(AMConfiguration: builder.build());
    }
    return holder!;
    }
}

@objc class CocoaMessenger : AMMessenger {
    class func messenger() -> CocoaMessenger { return MSG }
}