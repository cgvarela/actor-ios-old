//
//  AppDelegate.swift
//  ActorClient
//
//  Created by Stepan Korshakov on 10.03.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

import Foundation

@objc class AppDelegate : UIResponder,  UIApplicationDelegate {
    
    private let TintColor = UIColor(red: 80/255.0, green: 133/255.0, blue: 204/255.0, alpha: 1.0);
    
    private var window : UIWindow?;
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        var navAppearance = UINavigationBar.appearance();
        navAppearance.tintColor = UIColor.whiteColor();
        navAppearance.barTintColor = TintColor;
        navAppearance.backgroundColor = TintColor;
        navAppearance.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()];
        
        var textFieldAppearance = UITextField.appearance();
        textFieldAppearance.tintColor = TintColor;
        
        var searchBarAppearance = UISearchBar.appearance();
        searchBarAppearance.tintColor = TintColor;
        
//        setTitleTextAttributes(NSForegroundColorAttributeName, );
        
//        var barButtonItemAppearance = UIBarButtonItem.appearance();
//        barButtonItemAppearance
        
//        [UINavigationBar appearance].tintColor = [UIColor whiteColor];
//        [UINavigationBar appearance].barTintColor = BAR_COLOR;
//        [UINavigationBar appearance].backgroundColor = BAR_COLOR;
//        [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
//        [UITextField appearance].tintColor = BAR_COLOR;
//        [UISearchBar appearance].tintColor = BAR_COLOR;
//        //[UISearchBar appearance].backgroundImage = [UIImage new];
//        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class],nil]
//        setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
//        
//        [UITableViewCell appearance].tintColor = BAR_COLOR;
//        [UITableView appearance].sectionIndexColor = BAR_COLOR;
//        [UITabBar appearance].tintColor = BAR_COLOR;
//        
//        [MagicalRecord setupAutoMigratingCoreDataStack];
//        
//        [CocoaMessenger messenger];
        
        MagicalRecord.setupAutoMigratingCoreDataStack();
    

        // Starting app
        

        var rootController = UINavigationController(rootViewController: MainTabController());
    
        window = UIWindow(frame: UIScreen.mainScreen().bounds);
        window?.rootViewController = rootController;
        window?.makeKeyAndVisible();
        
        if (!MSG.isLoggedIn()){
            var controller = UIStoryboard(name: "Auth", bundle: nil).instantiateInitialViewController() as! UIViewController;
            rootController.presentViewController(controller, animated: false, completion: nil)
        }
        
        return true;
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        MSG.onAppVisible();
    }

    func applicationDidEnterBackground(application: UIApplication) {
        MSG.onAppHidden();
    }
}