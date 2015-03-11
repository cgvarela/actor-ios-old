//
//  AADialogTableViewCell.h
//  ActorClient
//
//  Created by Stepan Korshakov on 05.03.15.
//  Copyright (c) 2015 Actor LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActorModel.h"
#import "AAAvatarImageView.h"

@interface AADialogCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *titleView;
@property (nonatomic, strong) UILabel *messageView;
@property (nonatomic, strong) UILabel *dateView;
@property (nonatomic, strong) UIImageView *statusView;
@property (nonatomic, strong) UIView *separatorView;

- (void)bindDialog:(AMDialog *)dialog withLast:(BOOL)isLast;

@end
