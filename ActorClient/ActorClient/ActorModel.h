//
//  ActorModel.h
//  ActorClient
//
//  Created by Антон Буков on 05.03.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#ifndef ActorClient_ActorModel_h
#define ActorClient_ActorModel_h

#import "J2ObjC_source.h"

// Java Objects

#import "java/lang/Exception.h"
#import "java/lang/Boolean.h"
#import "java/lang/Long.h"
#import "java/util/List.h"
#import "java/util/ArrayList.h"

// Messenger

#import "im/actor/model/Messenger.h"
#import "im/actor/model/Configuration.h"
#import "im/actor/model/ConfigurationBuilder.h"
#import "im/actor/model/ApiConfiguration.h"
#import "im/actor/model/StorageProvider.h"
#import "im/actor/model/CryptoProvider.h"
#import "im/actor/model/FileSystemProvider.h"
#import "im/actor/model/LogProvider.h"
#import "im/actor/model/MainThreadProvider.h"

#import "im/actor/model/storage/BaseStorageProvider.h"
#import "im/actor/model/crypto/bouncycastle/BouncyCastleProvider.h"
#import "im/actor/model/cocoa/CocoaThreadingProvider.h"

// DroidKit Engine

#import "im/actor/model/droidkit/engine/ListEngine.h"
#import "im/actor/model/droidkit/engine/ListEngineItem.h"
#import "im/actor/model/droidkit/engine/ListEngineRecord.h"
#import "im/actor/model/droidkit/engine/ListEngineCallback.h"
#import "im/actor/model/droidkit/engine/ListEngineDisplayListener.h"
#import "im/actor/model/droidkit/engine/ListStorage.h"
#import "im/actor/model/droidkit/engine/KeyValueRecord.h"
#import "im/actor/model/droidkit/engine/KeyValueEngine.h"
#import "im/actor/model/droidkit/engine/KeyValueStorage.h"
#import "im/actor/model/droidkit/engine/KeyValueRecord.h"
#import "im/actor/model/droidkit/engine/PreferencesStorage.h"

// DroidKit Bser

#import "im/actor/model/droidkit/bser/BSerObject.h"

// DroidKit MVVM

#import "im/actor/model/mvvm/MVVMCollection.h"
#import "im/actor/model/mvvm/ValueModel.h"
#import "im/actor/model/mvvm/ValueChangedListener.h"
#import "im/actor/model/mvvm/DisplayList.h"
#import "im/actor/model/mvvm/BindedDisplayList.h"

// I18N

#import "im/actor/model/i18n/I18NEngine.h"

// Files

#import "im/actor/model/files/FileSystemReference.h"
#import "im/actor/model/files/InputFile.h"
#import "im/actor/model/files/OutputFile.h"

#import "im/actor/model/modules/file/DownloadCallback.h"

// Entities

#import "im/actor/model/entity/Avatar.h"
#import "im/actor/model/entity/AvatarImage.h"
#import "im/actor/model/entity/Contact.h"
#import "im/actor/model/entity/ContentType.h"
#import "im/actor/model/entity/Dialog.h"
#import "im/actor/model/entity/FileReference.h"
#import "im/actor/model/entity/Message.h"
#import "im/actor/model/entity/MessageState.h"
#import "im/actor/model/entity/Peer.h"
#import "im/actor/model/entity/PeerType.h"
#import "im/actor/model/entity/User.h"
#import "im/actor/model/entity/content/AbsContent.h"
#import "im/actor/model/entity/content/TextContent.h"
#import "im/actor/model/entity/ContentType.h"
#import "im/actor/model/entity/FileReference.h"

// Entities View Model

#import "im/actor/model/viewmodel/UserVM.h"
#import "im/actor/model/viewmodel/UserTypingVM.h"
#import "im/actor/model/viewmodel/GroupTypingVM.h"

// Misc

#import "im/actor/model/AuthState.h"
#import "im/actor/model/concurrency/Command.h"
#import "im/actor/model/concurrency/CommandCallback.h"

#endif
