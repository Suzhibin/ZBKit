//
//  UIBarButtonItem+ZBKit.h
//  ZBKit
//
//  Created by NQ UEC on 2017/4/19.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (ZBKit)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

@end
