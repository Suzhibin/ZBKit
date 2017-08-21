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
#import "ZBAdvertiseInfo.h"
#import "ZBAdvertiseView.h"
#import "ZBConstants.h"
#import "ZBLocationManager.h"
#import "ZBLocalized.h"
#import "ZBTabBarController.h"

@implementation AppDelegate (ZBKit)
-(void)zb_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    ZBKLog(@"cachePath = %@",cachePath);
    
     [[ZBLocalized sharedInstance]initLanguage];//放在控件前初始化
    //初始化vc
    [self initRoot];
 
   // [self location];
    // 检查版本更新
    [self updateApp];
    //初始化第三方授权
    [self initializePlat];
    //展示广告
   // [self advertise];


    // app从后台进入前台都会调用这个方法
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)initRoot{
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
    
    ZBTabBarController *tabbar=[[ZBTabBarController alloc]init];
    
    self.window.rootViewController = tabbar;
    
    [self.window makeKeyAndVisible];
}

- (void)applicationEnterForeground{
    [self advertise];
}

#pragma mark - 定位
- (void)location{
      [[ZBLocationManager sharedInstance]startlocation];
}

#pragma mark - 版本更新提示
- (void)updateApp{
    NSString *key =@"CFBundleShortVersionString";
    NSString *appVersion= [[ZBGlobalSettingsTool sharedInstance] appVersion];
    // 获取沙盒中存储的版本号
    NSString *sanboxVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (sanboxVersion.length>0) {
        if (![appVersion isEqualToString:sanboxVersion]) {
            ZBKLog(@"需要升级");
            [ZBRequestManager requestWithConfig:^(ZBURLRequest *request) {
                request.urlString=@"http://itunes.apple.com/cn/lookup?id=123456789";
                request.apiType=ZBRequestTypeRefresh;
            } success:^(id responseObj, apiType type) {
                if (type==ZBRequestTypeRefresh) {
                    NSDictionary *Obj = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
                    ZBKLog(@"版本信息:%@",Obj);
                    /*
                    NSArray *results= [Obj objectForKey:@"results"];
                    for (NSDictionary *dict in results) {
                        //  NSString * version= [dict objectForKey:@"version"];
                        
                    }
                     */
                }
            } failed:^(NSError *error) {
                ZBKLog(@"版本更新error:%@",error);
            }];
            // 存储版本号
            [[NSUserDefaults standardUserDefaults]  setObject:appVersion forKey:key];
            [[NSUserDefaults standardUserDefaults]  synchronize];
        }else{
            ZBKLog(@"不升级");
        }
    }else{
        ZBKLog(@"第一次启动 存储版本");
        // 存储版本号
        [[NSUserDefaults standardUserDefaults]  setObject:appVersion forKey:key];
        [[NSUserDefaults standardUserDefaults]  synchronize];
    }
}

#pragma mark - 开屏广告
- (void)advertise{
     __weak typeof(self) weakSelf = self;
    [ZBAdvertiseInfo getAdvertisingInfo:^(NSString *imagePath,NSDictionary *urlDict,BOOL isExist){
        if (isExist) {
            ZBAdvertiseView *advertiseView = [[ZBAdvertiseView alloc] initWithFrame:weakSelf.window.bounds type:ZBAdvertiseTypeScreen];
            advertiseView.filePath = imagePath;
            advertiseView.ZBAdvertiseBlock=^{
                if ([[urlDict objectForKey:@"link"]isEqualToString:@""]) {
                    return;
                }else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushtoad" object:nil userInfo:urlDict];
                }
            };
            NSLog(@"展示广告");
        }else{
            NSLog(@"无广告");
        }
    }];

}

#pragma mark - 初始化第三方平台
- (void)initializePlat{
    //初始化微信,微博,QQ等等
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    [[NSURLCache sharedURLCache]removeAllCachedResponses];
}
@end
