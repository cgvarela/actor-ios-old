//
//  MyImageView.h
//  Actor
//
//  Created by Антон Буков on 07.10.14.
//  Copyright (c) 2015 Actor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCBlurredImageView.h"

@interface AAAvatarImageView : UIImageView

@property (nonatomic, readonly) NSData *imageData;
@property (nonatomic, readonly) int64_t color_id;
@property (nonatomic, readonly) NSString *title;
- (void)setImageData:(NSData *)imageData colorId:(int64_t)color_id title:(NSString *)title;

+ (UIImage *)imageWithData:(NSData *)data colorId:(int64_t)color_id title:(NSString *)title size:(CGSize)size;

@end
