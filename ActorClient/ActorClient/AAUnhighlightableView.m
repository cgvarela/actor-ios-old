//
//  UnhighlightableView.m
//  Actor
//
//  Created by Антон Буков on 27.10.14.
//  Copyright (c) 2015 Actor. All rights reserved.
//

#import "AAUnhighlightableView.h"

@implementation AAUnhighlightableView

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    if (self.backgroundColor == nil) {
        [super setBackgroundColor:backgroundColor];
    }
}

@end
