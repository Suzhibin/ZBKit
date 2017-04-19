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
@implementation AppDelegate (ZBKit)
-(void)zb_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    ZBKLog(@"cachePath = %@",cachePath);
    
    // 检查版本更新
    [self updateApp];
    //初始化第三方授权
    [self initializePlat];
    //网络监测
    [self netWorkMonitoring];
    //程序获取焦点 展示广告
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    [[NSURLCache sharedURLCache]removeAllCachedResponses];
}

#pragma mark - 版本更新提示
- (void)updateApp{
 
    [[ZBURLSessionManager sharedInstance]requestWithConfig:^(ZBURLRequest *request) {
        request.urlString=@"http://itunes.apple.com/cn/lookup?id=123456789";
        request.apiType=ZBRequestTypeRefresh;
    } success:^(id responseObj, apiType type) {
        if (type==ZBRequestTypeRefresh) {
            NSDictionary *Obj = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
            ZBKLog(@"版本信息:%@",Obj);
            NSArray *results= [Obj objectForKey:@"results"];
            for (NSDictionary *dict in results) {
                NSString * version= [dict objectForKey:@"version"];
                if ([version isEqualToString:[[ZBGlobalSettingsTool sharedInstance] appVersion]]) {
                    ZBKLog(@"不升级");
                }else{
                    ZBKLog(@"需要升级");
                }
            }
        }
    } failed:^(NSError *error) {
         ZBKLog(@"版本更新error:%@",error);
    }];
}

#pragma mark - 初始化第三方平台
- (void)initializePlat{
    ZBKLog(@"初始化微信,微博,QQ等等");
}

#pragma mark - 网络状态监测
- (void)netWorkMonitoring{
    NSInteger netStatus=[ZBNetworkManager startNetWorkMonitoring];
    
    switch (netStatus) {
        case AFNetworkReachabilityStatusUnknown:
            ZBKLog(@"未识别的网络");
            break;
            
        case AFNetworkReachabilityStatusNotReachable:
            ZBKLog(@"不可达的网络(未连接)");
            break;
            
        case AFNetworkReachabilityStatusReachableViaWWAN:
            ZBKLog(@"2G,3G,4G...的网络");
            break;
            
        case AFNetworkReachabilityStatusReachableViaWiFi:
            ZBKLog(@"wifi的网络");
            break;
        default:
            break;
    }
}

#pragma mark - 开屏广告
- (void)becomeActive:(NSNotification *)notification {

    [ZBAdvertiseInfo getAdvertisingInfo:^(NSString *imagePath,NSDictionary *urlDict,BOOL isExist){
        if (isExist) {
            ZBAdvertiseView *advertiseView = [[ZBAdvertiseView alloc] initWithFrame:self.window.bounds];
            advertiseView.filePath = imagePath;
            advertiseView.ZBAdvertiseBlock=^{
                if ([[urlDict objectForKey:@"link"]isEqualToString:@""]) {
                    ZBKLog(@"没有url");
                    return;
                }else{
                    ZBKLog(@"有url跳转");
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushtoad" object:nil userInfo:urlDict];
                }
            };
            ZBKLog(@"展示广告");
        }else{
            ZBKLog(@"无广告");
        }
    }];
}


@end
