//
//  AppDelegate.m
//  ActorClient
//
//  Created by Антон Буков on 19.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import <HockeySDK/HockeySDK.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "CocoaMessenger.h"
#import "AppDelegate.h"
#import "AATabBarController.h"
#import "AADialogsViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UINavigationBar appearance].barTintColor = BAR_COLOR;
    [UINavigationBar appearance].backgroundColor = BAR_COLOR;
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [UITextField appearance].tintColor = BAR_COLOR;
    [UISearchBar appearance].tintColor = BAR_COLOR;
    //[UISearchBar appearance].backgroundImage = [UIImage new];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class],nil]
     setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    [UITableViewCell appearance].tintColor = BAR_COLOR;
    [UITableView appearance].sectionIndexColor = BAR_COLOR;
    [UITabBar appearance].tintColor = BAR_COLOR;
    
    [MagicalRecord setupAutoMigratingCoreDataStack];

    [CocoaMessenger messenger];

    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"f4ffe94973085058c00c3985de4b97e5"]; // Alpha
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
    
    // Init View
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UITabBarController *rootController = [[UITabBarController alloc] init];

    UINavigationController *contactsController = [[UINavigationController alloc] init];
    contactsController.tabBarItem.title=@"Contacts";
    contactsController.tabBarItem.image=[UIImage imageNamed:@"TabIconContacts"];
    contactsController.tabBarItem.selectedImage=[UIImage imageNamed:@"TabIconContactsHighlighted"];

    // AAChatsViewController *dialogsController = [[AAChatsViewController alloc] init];
    AADialogsViewController *dialogsController = [[AADialogsViewController alloc] init];
    
    UINavigationController *chatsController = [[UINavigationController alloc]
                                               initWithRootViewController:dialogsController];
    chatsController.tabBarItem.title = @"Chats";
    chatsController.tabBarItem.image = [UIImage imageNamed:@"TabIconChats"];
    chatsController.tabBarItem.selectedImage = [UIImage imageNamed:@"TabIconChatsHighlighted"];

    UINavigationController *settingsController = [[UINavigationController alloc] init];
    settingsController.tabBarItem.title = @"Settings";
    settingsController.tabBarItem.image = [UIImage imageNamed:@"TabIconSettings"];
    settingsController.tabBarItem.selectedImage = [UIImage imageNamed:@"TabIconSettingsHighlighted"];

    [rootController addChildViewController:contactsController];
    [rootController addChildViewController:chatsController];
    [rootController addChildViewController:settingsController];
    [rootController setSelectedIndex:1];
    
    // AATabBarController *barController = [[AATabBarController alloc] init];
    
    // self.window.rootViewController = barController;
    
    // AAChatsViewController *chatsController = [[AAChatsViewController alloc] init];
    
    // [barController addChildViewController:chatsController];
    
    self.window.rootViewController = rootController;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[CocoaMessenger messenger] onAppHidden];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

    [[CocoaMessenger messenger] onAppVisible];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
