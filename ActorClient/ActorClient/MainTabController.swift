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
    
    init(){
        super.init(nibName: nil, bundle: nil);
        initControllers()
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
        
//        selectedIndex = 0;
        selectedIndex = 1;
        applyTitle(0);
        
        centerButton = UIButton(frame: CGRect(x: 0, y: 0, width: 66, height: 58));
        centerButton!.setBackgroundImage(UIImage(named: "ic_round_button_red"), forState: UIControlState.Normal);
        centerButton!.setImage(UIImage(named: "ic_add_white_24"), forState: UIControlState.Normal);
        centerButton!.imageEdgeInsets = UIEdgeInsetsMake(4, 0, -4, 0);
//         centerButton!.frame = CGRect(x: tabBar.center.x - 31, y: tabBar.frame.height - 58, width: 66, height: 58);
        
        self.view.addSubview(centerButton!);
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
            navigationItem.title = "Contacts";
            navigationItem.leftBarButtonItem = nil;
            navigationController?.setNavigationBarHidden(false, animated: false)
            break;
        case 1:
            navigationItem.title = "Chats";
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "editDialogs");
            navigationController?.setNavigationBarHidden(false, animated: false)
            break;
        case 2:
            navigationItem.leftBarButtonItem = nil;
            navigationItem.title = "";
            navigationController?.setNavigationBarHidden(false, animated: false)
            break;
        case 3:
            navigationItem.leftBarButtonItem = nil;
            navigationItem.title = "Discover";
            navigationController?.setNavigationBarHidden(false, animated: false)
            break;
        case 4:
            navigationItem.leftBarButtonItem = nil;
            navigationItem.title = "";
            navigationController?.setNavigationBarHidden(true, animated: false)
            break;
        default:
            navigationItem.leftBarButtonItem = nil;
            navigationItem.title = "";
            navigationController?.setNavigationBarHidden(false, animated: false)
            break;
        }
    }
    
    func editDialogs(){
        (self.viewControllers![1] as! DialogsViewController).toggleEdit();
    }
}