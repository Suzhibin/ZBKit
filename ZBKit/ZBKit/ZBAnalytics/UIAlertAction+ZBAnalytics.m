//
//  UIAlertAction+ZBAnalytics.m
//  ZBKit
//
//  Created by NQ UEC on 17/3/2.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "UIAlertAction+ZBAnalytics.h"
#import <objc/runtime.h>
@implementation UIAlertAction (ZBAnalytics)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethod = class_getInstanceMethod([self class], @selector(actionWithTitle:style:handler:));
        Method swizzledMethod = class_getInstanceMethod([self class], @selector(zb_actionWithTitle:style:handler:));
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });

}

+ (instancetype)zb_actionWithTitle:(nullable NSString *)title style:(UIAlertActionStyle)style handler:(void (^ __nullable)(UIAlertAction *action))handler
{
    UIAlertAction *alertAction = [[self class] zb_actionWithTitle:title style:style handler:handler];
    return alertAction;
}

@end
