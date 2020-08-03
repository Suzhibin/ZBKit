//
//  ZBDebug.m
//  ZBKit
//
//  Created by NQ UEC on 2018/4/24.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "ZBDebug.h"
#import "ZBSuspensionView.h"
#import "ZBMacros.h"
#import "ZBDebugTabBarController.h"
@interface ZBDebug ()<ZBSuspensionViewDelegate>

@property (nonatomic, strong) ZBSuspensionView *susView;

@end
@implementation ZBDebug

+ (instancetype)sharedInstance{
    static ZBDebug *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ZBDebug alloc] init];
    });
    return sharedInstance;
}
- (void)enable{
    [self.susView show];
}
- (void)close{
    [self.susView hide];
}
- (ZBSuspensionView *)susView{
    if (!_susView) {
        _susView = [ZBSuspensionView defaultSuspensionView];
        _susView.delegate=self;
    }
    return _susView;
}
#pragma mark - ZBSuspensionViewDelegate
- (void)suspensionViewClick{

    ZBDebugTabBarController *tabBar=[[ZBDebugTabBarController alloc]init];
    UITabBarController * rootView = (UITabBarController *)[[UIApplication sharedApplication].delegate window].rootViewController;
    tabBar.modalPresentationStyle=UIModalPresentationFullScreen;
    [rootView presentViewController:tabBar animated:YES completion:nil];
    //[self close];
}
@end
