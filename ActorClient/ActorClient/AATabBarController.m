//
//  AATabBarController.m
//  ActorClient
//
//  Created by Антон Буков on 25.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "ActorModel.h"
#import "AATabBarController.h"

@interface UITabBarItem (SelectedImageName)
@end
@implementation UITabBarItem (SelectedImageName)
- (void)setSelectedImageName:(NSString *)selectedImageName {
    self.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
}
@end


@interface AATabBarController ()

@end

@implementation AATabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *shadow = [UIImage imageNamed:@"CardTop3"];
    [[UITabBar appearance] setShadowImage:shadow];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![CocoaMessenger messenger].isLoggedIn) {
        UIViewController *controller = [[UIStoryboard storyboardWithName:@"Auth" bundle:nil] instantiateInitialViewController];
        [self presentViewController:controller animated:YES completion:nil];
    }
}

@end
