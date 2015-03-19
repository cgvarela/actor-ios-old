//
//  BubbleServiceCell.swift
//  ActorClient
//
//  Created by Stepan Korshakov on 19.03.15.
//  Copyright (c) 2015 Actor LLC. All rights reserved.
//

import Foundation

class BubbleServiceCell : BubbleCell {
    
    var serviceText = UILabel()
    
    init() {
        super.init(reuseId: "bubble_service")
        
        self.contentView.addSubview(serviceText)
        
        self.backgroundColor = UIColor.clearColor();
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func bind(message: AMMessage) {
        serviceText.text = MSG.getFormatter().formatFullServiceMessageWithInt(message.getSenderId(), withAMServiceContent: message.getContent() as! AMServiceContent)
    }
    
    override func layoutSubviews() {
        serviceText.frame = CGRectMake(0, 0, self.contentView.frame.width, self.contentView.frame.height);
    }
}