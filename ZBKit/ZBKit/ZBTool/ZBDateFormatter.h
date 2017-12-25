//
//  ZBDateFormatter.h
//  ZBKit
//
//  Created by NQ UEC on 2017/5/5.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBDateFormatter : NSObject
+ (ZBDateFormatter*)sharedInstance;
//是否为晚上
- (BOOL)isNight;
//当前时间
- (NSString *)currentDate;
//当前时间
- (NSString *)currentDateWithLocale:(NSLocale *)locale;
//时间转换
- (NSString *)stringDateWithTimeInterval:(NSString *)timeInterval;

//判断创建时间 格式
- (NSString *)created_ate:(NSString *)created_ate;

//一天剩余多少时间
- (NSTimeInterval)remainingTime;
@end
