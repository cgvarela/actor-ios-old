//
//  AAContactCell.m
//  ActorClient
//
//  Created by Антон Буков on 06.03.15.
//  Copyright (c) 2015 Actor LLC. All rights reserved.
//

#import "AAContactCell.h"

@implementation AAContactCell

#pragma mark - Subviews

- (UIImageView *)avatarView
{
    if (_avatarView == nil) {
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 4, 40, 40)];
    }
    return _avatarView;
}

- (UILabel *)nameView
{
    if (_nameView == nil) {
        _nameView = [[UILabel alloc] initWithFrame:CGRectMake(65, 10, 247, 28)];
        _nameView.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    }
    return _nameView;
}

- (UIView *)separatorView
{
    if (_separatorView == nil) {
        _separatorView = [[UIView alloc] initWithFrame:CGRectMake(65, 47.5, 320-65, 0.5)];
        _separatorView.backgroundColor = [UIColor colorWithRed:165/255. green:165/255. blue:165/255. alpha:1];
    }
    return _separatorView;
}

- (void)awakeFromNib
{
    [self.contentView addSubview:self.avatarView];
    [self.contentView addSubview:self.nameView];
    [self.contentView addSubview:self.separatorView];
}

#pragma mark - Methods

- (void)bindContact:(AMContact *)contact withLast:(BOOL)isLast;
{
    // Contact info
    
    self.avatarView.image = [AAAvatarImageView imageWithData:nil colorId:contact.getUid title:contact.getName size:CGSizeMake(40, 40)];
    
    self.nameView.text = contact.getName;
    
    self.separatorView.hidden = isLast;
}

@end
