//
//  ZBControlTool.h
//  ZBKit
//
//  Created by NQ UEC on 17/2/6.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ZBControlTool : NSObject

//字符串高亮
+ (NSMutableAttributedString *)AttributedString:(NSString *)string range:(NSUInteger)range lengthString:(NSString *)lengthString;

//根据内容 获取动态行高
+ (CGFloat)textHeightWithString:(NSString *)text width:(CGFloat)width fontSize:(NSInteger)fontSize;

//字符串是否含有中文
+ (BOOL)checkIsChinese:(NSString *)string;

//禁止锁屏，
+ (void)timerDisabled;

//改变状态栏背景颜色
+ (void)setStatusBarBackgroundColor:(UIColor *)color;


@end
