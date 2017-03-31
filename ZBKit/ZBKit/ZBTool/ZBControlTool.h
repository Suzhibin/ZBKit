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
//根据内容 获取动态行高
+ (CGFloat)textHeightWithString:(NSString *)text width:(CGFloat)width fontSize:(NSInteger)fontSize;

//时间转换
+ (NSString *)stringDateWithTimeInterval:(NSString *)timeInterval;

//字符串是否含有中文
+ (BOOL)checkIsChinese:(NSString *)string;

//字符串高亮
+ (NSMutableAttributedString *)AttributedString:(NSString *)string range:(NSUInteger)range lengthString:(NSString *)lengthString;

//字符串反转
+ (NSString*)reverseWordsInString:(NSString*)string;

//获取汉字的拼音
+ (NSString *)phoneticizeChinese:(NSString *)string;

//阿拉伯数字转中文
+ (NSString *)translation:(NSString *)arebic;

//禁止锁屏，
+ (void)timerDisabled;

//改变状态栏颜色
+ (void)setStatusBarBackgroundColor:(UIColor *)color;

+ (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action tag:(NSInteger)tag;

+ (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text tag:(NSInteger)tag;

+ (UIImageView *)createImageViewWithFrame:(CGRect)frame imageString:(NSString *)imageString;

+ (UITextField *)createTextFieldWithFrame:(CGRect)frame placeHolder:(NSString *)placeHolder borderStyle:(UITextBorderStyle)borderStyle delegate:(id<UITextFieldDelegate>)delegat;


@end
