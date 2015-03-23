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
        
        centerButton = UIButton(frame: CGRect(x: 0, y: 0, width: 66, height: 58));
        centerButton!.setBackgroundImage(UIImage(named: "ic_round_button_red"), forState: UIControlState.Normal);
        centerButton!.setImage(UIImage(named: "ic_add_white_24"), forState: UIControlState.Normal);
        centerButton!.imageEdgeInsets = UIEdgeInsetsMake(4, 0, -4, 0);
        centerButton!.addTarget(self, action: "centerButtonTap", forControlEvents: UIControlEvents.TouchUpInside)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        self.view.addSubview(centerButton!);
    }
    
    func centerButtonTap() {
//        var actionShit = ABActionShit()
//        actionShit.buttonTitles = ["Add Contact", "Create group", "Write to..."];
//        actionShit.showWithCompletion(nil)
        navigationController?.pushViewController(GroupMembersController(), animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
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
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self.viewControllers![0], action: "addContact")
            navigationController?.navigationBar.shadowImage = UIImage(named: "CardBottom3")
            break;
        case 1:
            navigationItem.title = "Chats";
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "editDialogs");
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: nil, action: nil)
            navigationController?.navigationBar.shadowImage = UIImage(named: "CardBottom3")
            break;
        case 3:
            navigationItem.leftBarButtonItem = nil;
            navigationItem.rightBarButtonItem = nil;
            navigationItem.title = "Discover";
            navigationController?.navigationBar.shadowImage = UIImage(named: "CardBottom3")
            break;
        case 4:
            navigationItem.title = "You";
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "editDialogs");
            navigationItem.rightBarButtonItem = nil;
//            navigationController?.navigationBar.shadowImage = UIImage()
            break;
        default:
            navigationItem.leftBarButtonItem = nil;
            navigationItem.rightBarButtonItem = nil;
            navigationItem.title = "";
            navigationController?.navigationBar.shadowImage = UIImage(named: "CardBottom3")
            break;
        }
    }
    
    func editDialogs(){
        (self.viewControllers![1] as! DialogsViewController).toggleEdit();
    }
}