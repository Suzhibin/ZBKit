//
//  AppDelegate+ZBKit.m
//  ZBKit
//
//  Created by NQ UEC on 17/4/13.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "AppDelegate+ZBKit.h"
#import "ZBNetworking.h"
#import "ZBGlobalSettingsTool.h"
#import "ZBMacros.h"
#import "ZBLocationManager.h"
#import "ZBLocalized.h"
@implementation AppDelegate (ZBKit)
-(void)zb_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    ZBKLog(@"cachePath = %@",cachePath);
    //初始化第三方授权
    [self initializePlat];
    
}

#pragma mark - 初始化第三方平台
- (void)initializePlat{
    //初始化微信,微博,QQ等等
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    [[NSURLCache sharedURLCache]removeAllCachedResponses];
}
@end
