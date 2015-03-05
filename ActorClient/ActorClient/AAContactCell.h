//
//  AAContactCell.h
//  ActorClient
//
//  Created by Антон Буков on 06.03.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActorModel.h"
#import "AAAvatarImageView.h"

@interface AAContactCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameView;
@property (nonatomic, strong) UIView *separatorView;

- (void)bindContact:(AMContact *)contact withLast:(BOOL)isLast;

@end
