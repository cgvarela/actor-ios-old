//
//  AAMessageCell.h
//  ActorClient
//
//  Created by Антон Буков on 06.03.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActorModel.h"
#import "AABubbleFactory.h"
#import "AAAvatarImageView.h"

@interface AAMessageCell : UITableViewCell

@property (nonatomic, strong) AABubbleView *bubbleView;

- (void)bindMessage:(AMMessage *)message isMyMessage:(BOOL)isMyMessage;

@end
