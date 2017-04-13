//
//  ZBControlTool.m
//  ZBKit
//
//  Created by NQ UEC on 17/2/6.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ZBControlTool.h"
#import "NSDate+ZBKit.h"

@implementation ZBControlTool


+ (NSString *)stringDateWithTimeInterval:(NSString *)timeInterval
{
    NSTimeInterval seconds = [timeInterval doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    return [format stringFromDate:date];
}

+ (NSString *)created_ate:(NSString *)created_ate
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    // 设置日期格式（声明字符串里面每个数字和单词的含义）
    // E:星期几
    // M:月份
    // d:几号(这个月的第几天)
    // H:24小时制的小时
    // m:分钟
    // s:秒
    // y:年
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 微博的创建日期
    NSDate *createDate = [fmt dateFromString:created_ate];
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
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:createDate];
        } else if ([createDate isToday]) { // 今天
            if (cmps.hour >= 1) {
                return [NSString stringWithFormat:@"%d小时前", (int)cmps.hour];
            } else if (cmps.minute >= 1) {
                return [NSString stringWithFormat:@"%d分钟前", (int)cmps.minute];
            } else {
                return @"刚刚";
            }
        } else { // 今年的其他日子
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:createDate];
        }
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:createDate];
    }
}

+ (NSMutableAttributedString *)AttributedString:(NSString *)string range:(NSUInteger)range lengthString:(NSString *)lengthString{
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:string];
    
    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:20.0]
                          range:NSMakeRange(range, [lengthString length])];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor redColor]
                          range:NSMakeRange(range, [lengthString length])];
    return  AttributedStr;
}

+ (CGFloat)textHeightWithString:(NSString *)text width:(CGFloat)width fontSize:(NSInteger)fontSize
{
    NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    // 根据第一个参数的文本内容，使用280*float最大值的大小，使用系统14号字，返回一个真实的frame size : (280*xxx)!!
    CGRect frame = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return frame.size.height +5;
}

+ (BOOL)checkIsChinese:(NSString *)string{
    for (int i=0; i<string.length; i++)
    {
        unichar ch = [string characterAtIndex:i];
        if (0x4E00 <= ch  && ch <= 0x9FA5)
        {
            return YES;
        }
    }
    return NO;
}


+ (void)timerDisabled{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

+ (void)setStatusBarBackgroundColor:(UIColor *)color{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)])
    {
        statusBar.backgroundColor = color;
    }
}

//============================================================
+ (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action tag:(NSInteger)tag{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    button.tag=tag;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text tag:(NSInteger)tag{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.tag=tag;
    label.textAlignment=NSTextAlignmentLeft;
    return label;
}

// imageName 是一个完整路径
+ (UIImageView *)createImageViewWithFrame:(CGRect)frame imageString:(NSString *)imageString{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:imageString];
    return imageView;
}

+ (UITextField *)createTextFieldWithFrame:(CGRect)frame placeHolder:(NSString *)placeHolder borderStyle:(UITextBorderStyle)borderStyle delegate:(id<UITextFieldDelegate>)delegate{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.borderStyle = borderStyle;
    textField.placeholder = placeHolder;
    textField.textAlignment = NSTextAlignmentLeft;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.delegate = delegate;
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.clearsOnBeginEditing = YES;
    return textField;
}


@end
