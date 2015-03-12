//
//  MainTabController.swift
//  ActorClient
//
//  Created by Stepan Korshakov on 10.03.15.
//  Copyright (c) 2015 Actor LLC. All rights reserved.
//

import Foundation
import UIKit

class MainTabController : UITabBarController, UITabBarDelegate {

    var centerButton:UIButton? = nil;
    
    required init(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
        initControllers();
    }
    
    override init(){
        super.init();
    }
    
    func initControllers() {
        addChildViewController(ContactsViewController());
        addChildViewController(DialogsViewController());
        addChildViewController(PlaceHolderController());
        addChildViewController(DiscoverViewController());
        addChildViewController(SettingsViewController());
        
        tabBar.translucent = false;
        tabBar.backgroundColor = UIColor.whiteColor();
        tabBar.shadowImage = UIImage();
        
        // Stupid hack: Drawing border for removing standart border
//        self.tabBar.layer.borderWidth = 0.50;
//        self.tabBar.layer.borderColor = UIColor.whiteColor().CGColor;//self.tabBar.tintColor.CGColor;
//         tabBar.shadowImage=nil;
        
        
//         tabBar.shadowImage = UIImage(named: "CardTop3");
        
        selectedIndex = 1;
        applyTitle(1);
        
        centerButton = UIButton(frame: CGRect(x: 0, y: 0, width: 66, height: 58));
        centerButton!.setBackgroundImage(UIImage(named: "ic_round_button_red"), forState: UIControlState.Normal);
        centerButton!.setImage(UIImage(named: "ic_add_white_24"), forState: UIControlState.Normal);
        centerButton!.imageEdgeInsets = UIEdgeInsetsMake(4, 0, -4, 0);
        centerButton!.frame = CGRect(x: tabBar.center.x-31, y: tabBar.frame.maxY-58, width: 66, height: 58);
//        centerButton!.center = tabBar.center;
        self.view.addSubview(centerButton!);
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        var item = (tabBar.items! as NSArray).indexOfObject(item);
        applyTitle(item);
    }
    
    func applyTitle(item: Int){
        switch(item){
        case 0:
            navigationItem.title = "Contacts";
            break;
        case 1:
            navigationItem.title = "Dialogs";
            break;
        case 2:
            navigationItem.title = "";
            break;
        case 3:
            navigationItem.title = "Discover";
            break;
        case 4:
            navigationItem.title = "";
            break;
        default:
            navigationItem.title = "";
            break;
        }
    }
}