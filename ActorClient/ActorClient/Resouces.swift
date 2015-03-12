//
//  Resouces.swift
//  ActorClient
//
//  Created by Stepan Korshakov on 11.03.15.
//  Copyright (c) 2015 Actor LLC. All rights reserved.
//

import Foundation

 @objc class Resources {
    
    init(){
        fatalError("Unable to instantinate Resources");
    }
    
    private static var _iconCheck1:UIImage? = nil;
    private static var _iconCheck2:UIImage? = nil;
    private static var _iconError:UIImage? = nil;
    private static var _iconWarring:UIImage? = nil;
    private static var _iconClock:UIImage? = nil;
    
    static var iconCheck1:UIImage {
        get {
            if (_iconCheck1 == nil){
                _iconCheck1 = UIImage(named: "msg_check_1")?
                    .imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate);
            }
            return _iconCheck1!;
        }
    }
    
    static var iconCheck2:UIImage {
        get {
            if (_iconCheck2 == nil){
                _iconCheck2 = UIImage(named: "msg_check_2")?
                    .imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate);
            }
            return _iconCheck2!;
        }
    }

    static var iconError:UIImage {
        get {
            if (_iconError == nil){
                _iconError = UIImage(named: "msg_error")?
                    .imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate);
            }
            return _iconError!;
        }
    }
    
    static var iconWarring:UIImage {
        get {
            if (_iconWarring == nil){
                _iconWarring = UIImage(named: "msg_warring")?
                    .imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate);
            }
            return _iconWarring!;
        }
    }

    static var iconClock:UIImage {
        get {
            if (_iconClock == nil){
                _iconClock = UIImage(named: "msg_clock")?
                    .imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate);
            }
            return _iconClock!;
        }
    }
    
    static let TintColor = UIColor(red: 80/255.0, green: 133/255.0, blue: 204/255.0, alpha: 1.0);
    static let BarTintColor = TintColor;
    static let BarTintUnselectedColor = UIColor(red: 171/255.0, green: 182/255.0, blue: 202/255.0, alpha: 1);
}