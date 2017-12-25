//
//  UIColor+ZBKit.h
//  ZBKit
//
//  Created by NQ UEC on 17/3/31.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ZBKit)
//十六进制颜色值
+ (UIColor *)zb_colorFromHexString:(NSString *)hexString;
//随机颜色
+ (UIColor *)zb_randomColor;
//颜色取反
- (UIColor *)zb_inverseColor;

@end
