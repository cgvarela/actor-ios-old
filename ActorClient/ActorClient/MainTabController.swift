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
    var isInited = false;
    
    required init(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    init(){
        super.init(nibName: nil, bundle: nil);
        initControllers()
    }
    
    func initControllers() {
        
        tabBar.translucent = false;
        tabBar.backgroundColor = UIColor.whiteColor();
        tabBar.shadowImage = UIImage();
        
        centerButton = UIButton(frame: CGRect(x: 0, y: 0, width: 66, height: 58));
        centerButton!.setBackgroundImage(UIImage(named: "ic_round_button_red"), forState: UIControlState.Normal);
        centerButton!.setImage(UIImage(named: "ic_add_white_24"), forState: UIControlState.Normal);
        centerButton!.imageEdgeInsets = UIEdgeInsetsMake(4, 0, -4, 0);
        
        self.view.addSubview(centerButton!);
    }
    
    override func viewWillAppear(animated: Bool) {
        if (!isInited) {
            if (MSG.isLoggedIn()) {
                isInited = true
                
                viewControllers = [ContactsViewController(),
                                   DialogsViewController(),
                                   PlaceHolderController(),
                                   DiscoverViewController(),
                                   SettingsViewController()];
        
                selectedIndex = 1;
                applyTitle(1);
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        centerButton!.frame = CGRectMake(view.center.x-31, view.frame.height-58, 66, 58)
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        var item = (tabBar.items! as NSArray).indexOfObject(item);
        applyTitle(item);
    }
    
    func applyTitle(item: Int){
        switch(item){
        case 0:
            navigationItem.title = "People";
            navigationItem.leftBarButtonItem = nil;
            break;
        case 1:
            navigationItem.title = "Chats";
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "editDialogs");
            break;
        case 2:
            navigationItem.leftBarButtonItem = nil;
            navigationItem.title = "";
            break;
        case 3:
            navigationItem.leftBarButtonItem = nil;
            navigationItem.title = "Discover";
            break;
        case 4:
            navigationItem.leftBarButtonItem = nil;
            navigationItem.title = "You";
            break;
        default:
            navigationItem.leftBarButtonItem = nil;
            navigationItem.title = "";
            break;
        }
    }
    
    func editDialogs(){
        (self.viewControllers![1] as! DialogsViewController).toggleEdit();
    }
}