//
//  UIBarButtonItem+ZBKit.m
//  ZBKit
//
//  Created by NQ UEC on 2017/4/19.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "UIBarButtonItem+ZBKit.h"

@implementation UIBarButtonItem (ZBKit)
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    btn.bounds = (CGRect){CGPointZero, [btn backgroundImageForState:UIControlStateNormal].size};
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
