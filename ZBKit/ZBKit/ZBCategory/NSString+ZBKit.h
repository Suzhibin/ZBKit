//
//  NSString+ZBKit.h
//  ZBKit
//
//  Created by NQ UEC on 17/4/13.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (ZBKit)

//uid
+ (NSString *)zb_stringWithUUID;

//字符串反转
+ (NSString*)zb_reverseWordsInString:(NSString*)string;

//获取汉字的拼音
+ (NSString *)zb_phoneticizeChinese:(NSString *)string;

//阿拉伯数字转中文
+ (NSString *)zb_translation:(NSString *)arebic;

//去掉所以空格
+ (NSString * )zb_str:(NSString *)string;

@end
