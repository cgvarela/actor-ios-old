//
//  AATextBubbleView.m
//  ActorClient
//
//  Created by Антон Буков on 04.03.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "AATextBubbleView.h"

@implementation AATextBubbleView

- (void)setText:(NSString *)text
{
    _text = text;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [self.text drawInRect:CGRectMake(20, 9, self.bounds.size.width-30, CGFLOAT_MAX) withAttributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]}];
}

@end
