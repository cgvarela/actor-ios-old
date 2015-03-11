//
//  BubbleView.swift
//  ActorClient
//
//  Created by Stepan Korshakov on 11.03.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

import Foundation
import UIKit;


class BubbleCell: UITableViewCell {

    class func measureHeight(message: AMMessage) -> CGFloat {
        var content = message.getContent()!;
        if (content is AMTextContent){
            return BubbleTextCell.measureTextHeight(message);
        } else {
            fatalError("Unsupported content");
        }
    }
    
    init(reuseId: String){
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: reuseId);
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(message: AMMessage){
        fatalError("bind(message:) has not been implemented")
    }
    
    func formatDate(date:Int64) -> String {
        var dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "HH:mm";
        return dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: NSTimeInterval(date)));
    }
}

