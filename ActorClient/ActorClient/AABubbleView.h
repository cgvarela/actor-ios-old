//
//  AABubbleView.h
//  ActorClient
//
//  Created by Антон Буков on 04.03.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AABubbleView : UIView

@property (nonatomic, strong) UIImage *bubbleImage;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign, getter=isSent) BOOL sent;
@property (nonatomic, assign, getter=isDelivered) BOOL delivered;
@property (nonatomic, assign, getter=isRead) BOOL read;

@end
