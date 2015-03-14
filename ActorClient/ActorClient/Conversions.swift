//
//  Conversions.swift
//  ActorClient
//
//  Created by Stepan Korshakov on 14.03.15.
//  Copyright (c) 2015 Actor LLC. All rights reserved.
//

import Foundation

extension NSData {
    func toJavaBytes() -> IOSByteArray {
        return IOSByteArray(bytes: UnsafePointer<jbyte>(self.bytes), count: UInt(self.length))
    }
}

extension jlong {
    func toNSNumber() -> NSNumber {
        return NSNumber(longLong: self)
    }
}