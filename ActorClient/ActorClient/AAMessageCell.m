//
//  AAMessageCell.m
//  ActorClient
//
//  Created by Антон Буков on 06.03.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "AAMessageCell.h"

@implementation AAMessageCell

- (AABubbleView *)bubbleView
{
    if (_bubbleView == nil) {
        _bubbleView = [[[AABubbleFactory bubbleClassForContentType:self.reuseIdentifier] alloc] init];
        _bubbleView.frame = CGRectInset(self.contentView.bounds,2,2);
        _bubbleView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return _bubbleView;
}

- (void)awakeFromNib
{
    [self.contentView addSubview:self.bubbleView];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - Methods

- (void)bindMessage:(AMMessage *)message isMyMessage:(BOOL)isMyMessage
{
    [self.bubbleView bindMessage:message isMyMessage:isMyMessage];
}

@end
