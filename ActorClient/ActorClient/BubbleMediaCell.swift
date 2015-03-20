//
//  BubbleMediaCell.swift
//  ActorClient
//
//  Created by Stepan Korshakov on 17.03.15.
//  Copyright (c) 2015 Actor LLC. All rights reserved.
//

import Foundation

class BubbleMediaCell : BubbleCell {
    
    class func measureMedia(w: Int, h: Int) -> CGSize {
        var screenScale = UIScreen.mainScreen().scale;
        var scaleW = 240 / CGFloat(w)
        var scaleH = 340 / CGFloat(h)
        var scale = min(scaleW, scaleH)
        return CGSize(width: scale * CGFloat(w), height: scale * CGFloat(h))
    }
    
    class func measureMediaHeight(message: AMMessage) -> CGFloat {
        var content = message.getContent() as! AMDocumentContent;
        if (message.getContent() is AMPhotoContent){
            var photo = message.getContent() as! AMPhotoContent;
            return measureMedia(Int(photo.getW()), h: Int(photo.getH())).height + 8;
        }
        
        fatalError("???")
    }
    
    let bubble = UIImageView();
    let preview = UIImageView();
    let circullarNode = CircullarNode()
//    let circullarView = CircullarProgress()
    
    var isOut:Bool = false;
    var contentWidth = 0
    var contentHeight = 0
    var thumb : AMFastThumb? = nil
    
    init() {
        super.init(reuseId: "bubble_media")
        
        bubble.image = UIImage(named: "conv_media_bg")
        
        contentView.addSubview(bubble)
        contentView.addSubview(preview)
        contentView.addSubview(circullarNode.view)
//        contentView.addSubview(circullarView)
        
        self.backgroundColor = UIColor.clearColor();
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind(message: AMMessage) {
        
        NSLog("Bind media \(message.getRid())@\(self.hashValue)");
        
        self.isOut = message.getSenderId() == MSG.myUid()
        
        circullarNode.setProgress(0, animated: false)
        
//        UIView.animateWithDuration(0, animations: { () -> Void in
//            self.circullarView.resetProgress(0)
//            self.circullarView.alpha = 0
//        })

        if (message.getContent() is AMPhotoContent) {
            var photo = message.getContent() as! AMPhotoContent;
            thumb = photo.getFastThumb()
            contentWidth = Int(photo.getW())
            contentHeight = Int(photo.getH())
        } else if (message.getContent() is AMVideoContent) {
            var video = message.getContent() as! AMVideoContent;
            thumb = video.getFastThumb()
            contentWidth = Int(video.getW())
            contentHeight = Int(video.getH())
        } else {
            fatalError("Unsupported content")
        }
        
        var document = message.getContent() as! AMDocumentContent;
        
        // circullarView.hidden = true
        var bubbleHeight = BubbleMediaCell.measureMediaHeight(message) - 8
        var bubbleWidth = bubbleHeight * CGFloat(contentWidth) / CGFloat(contentHeight)
        
        if (document.getSource() is AMFileRemoteSource) {
        
        var fastThumbLoaded = false
        var callback = CocoaDownloadCallback(notDownloaded: { () -> () in
            if (fastThumbLoaded) {
                return
            }
            fastThumbLoaded = true
            
            var img = UIImage(data: self.thumb!.getImage().toNSData()!)?.roundCorners(bubbleWidth - 2, h: bubbleHeight - 2, roundSize: 14)
            dispatch_async(dispatch_get_main_queue(), {
                self.preview.image = img
                // self.circullarView.hidden = true
//                UIView.animateWithDuration(0.3, animations: { () -> Void in
//                    self.circullarView.alpha = 0
//                })
            })
        }, onDownloading: { (progress) -> () in
            
            self.circullarNode.postProgress(Double(progress), animated: true)
            // self.circullarView.setProgress(Double(progress))
            
            if (fastThumbLoaded) {
                return
            }
            fastThumbLoaded = true
            var img = UIImage(data: self.thumb!.getImage().toNSData()!)?.roundCorners(bubbleWidth - 2, h: bubbleHeight - 2, roundSize: 14)
            dispatch_async(dispatch_get_main_queue(), {
                self.preview.image = img
//                UIView.animateWithDuration(0.3, animations: { () -> Void in
//                    self.circullarView.alpha = 1
//                })
            })
        }) { (reference) -> () in
            var img = UIImage(contentsOfFile: CocoaFiles.pathFromDescriptor(reference))?.roundCorners(bubbleWidth - 2, h: bubbleHeight - 2, roundSize: 14)
            
            dispatch_async(dispatch_get_main_queue(), {
                self.preview.image = img
//                UIView.animateWithDuration(0.3, animations: { () -> Void in
//                    self.circullarView.alpha = 0
//                })
            })
        }
        
        MSG.bindRawFileWithAMFileReference((document.getSource() as! AMFileRemoteSource).getFileReference(), withBoolean: true, withImActorModelModulesFileDownloadCallback: callback)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        NSLog("prepareForReuse media @\(self.hashValue)");
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let padding = CGFloat(10)
        
        var width = contentView.frame.width
        var height = contentView.frame.height
        
        var bubbleHeight = height - 8
        var bubbleWidth = bubbleHeight * CGFloat(contentWidth) / CGFloat(contentHeight)
        
        if (self.isOut) {
            self.bubble.frame = CGRectMake(width - bubbleWidth - padding, 4, bubbleWidth, bubbleHeight)
        } else {
            self.bubble.frame = CGRectMake(padding, 4, bubbleWidth, bubbleHeight)
        }
        
        preview.frame = CGRectMake(bubble.frame.origin.x + 1, bubble.frame.origin.y + 1, bubble.frame.width - 2, bubble.frame.height - 2);
        
        circullarNode.frame = CGRectMake(
                        preview.frame.origin.x + preview.frame.width/2 - 32,
                        preview.frame.origin.y + preview.frame.height/2 - 32,
                        64, 64)
        
//        circullarView.frame = CGRectMake(
//            preview.frame.origin.x +
//                preview.frame.width/2 - 32,
//            preview.frame.origin.y +
//                preview.frame.height/2 - 32, 64, 64)
    }
}