
//
//  BubbleTextCell.swift
//  ActorClient
//
//  Created by Stepan Korshakov on 11.03.15.
//  Copyright (c) 2015 Actor LLC. All rights reserved.
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
        return round(rect.height) + 14;
    }

    
    let bubblePadding:CGFloat = 6;
    
    let textPaddingStart:CGFloat = 10.0;
    let textPaddingEnd:CGFloat = 8.0;
    let datePaddingOut:CGFloat = 66.0;
    let datePaddingIn:CGFloat = 20.0;
//    let dateColorOut = UIColor(red: 45/255.0, green: 163/255.0, blue: 47/255.0, alpha: 1.0);
    let dateColorOut = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.27);
    
    let dateColorIn = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1.0);
    let messageTextColor = UIColor(red: 20/255.0, green: 22/255.0, blue: 23/255.0, alpha: 1.0);
    
    let statusActive = UIColor(red: 52/255.0, green: 151/255.0, blue: 249/255.0, alpha: 1.0);
    
    // 9aad8a
    let statusPassive = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.27);
    
    let bubble = UIImageView();
    let messageText = UILabel();
    let dateText = UILabel();
    let statusView = UIImageView();
    var isOut:Bool = false;
    var messageState: UInt = AMMessageState.UNKNOWN.rawValue;
    
    init() {
        super.init(reuseId: "bubble_text");
        
        //        self.layer.shouldRasterize=true;
        //        self.layer.rasterizationScale = UIScreen.mainScreen().scale;
        
        messageText.font = UIFont(name: "HelveticaNeue", size: 16);
        messageText.lineBreakMode = .ByWordWrapping;
        messageText.numberOfLines = 0;
        messageText.textColor = messageTextColor;
        
        dateText.font = UIFont(name: "HelveticaNeue-Italic", size: 11);
        dateText.lineBreakMode = .ByClipping;
        dateText.numberOfLines = 1;
        dateText.textAlignment = NSTextAlignment.Right;
        
        statusView.contentMode = UIViewContentMode.Center;
        
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
        messageState = UInt(message.getMessageState().ordinal());
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();

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
                self.messageText.frame = CGRectMake(self.frame.width - w - self.textPaddingEnd - self.bubblePadding -
                    self.datePaddingOut, 8, w, h);
                self.dateText.textColor = self.dateColorOut;
            } else {
                self.messageText.frame = CGRectMake(self.bubblePadding+self.textPaddingStart, 8, w, h);
                self.dateText.textColor = self.dateColorIn;
            }
            
            let x = round(self.messageText.frame.minX);
            let y = round(self.messageText.frame.minY);
            if (self.isOut) {
                self.bubble.frame = CGRectMake(x - self.textPaddingEnd, y - 4, w + self.textPaddingStart+self.textPaddingEnd + self.datePaddingOut, h + 8);
            } else {
                self.bubble.frame = CGRectMake(x - self.textPaddingStart, y - 4, w + self.textPaddingStart+self.textPaddingEnd + self.datePaddingIn, h + 8);
            }
            
            self.dateText.frame = CGRectMake(x + w, y + h - 20, 46, 26);
            
            if (self.isOut) {
                self.statusView.frame = CGRectMake(x + w + 46, y + h - 20, 20, 26);
                self.statusView.hidden = false;
                
                switch(self.messageState) {
                    case AMMessageState.UNKNOWN.rawValue:
                        self.statusView.image = Resources.iconClock;
                        self.statusView.tintColor = self.statusPassive;
                    case AMMessageState.PENDING.rawValue:
                        self.statusView.image = Resources.iconClock;
                        self.statusView.tintColor = self.statusPassive;
                        break;
                    case AMMessageState.SENT.rawValue:
                        self.statusView.image = Resources.iconCheck1;
                        self.statusView.tintColor = self.statusPassive;
                        break;
                    case AMMessageState.RECEIVED.rawValue:
                        self.statusView.image = Resources.iconCheck2;
                        self.statusView.tintColor = self.statusPassive;
                        break;
                    case AMMessageState.READ.rawValue:
                        self.statusView.image = Resources.iconCheck2;
                        self.statusView.tintColor = self.statusActive;
                        break;
                    default:
                        self.statusView.image = Resources.iconClock;
                        self.statusView.tintColor = self.statusPassive;
                        break;
                }
            } else {
                self.statusView.hidden = true;
            }
        }
    }
}