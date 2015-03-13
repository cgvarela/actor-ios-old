//
//  CocoaFileSystem.swift
//  ActorClient
//
//  Created by Stepan Korshakov on 13.03.15.
//  Copyright (c) 2015 Actor LLC. All rights reserved.
//

import Foundation

@objc class CocoaFileSystem : NSObject, AMFileSystemProvider {
    
    func createTempFile() -> ImActorModelFilesFileReference! {
        var fileName = NSTemporaryDirectory().stringByAppendingPathComponent(NSUUID().UUIDString);
        NSFileManager.defaultManager().createFileAtPath(fileName, contents: NSData(), attributes: nil);
        return CocoaFile(path: fileName);
    }
    
    func commitTempFileWithImActorModelFilesFileReference(sourceFile: ImActorModelFilesFileReference!, withAMFileReference fileReference: AMFileReference!) -> ImActorModelFilesFileReference! {
        return sourceFile!;
    }
    
    func fileFromDescriptorWithNSString(descriptor: String!) -> ImActorModelFilesFileReference! {
        return CocoaFile(path: descriptor!);
    }
    
    func isFsPersistent() -> Bool {
        return true;
    }
}

class CocoaDownloadCallback : NSObject, ImActorModelModulesFileDownloadCallback {
    
    let notDownloaded: ()->()
    let onDownloading: (progress: Float) -> ()
    let onDownloaded: (fileName: String) -> ()
    
    
    init(notDownloaded: ()->(), onDownloading: (progress: Float) -> (), onDownloaded: (reference: String) -> ()) {
        self.notDownloaded = notDownloaded;
        self.onDownloading = onDownloading;
        self.onDownloaded = onDownloaded;
    }

    func onNotDownloaded() {
        self.notDownloaded();
    }
    
    func onDownloadingWithFloat(progress: jfloat) {
        self.onDownloading(progress: Float(progress));
    }
    
    func onDownloadedWithImActorModelFilesFileReference(reference: ImActorModelFilesFileReference!) {
        self.onDownloaded(fileName: reference!.getDescriptor());
    }
}

class CocoaFile : NSObject, ImActorModelFilesFileReference {
    
    let path:String;
    
    init(path:String) {
        self.path = path;
    }
    
    func getDescriptor() -> String! {
        return path;
    }
    
    func isExist() -> Bool {
        return false;//NSFileManager().fileExistsAtPath(path);
    }
    
    func getSize() -> jint {
        var error:NSError?;
        var attrs = NSFileManager().attributesOfItemAtPath(path, error: &error);
        if (error != nil) {
            return 0;
        }
        
        var res = jint(NSDictionary.fileSize(attrs!)());
        NSLog("File size %@, size: %d", path, res);
        return res;
    }
    
    func openWriteWithInt(size: jint) -> ImActorModelFilesOutputFile! {
        NSLog("Open file write %@, size: %d", path, size);
        
        var fileHandle = NSFileHandle(forWritingAtPath: path);

        if (fileHandle == nil) {
            NSLog("Load error");
            return nil
        }
        
        fileHandle!.seekToFileOffset(UInt64(size))
        fileHandle!.seekToFileOffset(0)
        
        NSLog("File opened");
        return CocoaOutputFile(fileHandle: fileHandle!);
    }
    
    func openRead() -> ImActorModelFilesInputFile! {
        
        NSLog("Open file read %@", path);
        
        var fileHandle = NSFileHandle(forReadingAtPath: path);
        
        if (fileHandle == nil) {
            NSLog("Load error");
            return nil
        }
        
        NSLog("File opened");

        return CocoaInputFile(fileHandle: fileHandle!);
    }
}

class CocoaOutputFile : NSObject, ImActorModelFilesOutputFile {
    
    let fileHandle: NSFileHandle;
    
    init(fileHandle:NSFileHandle){
        self.fileHandle = fileHandle;
    }

    func writeWithInt(fileOffset: jint, withByteArray data: IOSByteArray!, withInt dataOffset: jint, withInt dataLen: jint) -> Bool {
        
        NSLog("File write size %d, offset: %d", dataLen, fileOffset);
        
        var toWrite = NSMutableData(length: Int(dataLen))!;
        var srcBuffer = UnsafeMutablePointer<UInt8>(data.buffer());
        var destBuffer = UnsafeMutablePointer<UInt8>(toWrite.bytes);
        for i in 0..<dataLen {
            destBuffer.memory = srcBuffer.memory;
            destBuffer++;
            srcBuffer++;
        }
        
        NSLog("File write toWrite %d, offset: %d", toWrite.length, fileHandle.offsetInFile);
        fileHandle.seekToFileOffset(UInt64(fileOffset));
        fileHandle.writeData(toWrite)
        
        NSLog("File write success");

        return true;
    }
    
    func close() -> Bool {
        self.fileHandle.synchronizeFile()
        self.fileHandle.closeFile()
        return true;
    }
}

class CocoaInputFile :NSObject, ImActorModelFilesInputFile {
    
    let fileHandle:NSFileHandle;
    init(fileHandle:NSFileHandle){
        self.fileHandle = fileHandle;
    }
    
    func readWithInt(fileOffset: jint, withByteArray data: IOSByteArray!, withInt offset: jint, withInt len: jint) -> Bool {
        
        NSLog("File read");
        
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
        
        NSLog("File read success");
        
        return true;
    }
    
    func close() -> Bool {
        self.fileHandle.closeFile()
        return true;

    }
}