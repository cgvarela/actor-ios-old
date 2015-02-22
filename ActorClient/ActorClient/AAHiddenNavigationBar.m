//
//  SATallNavigationBar.m
//  Actor
//
//  Created by Антон Буков on 28.09.14.
//  Copyright (c) 2015 Actor. All rights reserved.
//

#import "AAHiddenNavigationBar.h"

@implementation AAHiddenNavigationBar

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        self.shadowImage = [[UIImage alloc] init];
        self.backgroundColor = [UIColor clearColor];
        self.barTintColor = [UIColor clearColor];
    });
}

@end
