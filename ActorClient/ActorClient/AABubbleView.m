//
//  AABubbleView.m
//  ActorClient
//
//  Created by Антон Буков on 04.03.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "AABubbleView.h"

@implementation AABubbleView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setBubbleImage:(UIImage *)bubbleImage
{
    _bubbleImage = bubbleImage;
    [self setNeedsDisplay];
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    [self setNeedsDisplay];
}

- (void)setSent:(BOOL)sent
{
    _sent = sent;
    [self setNeedsDisplay];
}

- (void)setDelivered:(BOOL)delivered
{
    _delivered = delivered;
    [self setNeedsDisplay];
}

- (void)setRead:(BOOL)read
{
    _read = read;
    [self setNeedsDisplay];
}

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"HH:mm";
    });
    return formatter;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.bubbleImage drawInRect:self.bounds];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentRight];
    NSString *dateStr = [[self dateFormatter] stringFromDate:self.date];
    [dateStr drawInRect:CGRectMake(0,self.bounds.size.height-20,self.bounds.size.width-20, 20) withAttributes:@{NSParagraphStyleAttributeName:style}];
    
    
}

@end
