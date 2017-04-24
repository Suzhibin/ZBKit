//
//  ZBTabBar.m
//  ZBKit
//
//  Created by NQ UEC on 2017/4/20.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ZBTabBar.h"
#import "UIView+ZBKit.h"
@implementation ZBTabBar
- (nonnull instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIButton *publishButton = [[UIButton alloc] init];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        publishButton.bounds = (CGRect){CGPointZero, [publishButton backgroundImageForState:UIControlStateNormal].size};
        
      //  [publishButton addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
        publishButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:publishButton];
        self.publishButton=publishButton;
        NSLayoutConstraint *XConstraint = [NSLayoutConstraint constraintWithItem:publishButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0];
        //Y
        NSLayoutConstraint *YConstraint = [NSLayoutConstraint constraintWithItem:publishButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
        [self  addConstraint:XConstraint];
        [self  addConstraint:YConstraint];


    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 原来的4个
    CGFloat width = self.zb_width / 5;
    int index = 0;
    for (UIControl *control in self.subviews) {
        if (![control isKindOfClass:[UIControl class]] || [control isKindOfClass:[UIButton class]]) continue;
        control.zb_width = width;
        control.zb_x = index > 1 ? width * (index + 1) : width * index;
        index++;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
