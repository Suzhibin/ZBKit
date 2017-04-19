//
//  UIView+ZBKit.m
//  ZBKit
//
//  Created by NQ UEC on 17/4/13.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "UIView+ZBKit.h"

@implementation UIView (ZBKit)
- (void)setZb_x:(CGFloat)zb_x
{
    CGRect frame = self.frame;
    frame.origin.x = zb_x;
    self.frame = frame;
}

- (void)setZb_y:(CGFloat)zb_y
{
    CGRect frame = self.frame;
    frame.origin.y = zb_y;
    self.frame = frame;
}

- (CGFloat)zb_x
{
    return self.frame.origin.x;
}

- (CGFloat)zb_y
{
    return self.frame.origin.y;
}

- (void)setZb_width:(CGFloat)zb_width
{
    CGRect frame = self.frame;
    frame.size.width = zb_width;
    self.frame = frame;
}

- (void)setZb_height:(CGFloat)zb_height
{
    CGRect frame = self.frame;
    frame.size.height = zb_height;
    self.frame = frame;
}

- (CGFloat)zb_width
{
    return self.frame.size.width;
}

- (CGFloat)zb_height
{
    return self.frame.size.height;
}

- (void)setZb_centerX:(CGFloat)zb_centerX
{
    CGPoint center = self.center;
    center.x = zb_centerX;
    self.center = center;
}

- (void)setZb_centerY:(CGFloat)zb_centerY
{
    CGPoint center = self.center;
    center.y = zb_centerY;
    self.center = center;
}

- (CGFloat)zb_centerX
{
    return self.center.x;
}

- (CGFloat)zb_centerY
{
    return self.center.y;
}

@end
