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
        builder.setCryptoProviderWithAMCryptoProvider(CocoaCryptoProvider());
        var config = builder.build();
        holder = CocoaMessenger(config:config);
    }
    return holder!;
    }
}

@objc class CocoaMessenger : AMMessenger {
    class func messenger() -> CocoaMessenger { return MSG }
}