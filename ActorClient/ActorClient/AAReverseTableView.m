//
//  SAInverseTableView.m
//  Actor
//
//  Created by Антон Буков on 10.10.14.
//  Copyright (c) 2015 Actor. All rights reserved.
//

#import "AAReverseTableView.h"

void swapCGFLoat(CGFloat *a, CGFloat *b) {
    CGFloat tmp = *a;
    *a = *b;
    *b = tmp;
}

@implementation AAReverseTableView

- (UIEdgeInsets)contentInset {
    UIEdgeInsets insets = [super contentInset];
    swapCGFLoat(&insets.top, &insets.bottom);
    return insets;
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    swapCGFLoat(&contentInset.top, &contentInset.bottom);
    [super setContentInset:contentInset];
}

- (UIEdgeInsets)scrollIndicatorInsets {
    UIEdgeInsets insets = [super scrollIndicatorInsets];
    swapCGFLoat(&insets.top, &insets.bottom);
    return insets;
}

- (void)setScrollIndicatorInsets:(UIEdgeInsets)scrollIndicatorInsets {
    swapCGFLoat(&scrollIndicatorInsets.top, &scrollIndicatorInsets.bottom);
    [super setScrollIndicatorInsets:scrollIndicatorInsets];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

@end
