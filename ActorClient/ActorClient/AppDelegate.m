//
//  AppDelegate.m
//  ActorClient
//
//  Created by Антон Буков on 19.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import <HockeySDK/HockeySDK.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "AppDelegate.h"
#import "AAContactsViewController.h"
#import "AADialogsViewController.h"
#import "ActorClient-Swift.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
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
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController addChildViewController:^{
        UINavigationController *contactsController = [[UINavigationController alloc] initWithRootViewController:[[AAContactsViewController alloc] init]];
        contactsController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Contacts" image:[UIImage imageNamed:@"TabIconContacts"] selectedImage:[UIImage imageNamed:@"TabIconContactsHighlighted"]];
        return contactsController;
    }()];
    [tabBarController addChildViewController:^{
        UINavigationController *chatsController = [[UINavigationController alloc] initWithRootViewController:[[AADialogsViewController alloc] init]];
        chatsController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Chats" image:[UIImage imageNamed:@"TabIconChats"] selectedImage:[UIImage imageNamed:@"TabIconChatsHighlighted"]];
        return chatsController;
    }()];
    [tabBarController addChildViewController:^{
        UINavigationController *settingsController = [[UINavigationController alloc] init];
        settingsController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:[UIImage imageNamed:@"TabIconSettings"] selectedImage:[UIImage imageNamed:@"TabIconSettingsHighlighted"]];
        return settingsController;
    }()];
    tabBarController.selectedIndex = 1;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];

    if (![CocoaMessenger messenger].isLoggedIn) {
        UIViewController *controller = [[UIStoryboard storyboardWithName:@"Auth" bundle:nil] instantiateInitialViewController];
        [tabBarController presentViewController:controller animated:YES completion:nil];
    }
    
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
