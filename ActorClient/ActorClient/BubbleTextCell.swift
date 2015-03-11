
//
//  BubbleTextCell.swift
//  ActorClient
//
//  Created by Stepan Korshakov on 11.03.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

import Foundation
import UIKit


class BubbleTextCell : BubbleCell {
    
    class func measureTextHeight(message: AMMessage) -> CGFloat {
        var content = message.getContent() as! AMTextContent!;
        
        var style = NSMutableParagraphStyle();
        style.lineBreakMode = NSLineBreakMode.ByWordWrapping;
        style.alignment = NSTextAlignment.Left;
        
        var font = UIFont(name: "HelveticaNeue", size: 16)!;
        
        var attributes = [NSFontAttributeName: font, NSParagraphStyleAttributeName: style];
        
        var text = content.getText() as NSString;
        var size = CGSize(width: 260, height: 0);
        var rect = text.boundingRectWithSize(size, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes, context: nil);
        return round(rect.height) + 24;
    }

    
    let bubblePadding:CGFloat = 5;
    
    let textPaddingStart:CGFloat = 10.0;
    let textPaddingEnd:CGFloat = 8.0;
    
    let bubble = UIImageView();
    let messageText = UILabel();
    let dateText = UILabel();
    let statusView = UIImageView();
    var isOut:Bool = false;
    
    init() {
        super.init(reuseId: "bubble_text");
        
        //        self.layer.shouldRasterize=true;
        //        self.layer.rasterizationScale = UIScreen.mainScreen().scale;
        
        messageText.font = UIFont(name: "HelveticaNeue", size: 16);
        messageText.lineBreakMode = .ByWordWrapping;
        messageText.numberOfLines = 0;
        messageText.textColor = UIColor(red: 20/255.0, green: 22/255.0, blue: 23/255.0, alpha: 1.0);
        
        addSubview(bubble);
        addSubview(messageText);
        addSubview(dateText);
        addSubview(statusView);
        
        self.backgroundColor = UIColor.clearColor();
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind(message: AMMessage) {
        messageText.text = (message.getContent() as! AMTextContent).getText();
        dateText.text = formatDate(message.getDate());
        isOut = message.getSenderId() == MSG.myUid();
        if (isOut) {
            bubble.image =  UIImage(named: "BubbleOutgoingFull");
        } else {
            bubble.image =  UIImage(named: "BubbleIncomingFull");
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        
        //        let sourceW = min(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height);

        UIView.performWithoutAnimation { () -> Void in
            let maxW = 260;
            self.messageText.frame = CGRectMake(0, 0, 260, 1000);
            self.messageText.sizeToFit();
            var w = round(self.messageText.frame.width);
            var h = round(self.messageText.frame.height);
            if (w % 2 == 1){
                w += 1;
            }
            if (h % 2 == 1){
                h += 1;
            }
            
            if (self.isOut) {
                self.messageText.frame = CGRectMake(self.frame.width - w - self.textPaddingEnd - self.bubblePadding, 12, w, h);
            } else {
                self.messageText.frame = CGRectMake(self.bubblePadding+self.textPaddingStart, 12, w, h);
            }
            
            let x = round(self.messageText.frame.minX);
            let y = round(self.messageText.frame.minY);
            if (self.isOut) {
                self.bubble.frame = CGRectMake(x - self.textPaddingEnd, y - 10, w + self.textPaddingStart+self.textPaddingEnd, h + 20);
            } else {
                self.bubble.frame = CGRectMake(x - self.textPaddingStart, y - 10, w + self.textPaddingStart+self.textPaddingEnd, h + 20);
            }
        }
    }
}