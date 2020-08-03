//
//  UIView+Toast.m
//  ZBKit
//
//  Created by NQ UEC on 2018/5/24.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "UIView+Toast.h"
#import "ZBToastView.h"
@implementation UIView (Toast)
+ (void)makeText:(void (^)(ZBToastView *make))block{
    ZBToastView *toast=[[ZBToastView alloc]init];
    block(toast);
}
@end
