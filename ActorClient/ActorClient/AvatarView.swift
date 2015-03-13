//
//  AvatarView.swift
//  ActorClient
//
//  Created by Stepan Korshakov on 13.03.15.
//  Copyright (c) 2015 Actor LLC. All rights reserved.
//

import Foundation
import UIKit

class AvatarView : UIImageView {
    let size: Int;
    
    // Request
    var requestId: Int = 0;
    var bindedFile: jlong? = nil;
    var callback: CocoaDownloadCallback? = nil;

    init(size: Int) {
        self.size = size;
        super.init(image: nil);
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(avatar: AMAvatar!) {
        unbind()
        
        if (avatar == nil || avatar.getSmallImage() == nil){
            return
        }
        
        requestId++;
        var callbackRequest = requestId;
        
        self.bindedFile = avatar.getSmallImage().getFileReference().getFileId();
        self.callback = CocoaDownloadCallback(notDownloaded: { () -> () in
            
            }, onDownloading: { (progress) -> () in
                
            }, onDownloaded: { (reference) -> () in
                if (callbackRequest != self.requestId) {
                    return;
                }
                
                var image = UIImage(contentsOfFile: reference);
                
                if (image == nil) {
                    NSLog("Unable to load image %@", reference);
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    if (callbackRequest != self.requestId) {
                        return;
                    }
                    
                    self.image = image;
                    
                    self.unbind()
                });
        });
        MSG.bindRawFileWithAMFileReference(avatar.getSmallImage().getFileReference(), withBoolean: true, withImActorModelModulesFileDownloadCallback: self.callback)
    }
    
    func unbind() {
        if (bindedFile != nil && callback != nil){
            MSG.unbindRawFileWithLong(bindedFile!, withBoolean: false, withImActorModelModulesFileDownloadCallback: callback)
            callback = nil;
            bindedFile = nil;
            requestId++;
        }
    }
}