//
//  UIViewController+ZBTracking.m
//  ZBKit
//
//  Created by NQ UEC on 17/3/3.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "UIViewController+ZBTracking.h"

@implementation UIViewController (ZBTracking)
- (UIViewController *)topMostViewController
{
    if (self.presentedViewController == nil || [self.presentedViewController isKindOfClass:[UIImagePickerController class]]) {
        
        return self;
        
    } else if ([self.presentedViewController isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController *navigationController = (UINavigationController *)self.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        
        return [lastViewController topMostViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)self.presentedViewController;
    
    return [presentedViewController topMostViewController];
}

@end
