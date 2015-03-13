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
        var builder = AMConfigurationBuilder();
        builder.setLog(CocoaLogger());
        builder.setNetworking(CocoaNetworking());
        builder.setThreading(AMCocoaThreading());
        builder.setStorage(CocoaStorage());
        builder.setMainThread(CocoaMainThread());
        builder.addEndpoint("tls://mtproto-api.actor.im:443");
        builder.setLocale(CocoaLocale());
        builder.setPhoneBookProviderWithAMPhoneBookProvider(CocoaPhoneBookProvider());
        builder.setCryptoProviderWithAMCryptoProvider(ImActorModelCryptoBouncycastleBouncyCastleProvider());
        var value: UInt8 = 0xFF
        var convHash = IOSByteArray.newArrayWithLength(32)
        var buf = UnsafeMutablePointer<UInt8>(convHash.buffer());
        for i in 1..<32 {
            buf.memory = UInt8(arc4random_uniform(255));
            buf++;
//            convHash.buffer()[i] = jbyte(0xFF);
        }
        
        builder.setApiConfigurationWithAMApiConfiguration(AMApiConfiguration(NSString: "Actor iOS", withInt: 1, withNSString: "???", withNSString: "My Device", withByteArray: convHash))
        builder.setFileSystemProviderWithAMFileSystemProvider(CocoaFileSystem())
        var config = builder.build();
        holder = CocoaMessenger(config:config);
    }
    return holder!;
    }
}

@objc class CocoaMessenger : AMMessenger {
    class func messenger() -> CocoaMessenger { return MSG }
}