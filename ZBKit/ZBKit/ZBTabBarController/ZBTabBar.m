//
//  ZBTabBar.m
//  ZBKit
//
//  Created by NQ UEC on 2017/4/20.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ZBTabBar.h"
#import "UIView+ZBKit.h"
#import "ZBMacros.h"
@implementation ZBTabBar
- (nonnull instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        //添加阴影
        self.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        self.layer.shadowOpacity = 0.4;//阴影透明度，默认0
        self.layer.shadowOffset = CGSizeMake(0,0);
        self.layer.shadowRadius = 4;//阴影半径，默认3
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        [path moveToPoint:CGPointMake(0, -2)];
        [path addLineToPoint:CGPointMake(ZB_SCREEN_WIDTH, -2)];
        [path addLineToPoint:CGPointMake(ZB_SCREEN_WIDTH, 1)];
        [path addLineToPoint:CGPointMake(0, 1)];
        [path addLineToPoint:CGPointMake(0, -2)];
        self.layer.shadowPath = path.CGPath;

    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    NSInteger index = 0;
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            v.tag = 900+index;
            index++;
        }
    }
}

- (void)setFrame:(CGRect)frame {
    if (ZB_DEVICE_IS_iPhoneX) {
        if (frame.origin.y < ([UIScreen mainScreen].bounds.size.height - 83)) {
            frame.origin.y = [UIScreen mainScreen].bounds.size.height - 83;
        }
    }
    [super setFrame: frame];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
