//
//  CocoaFileSystem.swift
//  ActorClient
//
//  Created by Stepan Korshakov on 13.03.15.
//  Copyright (c) 2015 Actor LLC. All rights reserved.
//

import Foundation

@objc class CocoaFileSystem : NSObject, AMFileSystemProvider {
    
    func createTempFile() -> AMFileSystemReference! {
        var fileName = NSTemporaryDirectory().stringByAppendingPathComponent(NSUUID().UUIDString);
        NSFileManager.defaultManager().createFileAtPath(fileName, contents: NSData(), attributes: nil);
        return CocoaFile(path: fileName);
    }
    
    func commitTempFile(sourceFile: AMFileSystemReference!, withReference fileReference: AMFileReference!) -> AMFileSystemReference! {
        return sourceFile!;
    }
    
    func fileFromDescriptor(descriptor: String!) -> AMFileSystemReference! {
        return CocoaFile(path: descriptor);
    }
    
    func isFsPersistent() -> Bool {
        return true;
    }
}

class CocoaDownloadCallback : NSObject, ImActorModelModulesFileDownloadCallback {
    
    let notDownloaded: (()->())?
    let onDownloading: ((progress: Float) -> ())?
    let onDownloaded: ((fileName: String) -> ())?
    
    init(notDownloaded: (()->())?, onDownloading: ((progress: Float) -> ())?, onDownloaded: ((reference: String) -> ())?) {
        self.notDownloaded = notDownloaded;
        self.onDownloading = onDownloading;
        self.onDownloaded = onDownloaded;
    }

    init(onDownloaded: (reference: String) -> ()) {
        self.notDownloaded = nil;
        self.onDownloading = nil;
        self.onDownloaded = onDownloaded;
    }

    func onNotDownloaded() {
        self.notDownloaded?();
    }
    
    func onDownloadingWithFloat(progress: jfloat) {
        self.onDownloading?(progress: Float(progress));
    }
    
    func onDownloadedWithAMFileSystemReference(reference: AMFileSystemReference!) {
        self.onDownloaded?(fileName: reference!.getDescriptor());
    }
}

class CocoaFile : NSObject, AMFileSystemReference {
    
    let path:String;
    
    init(path:String) {
        self.path = path;
    }
    
    func getDescriptor() -> String! {
        return path;
    }
    
    func isExist() -> Bool {
        return NSFileManager().fileExistsAtPath(path);
    }
    
    func getSize() -> jint {
        
        var error:NSError?;
        
        var attrs = NSFileManager().attributesOfItemAtPath(path, error: &error);
        
        if (error != nil) {
            return 0;
        }
        
        return jint(NSDictionary.fileSize(attrs!)());
    }
    
    func openWriteWithSize(size: jint) -> AMOutputFile! {
        
        var fileHandle = NSFileHandle(forWritingAtPath: path);

        if (fileHandle == nil) {
            return nil
        }
        
        fileHandle!.seekToFileOffset(UInt64(size))
        fileHandle!.seekToFileOffset(0)
        
        return CocoaOutputFile(fileHandle: fileHandle!);
    }
    
    func openRead() -> AMInputFile! {
        
        var fileHandle = NSFileHandle(forReadingAtPath: path);
        
        if (fileHandle == nil) {
            return nil
        }
        
        return CocoaInputFile(fileHandle: fileHandle!);
    }
}

class CocoaOutputFile : NSObject, AMOutputFile {
    
    let fileHandle: NSFileHandle;
    
    init(fileHandle:NSFileHandle){
        self.fileHandle = fileHandle;
    }

    func writeWithOffset(fileOffset: jint, withData data: IOSByteArray!, withDataOffset dataOffset: jint, withDataLen dataLen: jint) -> Bool {
        
        var toWrite = NSMutableData(length: Int(dataLen))!;
        var srcBuffer = UnsafeMutablePointer<UInt8>(data.buffer());
        var destBuffer = UnsafeMutablePointer<UInt8>(toWrite.bytes);
        for i in 0..<dataLen {
            destBuffer.memory = srcBuffer.memory;
            destBuffer++;
            srcBuffer++;
        }
        
        fileHandle.seekToFileOffset(UInt64(fileOffset));
        fileHandle.writeData(toWrite)
        
        return true;
    }
    
    func close() -> Bool {
        self.fileHandle.synchronizeFile()
        self.fileHandle.closeFile()
        return true;
    }
}

class CocoaInputFile :NSObject, AMInputFile {
    
    let fileHandle:NSFileHandle;
    
    init(fileHandle:NSFileHandle){
        self.fileHandle = fileHandle;
    }
    
    func readAtOffset(fileOffset: jint, toArray data: IOSByteArray!, withArrayOffset offset: jint, withArrayLen len: jint) -> Bool {
        
        fileHandle.seekToFileOffset(UInt64(fileOffset));
        var readed:NSData = fileHandle.readDataOfLength(Int(len));
        
        var srcBuffer = UnsafeMutablePointer<UInt8>(readed.bytes);
        var destBuffer = UnsafeMutablePointer<UInt8>(data.buffer());
        var len = min(Int(len), Int(readed.length));
        for i in offset..<offset+len {
            destBuffer.memory = srcBuffer.memory;
            destBuffer++;
            srcBuffer++;
        }
        
        return true;
    }
    
    func close() -> Bool {
        self.fileHandle.closeFile()
        return true;

    }
}