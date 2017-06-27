//
//  UIViewController+ZBAnalytics.m
//  ZBKit
//
//  Created by NQ UEC on 17/3/1.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "UIViewController+ZBAnalytics.h"

#import "ZBConstants.h"
#import <objc/runtime.h>
@implementation UIViewController (ZBAnalytics)
+ (void)load {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethod = class_getInstanceMethod([self class], @selector(viewDidAppear:));
        Method swizzledMethod = class_getInstanceMethod([self class], @selector(zb_viewDidAppear:));
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
        
        Method originalMethod2 = class_getInstanceMethod([self class], @selector(viewDidDisappear:));
        Method swizzledMethod2 = class_getInstanceMethod([self class], @selector(zb_viewDidDisappear:));
        
        method_exchangeImplementations(originalMethod2, swizzledMethod2);
    });
}

#pragma mark - Method
- (void)zb_viewDidAppear:(BOOL)animated {
    [self zb_viewDidAppear:animated];
    
    NSString *class=[NSString stringWithFormat:@"进入:%@",NSStringFromClass([self class])];
    NSLog(@"%@",class);
    
}

- (void)zb_viewDidDisappear:(BOOL)animated {
    [self zb_viewDidDisappear:animated];

    NSString *class=[NSString stringWithFormat:@"退出:%@",NSStringFromClass([self class])];
    NSLog(@"%@",class);
}



@end
