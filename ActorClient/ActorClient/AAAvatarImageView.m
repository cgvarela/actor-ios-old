//
//  MyImageView.m
//  Actor
//
//  Created by Антон Буков on 07.10.14.
//  Copyright (c) 2015 Actor. All rights reserved.
//

#import "AAAvatarImageView.h"

@interface AAAvatarImageView ()

@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, assign) int64_t color_id;
@property (nonatomic, strong) NSString *title;

@end

@implementation AAAvatarImageView

+ (UIImage *)defaultImage:(CGSize)size
{
    static UIImage *img = nil;
    if (img == nil) {
        UIColor *color = [UIColor colorWithRed:190/255. green:183/255. blue:154/255. alpha:1.0];
        return [self imageWithColor:color color2:color letters:nil size:CGSizeMake(20,20)];
    }
    return img;
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    self.layer.cornerRadius = MIN(bounds.size.width,bounds.size.height)/2;
    self.layer.masksToBounds = YES;
    if (self.image == nil)
        [self setImageData:self.imageData colorId:self.color_id title:self.title];
}

- (void)setImageData:(NSData *)imageData
             colorId:(int64_t)color_id
               title:(NSString *)title
{
    if (([imageData isEqualToData:self.imageData] || imageData == nil) &&
        ([title isEqualToString:self.title] || title == nil) &&
        (color_id == self.color_id || color_id == 0))
    {
        return;
    }
    self.imageData = imageData;
    self.color_id = color_id;
    self.title = title;
    
    self.image = [AAAvatarImageView imageWithData:imageData colorId:color_id title:title size:self.bounds.size];
}

+ (UIImage *)imageWithData:(NSData *)data
                   colorId:(int64_t)color_id
                     title:(NSString *)title
                      size:(CGSize)size
{
    if (data) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width*2,size.height*2), NO, [UIScreen mainScreen].scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextAddPath(context, CGPathCreateWithEllipseInRect((CGRect){CGPointZero,size}, NULL));
        CGContextClip(context);
        CGContextSetAllowsAntialiasing(context, true);
        [[UIImage imageWithData:data] drawInRect:(CGRect){CGPointZero,size}];
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img;
    }
    if (color_id == 0)
        return [AAAvatarImageView defaultImage:size];
    
    #define UIColorFromRGB(rgbValue) \
            [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                            green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
                             blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
                            alpha:1.0]
    
    NSArray *colors = @[// TOP                   // BOTTOM
                        UIColorFromRGB(0x2a9ef1),UIColorFromRGB(0x72d5fd),
                        UIColorFromRGB(0x6c65f9),UIColorFromRGB(0x84b2fd),
                        UIColorFromRGB(0xd575ea),UIColorFromRGB(0xe0a8f1),
                        UIColorFromRGB(0xff516a),UIColorFromRGB(0xff885e),
                        UIColorFromRGB(0xffa85c),UIColorFromRGB(0xffcd6a),
                        UIColorFromRGB(0x2a9ef1),UIColorFromRGB(0x72d5fd),
                        UIColorFromRGB(0x54cb68),UIColorFromRGB(0xa0de7e),
                        ];
    
    #undef UIColorFromRGB
    
    NSInteger colorIndex = color_id % (colors.count/2);
    UIColor *color = colors[colorIndex*2];
    UIColor *color2 = colors[colorIndex*2+1];
    
    NSMutableString *text = [NSMutableString string];
    for (NSString *word in [title componentsSeparatedByString:@" "]) {
        if (word.length >= 1)
            [text appendString:[word substringToIndex:1]];
    }
    NSString *letters = [[text substringToIndex:MIN(text.length,1)] uppercaseString];
    
    return [AAAvatarImageView imageWithColor:color color2:color2 letters:letters size:size];
}

+ (UIImage *)imageWithColor:(UIColor *)color color2:(UIColor *)color2 letters:(NSString *)letters size:(CGSize)size
{
    size.width *= 2;
    size.height *= 2;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, CGPathCreateWithEllipseInRect((CGRect){CGPointZero,size}, NULL));
    CGContextClip(context);
    NSArray *colors = @[(id)color.CGColor, (id)color2.CGColor];
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(baseSpace, (CFArrayRef)colors, NULL);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0,0), CGPointMake(0,size.height), 0);
    CGColorSpaceRelease(baseSpace);
    CGGradientRelease(gradient);
    
    [[UIColor whiteColor] set];
    UIFont *font = [UIFont systemFontOfSize:size.width/2];
    CGRect rect = (CGRect){CGPointZero,size};
    rect.origin.y = size.height*47/100 - font.pointSize/2;

    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    
    style.lineBreakMode = NSLineBreakByClipping;
    [letters drawInRect:rect withAttributes:@{NSParagraphStyleAttributeName:style,
                                              NSFontAttributeName:font,
                                              NSForegroundColorAttributeName:[UIColor whiteColor]
                                              }];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
