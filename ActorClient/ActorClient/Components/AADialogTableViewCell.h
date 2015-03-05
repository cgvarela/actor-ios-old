//
//  AADialogTableViewCell.h
//  ActorClient
//
//  Created by Stepan Korshakov on 05.03.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActorModel.h"
#import "AAAvatarImageView.h"
@interface AADialogTableViewCell : UITableViewCell
    @property (nonatomic, strong) AAAvatarImageView* avatarView;
    @property (nonatomic, strong) UILabel* titleView;
    @property (nonatomic, strong) UILabel* messageView;
    @property (nonatomic, strong) UILabel* dateView;
    @property (nonatomic, strong) UIImageView* statusView;
    @property (nonatomic, strong) UIView* separator;

    - (void)bindDialog:(AMDialog*)dialog withLast:(BOOL)isLast;

@end
