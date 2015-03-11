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
        selectedIndex = 1;
        // TODO: Fix
        navigationItem.title = "Chats";
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        navigationItem.title = item.title;
    }
}