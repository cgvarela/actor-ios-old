//
//  BubbleServiceCell.swift
//  ActorClient
//
//  Created by Stepan Korshakov on 19.03.15.
//  Copyright (c) 2015 Actor LLC. All rights reserved.
//

import Foundation

private let maxServiceTextWidth = 260
private let serviceBubbleFont = UIFont(name: "HelveticaNeue", size: 13)!

private func measureText(message: String) -> CGRect {
    var messageValue = message as NSString;
    var style = NSMutableParagraphStyle();
    style.lineBreakMode = NSLineBreakMode.ByWordWrapping;
    
    var size = CGSize(width: maxServiceTextWidth, height: 0);
    var rect = messageValue.boundingRectWithSize(size, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: serviceBubbleFont, NSParagraphStyleAttributeName: style], context: nil);
    return CGRectMake(0, 0, round(rect.width), round(rect.height))
}

class BubbleServiceCell : BubbleCell {
    
    class func measureServiceHeight(message: AMMessage) -> CGFloat {
        var text = MSG.getFormatter().formatFullServiceMessageWithInt(message.getSenderId(), withAMServiceContent: message.getContent() as! AMServiceContent);
        return measureText(text).height + 16
    }

    
    var serviceText = UILabel()
    
    init() {
        super.init(reuseId: "bubble_service")
        
        self.contentView.addSubview(serviceText)
        
        serviceText.lineBreakMode = .ByWordWrapping;
        serviceText.numberOfLines = 0;
        serviceText.textColor = UIColor.whiteColor()
        serviceText.contentMode = UIViewContentMode.Center
        serviceText.textAlignment = NSTextAlignment.Center
        serviceText.font = serviceBubbleFont;
        
        self.backgroundColor = UIColor.clearColor();
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func bind(message: AMMessage) {
        serviceText.text = MSG.getFormatter().formatFullServiceMessageWithInt(message.getSenderId(), withAMServiceContent: message.getContent() as! AMServiceContent)
    }
    
    override func layoutSubviews() {
        serviceText.frame = CGRectMake((self.contentView.frame.width - CGFloat(maxServiceTextWidth)) / 2.0, 0.0, CGFloat(maxServiceTextWidth), self.contentView.frame.height);
    }
}