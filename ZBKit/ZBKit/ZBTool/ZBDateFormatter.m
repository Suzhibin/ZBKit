
//
//  ZBDateFormatter.m
//  ZBKit
//
//  Created by NQ UEC on 2017/5/5.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ZBDateFormatter.h"
#import "NSDate+ZBKit.h"
#import "ZBLocalized.h"
static NSDateFormatter *formatter = nil;
@interface ZBDateFormatter ()
//@property (nonatomic,strong)NSDateFormatter *formatter;

@end
@implementation ZBDateFormatter

+ (ZBDateFormatter*)sharedInstance
{
    static ZBDateFormatter *formatter = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        formatter = [[self alloc] init];
    });
    return formatter;
}

- (BOOL)isNight{
    [self.formatter setDateFormat:@"HH"];
    NSString *str = [self.formatter stringFromDate:[NSDate date]];
    int time = [str doubleValue];
    if (time>=18||time<=06) {
        return YES;
    }else{
        return NO;
    }
}

- (NSString *)currentDate{
    NSDate *currentDate = [NSDate date];
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:[[ZBLocalized sharedInstance]currentLanguage]];
    [self.formatter setLocale:locale];
    [self.formatter setDateFormat:ZBLocalized(@"itemDateFormat",nil)];
    return [self.formatter stringFromDate:currentDate];
}

- (NSString *)stringDateWithTimeInterval:(NSString *)timeInterval
{
    NSTimeInterval seconds = [timeInterval doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    self.formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    return [self.formatter stringFromDate:date];
}

- (NSString *)created_ate:(NSString *)created_ate
{
    self.formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    // 设置日期格式（声明字符串里面每个数字和单词的含义）
    // E:星期几
    // M:月份
    // d:几号(这个月的第几天)
    // H:24小时制的小时
    // m:分钟
    // s:秒
    // y:年
    self.formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 微博的创建日期
    NSDate *createDate = [self.formatter dateFromString:created_ate];
    // 当前时间
    NSDate *now = [NSDate date];
    
    // 日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // NSCalendarUnit枚举代表想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 计算两个日期之间的差值
    NSDateComponents *cmps = [calendar components:unit fromDate:createDate toDate:now options:0];
    
    if ([createDate isThisYear]) { // 今年
        if ([createDate isYesterday]) { // 昨天
            self.formatter.dateFormat = @"昨天 HH:mm";
            return [self.formatter stringFromDate:createDate];
        } else if ([createDate isToday]) { // 今天
            if (cmps.hour >= 1) {
                return [NSString stringWithFormat:@"%d小时前", (int)cmps.hour];
            } else if (cmps.minute >= 1) {
                return [NSString stringWithFormat:@"%d分钟前", (int)cmps.minute];
            } else {
                return @"刚刚";
            }
        } else { // 今年的其他日子
            self.formatter.dateFormat = @"MM-dd HH:mm";
            return [self.formatter stringFromDate:createDate];
        }
    } else { // 非今年
        self.formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        return [self.formatter stringFromDate:createDate];
    }
}

- (NSTimeInterval)remainingTime{
    
    NSDate *date = [NSDate date];
    [self.formatter setDateFormat:@"HHmmss"];
    
    NSString *currentDateStr = [self.formatter stringFromDate:date];
    
    NSString *hour = [currentDateStr substringToIndex:2];
    NSRange rang = {2,2};
    NSString *min  = [currentDateStr substringWithRange:rang];
    NSString *sec = [currentDateStr substringFromIndex:4];
    
    int allSec = [hour intValue]*60*60+[min intValue]*60+[sec intValue];
    //NSLog(@"allSec==%d",allSec);
    
    int allDaySec = 24*60*60;
    int secs = allDaySec - allSec;
    //NSLog(@"secs :::%d",secs);
    return secs;
}

- (NSDateFormatter *)formatter{
    if (!formatter) {
        formatter=[[NSDateFormatter alloc]init];
    }
    return formatter;
}

@end
