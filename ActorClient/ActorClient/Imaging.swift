//
//  Imaging.swift
//  ActorClient
//
//  Created by Stepan Korshakov on 12.03.15.
//  Copyright (c) 2015 Actor LLC. All rights reserved.
//

import Foundation
import Darwin

extension UIImage {
    func tintImage(color:UIColor) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(self.size,false,UIScreen.mainScreen().scale);
        
        var rect = CGRectZero;
        rect.size = self.size;
        // Composite tint color at its own opacity.
        color.set();
        UIRectFill(rect);
        
        // Mask tint color-swatch to this image's opaque mask.
        // We want behaviour like NSCompositeDestinationIn on Mac OS X.
        self.drawInRect(rect, blendMode: kCGBlendModeDestinationIn, alpha: 1.0)
        
        var image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    }
    
    func roundImage(newSize: Int) -> UIImage {
        var nSize = CGSize(width: newSize, height: newSize)
        UIGraphicsBeginImageContextWithOptions(nSize,false,UIScreen.mainScreen().scale);
        var context = UIGraphicsGetCurrentContext();
        CGContextAddPath(context, CGPathCreateWithEllipseInRect(CGRect(origin: CGPointZero, size: nSize),nil));
        CGContextClip(context);
        
        self.drawInRect(CGRect(origin: CGPointZero, size: nSize));
        
        CGContextSetStrokeColorWithColor(context, UIColor(red: 0, green: 0, blue: 0, alpha: 0x19/255.0).CGColor);
        CGContextAddArc(context,CGFloat(newSize)/2, CGFloat(newSize)/2, CGFloat(newSize)/2, CGFloat(M_PI * 0), CGFloat(M_PI * 2), 0);
        CGContextDrawPath(context, kCGPathStroke);
        
        var image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
}

class Imaging {
    
    class func avatarPlaceholder(index: jint, size: Int) -> UIImage {
        var color = Resources.placeHolderColors[Int(abs(index)) % Resources.placeHolderColors.count].CGColor;
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: size, height: size), false, UIScreen.mainScreen().scale);
        var context = UIGraphicsGetCurrentContext();

        // Background
        CGContextSetFillColorWithColor(context, color);
        CGContextAddArc(context,CGFloat(size)/2, CGFloat(size)/2, CGFloat(size)/2, CGFloat(M_PI * 0), CGFloat(M_PI * 2), 0);
        CGContextDrawPath(context, kCGPathFill);
        
        
        
        
        CGContextSetStrokeColorWithColor(context, UIColor(red: 0, green: 0, blue: 0, alpha: 0x10/255.0).CGColor);
        CGContextAddArc(context,CGFloat(size)/2, CGFloat(size)/2, CGFloat(size)/2, CGFloat(M_PI * 0), CGFloat(M_PI * 2), 0);
        CGContextDrawPath(context, kCGPathStroke);
        
        var image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }

}