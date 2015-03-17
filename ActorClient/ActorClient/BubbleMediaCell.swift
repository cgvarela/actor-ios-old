//
//  BubbleMediaCell.swift
//  ActorClient
//
//  Created by Stepan Korshakov on 17.03.15.
//  Copyright (c) 2015 Actor LLC. All rights reserved.
//

import Foundation

class BubbleMediaCell : BubbleCell {
    
    class func measureMediaHeight(message: AMMessage) -> CGFloat {
        return 100
    }
    
    let bubble = UIImageView();
    let preview = UIImageView();
    let circullarView = CircullarProgress()
    
    var isOut:Bool = false;
    var contentWidth = 0
    var contentHeight = 0
    var thumb : AMFastThumb? = nil
    
    init() {
        super.init(reuseId: "bubble_media")
        
        bubble.image = UIImage(named: "BubbleIncomingPartial")
        
        contentView.addSubview(bubble)
        contentView.addSubview(preview)
        contentView.addSubview(circullarView)
        
        self.backgroundColor = UIColor.clearColor();
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind(message: AMMessage) {
        self.isOut = message.getSenderId() == MSG.myUid()
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let padding = CGFloat(8)
        
        var width = contentView.frame.width
        var height = contentView.frame.height
        
        var bubbleHeight = height - padding * 2
        var bubbleWidth = bubbleHeight * CGFloat(contentWidth) / CGFloat(contentHeight)
        
        if (self.isOut) {
            self.bubble.frame = CGRectMake(width - bubbleWidth - padding, 0, bubbleWidth, bubbleHeight)
        } else {
            self.bubble.frame = CGRectMake(padding, 0, bubbleWidth, bubbleHeight)
        }
        
        preview.frame = CGRectMake(bubble.frame.origin.x + 6, bubble.frame.origin.y + 1,
            bubble.frame.width - 4, bubble.frame.height - 2);
        if (thumb != nil) {
            preview.image = UIImage(data: thumb!.getImage().toNSData()!)?.roundCorners(bubbleWidth-2, h: bubbleHeight-2, roundSize: 16)
        } else {
            preview.image = nil
        }
        circullarView.frame = CGRectMake(
            preview.frame.origin.x +
            preview.frame.width/2 - 32,
            preview.frame.origin.y +
            preview.frame.height/2 - 32, 64, 64)
    }
}