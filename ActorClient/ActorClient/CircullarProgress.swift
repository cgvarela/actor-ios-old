//
//  CircullarProgress.swift
//  ActorClient
//
//  Created by Stepan Korshakov on 17.03.15.
//  Copyright (c) 2015 Actor LLC. All rights reserved.
//

import Foundation

class CircullarProgress : UIView {
    
    init() {
        super.init(frame: CGRectMake(0, 0, 0, 0));
        
        self.backgroundColor = UIColor.clearColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let strokeW : CGFloat = 3
        let rotationSpeed : Double = 1600
        
        let r = (min(frame.width, frame.height) - strokeW * 4) / 2
        let centerX = frame.width / 2
        let centerY = frame.height / 2  
        
        var baseAngle : Double = 2 * M_PI * ((CFAbsoluteTimeGetCurrent() * 1000) % rotationSpeed);
        let angle : CGFloat = CGFloat(baseAngle) / CGFloat(rotationSpeed);
        
        var isAnimated = true
        
        var angle2 = CGFloat(0.1 * 2 * M_PI);
        
        // Draw panel
        UIColor.whiteColor().set()
        CGContextSetLineWidth(context, strokeW)
        CGContextAddArc(context, centerX, centerY, r, CGFloat(angle), CGFloat(angle + angle2), 0);
        CGContextDrawPath(context, kCGPathStroke);
        
        var startX = CGFloat(cos(angle)) * r
        var startY = CGFloat(sin(angle)) * r
        
        var endX = CGFloat(cos(angle + angle2)) * r
        var endY = CGFloat(sin(angle + angle2)) * r
        
        CGContextAddArc(context, centerX + startX, centerY + startY, strokeW / 2, CGFloat(M_PI * 0), CGFloat(M_PI * 2), 0);
        CGContextDrawPath(context, kCGPathFill);
        
        CGContextAddArc(context, centerX + endX, centerY + endY, strokeW / 2, CGFloat(M_PI * 0), CGFloat(M_PI * 2), 0);
        CGContextDrawPath(context, kCGPathFill);
        
        if (isAnimated) {
            dispatch_async(dispatch_get_main_queue(), {
                self.setNeedsDisplay()
            });
        }
    }
}