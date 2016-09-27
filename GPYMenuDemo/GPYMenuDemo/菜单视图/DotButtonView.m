//
//  DotButtonView.m
//  BeautyMall
//
//  Created by mac on 15/12/8.
//  Copyright (c) 2015年 GPY. All rights reserved.
//

#import "DotButtonView.h"

@implementation DotButtonView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect{
    CGFloat width=rect.size.width-rect.size.height;
    CGFloat radius=rect.size.height/2;
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGFloat lengths[]={2,5};
    CGContextSetLineDash(context, 0, lengths, 2);
    
    CGContextMoveToPoint(context, radius, 0);
    CGContextAddLineToPoint(context, width+radius, 0);
    CGContextAddArc(context, width+radius, radius, radius, 3*M_PI_2, M_PI_2, 0);
    CGContextAddLineToPoint(context, radius, rect.size.height);
    CGContextAddArc(context, radius, radius, radius, M_PI_2, 3*M_PI_2, 0);
    
    CGContextStrokePath(context);
}
@end
