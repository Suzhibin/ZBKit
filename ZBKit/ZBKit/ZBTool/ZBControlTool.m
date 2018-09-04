//
//  ZBControlTool.m
//  ZBKit
//
//  Created by NQ UEC on 17/2/6.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ZBControlTool.h"



@implementation ZBControlTool


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



@end
