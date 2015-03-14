//
//  CocoaStorage.swift
//  ActorClient
//
//  Created by Stepan Korshakov on 14.03.15.
//  Copyright (c) 2015 Actor LLC. All rights reserved.
//

import Foundation

@objc class CocoaStorage : NSObject, AMStorage {
    
    let dbPath: String;
    init(dbPath: String) {
        self.dbPath = dbPath;
    }
    
    func createPreferencesStorage() -> AMPreferencesStorage! {
        return UserDefaultsPreferencesStorage();
    }
    
    func createDownloadsEngine() -> AMKeyValueStorage! {
        return FMDBKeyValue(databasePath: dbPath, tableName: "downloads")
    }
    
    func createGroupsEngine() -> AMKeyValueStorage! {
        return FMDBKeyValue(databasePath: dbPath, tableName: "groups")
    }
    
    func createUsersEngine() -> AMKeyValueStorage! {
        return FMDBKeyValue(databasePath: dbPath, tableName: "users")
    }
    
    func createContactsEngine() -> AMListEngine! {
        return CoreDataListEngine(MOS: AACDContact.self, serializer: { (sourceItem) -> NSData! in
            return (sourceItem as! AMContact).toByteArray().toNSData();
            }, deserializer: { (data) -> AMListEngineItem! in
                if (data == nil) {
                    return nil
                }
                return AMContact.fromBytesWithByteArray(data.toJavaBytes());
        })
    }
    
    func createDialogsEngine() -> AMListEngine! {
        return CoreDataListEngine(MOS: AACDDialog.self, serializer: { (sourceItem) -> NSData! in
            return (sourceItem as! AMDialog).toByteArray().toNSData();
        }, deserializer: { (data) -> AMListEngineItem! in
            if (data == nil) {
                return nil
            }
            return AMDialog.fromBytesWithByteArray(data.toJavaBytes());
        })
    }
    
    func createMessagesEngineWithAMPeer(peer: AMPeer!) -> AMListEngine! {
        return ZonedCoreDataListEngine(MOS: AACDMessage.self, zone_id: peer.getPeerId(), serializer: { (sourceItem) -> NSData! in
            return (sourceItem as! AMMessage).toByteArray().toNSData();
        }, deserializer: { (data) -> AMListEngineItem! in
            if (data == nil) {
                return nil
            }
            return AMMessage.fromBytesWithByteArray(data.toJavaBytes());
        });
    }
}