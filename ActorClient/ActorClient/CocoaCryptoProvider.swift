//
// Created by Stepan Korshakov on 10.03.15.
// Copyright (c) 2015 Anton Bukov. All rights reserved.
//

import Foundation

@objc class CocoaCryptoProvider: NSObject, JavaObject, AMCryptoProvider  {
    func SHA256WithByteArray(data: IOSByteArray) -> IOSByteArray {
        var ret = IOSByteArray(length: 32);
        CC_SHA256(data.buffer(), CC_LONG(data.length()), UnsafeMutablePointer<UInt8>(ret.buffer()));
        return ret;
    }
}
