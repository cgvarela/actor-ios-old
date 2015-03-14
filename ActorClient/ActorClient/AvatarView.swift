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
    let frameSize: Int;
    let fontSize: Float;
    
    // Request
    var bindedAvatar: AMAvatar! = nil;
    var bindedTitle: String! = nil;
    var bindedId: jint! = nil;
    
    var requestId: Int = 0;
    var bindedFile: jlong? = nil;
    var callback: CocoaDownloadCallback? = nil;

    init(frameSize: Int, fontSize: Float) {
        self.frameSize = frameSize;
        self.fontSize = fontSize;
        super.init(image: nil);
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(title: String, id:jint, avatar: AMAvatar!) {

        // Ignore double-binding
//        if (bindedAvatar != nil && bindedId != nil && bindedTitle != nil && avatar == bindedAvatar && id == bindedId && title == bindedTitle) {
//            return
//        }
        
        // Unbind all old data
        unbind()
        
        self.bindedTitle = title;
        self.bindedAvatar = avatar;
        self.bindedId = id;
        
        if (avatar == nil || avatar.getSmallImage() == nil) {
            // Load placeholder
            self.image = Imaging.avatarPlaceholder(bindedId, size: frameSize);
            
        } else {
            requestId++;
            var callbackRequest = requestId;
            
            self.bindedFile = avatar.getSmallImage().getFileReference().getFileId();
            self.callback = CocoaDownloadCallback(onDownloaded: { (reference) -> () in
                    if (callbackRequest != self.requestId) {
                        NSLog("Ignore result");
                        return;
                    }
                    
                    var image = UIImage(contentsOfFile: reference);
                    
                    if (image == nil) {
                        NSLog("Unable to load image %@", reference);
                    }
                
                    image = image!.roundImage(Int(Float(self.frameSize) * (Float(UIScreen.mainScreen().scale))));
                
                    dispatch_async(dispatch_get_main_queue(), {
                        if (callbackRequest != self.requestId) {
                            NSLog("Ignore result: ui %d/%d", callbackRequest, self.requestId);
                            return;
                        }
                        
                        self.image = image;
                        
                        // self.unbind()
                    });
            });
            MSG.bindRawFileWithAMFileReference(avatar.getSmallImage().getFileReference(), withBoolean: true, withImActorModelModulesFileDownloadCallback: self.callback)
        }
    }
    
    func unbind() {
        bindedAvatar = nil
        bindedTitle = nil
        bindedId = nil
        self.image = nil
        
        if (bindedFile != nil && callback != nil){
            MSG.unbindRawFileWithLong(bindedFile!, withBoolean: false, withImActorModelModulesFileDownloadCallback: callback)
            callback = nil;
            bindedFile = nil;
            requestId++;
        }
    }
}