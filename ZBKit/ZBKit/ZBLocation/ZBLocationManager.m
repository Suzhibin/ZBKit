//
//  ZBLocationManager.m
//  ZBKit
//
//  Created by NQ UEC on 2017/4/27.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ZBLocationManager.h"
#import <UIKit/UIKit.h>
#import "ZBCacheManager.h"
@interface ZBLocationManager (){
    CLLocation *_lastLocation;
}
@property (nonatomic,strong) CLLocationManager *locManager;
@end
@implementation ZBLocationManager
+ (ZBLocationManager *)sharedInstance{
    static ZBLocationManager *location=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        location = [[ZBLocationManager alloc] init];
    });
    return location;
}
- (instancetype)init
{
    if (self = [super init]) {
   
    }
    return self;
}
- (void)startlocation
{
  //  [[ZBCacheManager sharedInstance]createDirectoryAtPath:[self locationFilePath]];
    
    self.locManager = [[CLLocationManager alloc] init];
    self.locManager .delegate = self;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        [self.locManager  requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8定位需要）
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] > 9)
    {
        /** iOS9新特性：将允许出现这种场景：同一app中多个location manager：一些只能在前台定位，另一些可在后台定位（并可随时禁止其后台定位）。 */
 
          self.locManager.allowsBackgroundLocationUpdates = YES;
    }
    // 方法二:判断位置管理者能否响应iOS8之后的授权方法
    if ([self.locManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        
        //            // 前台定位授权 官方文档中说明info.plist中必须有NSLocationWhenInUseUsageDescription键
        //            [_mgr requestWhenInUseAuthorization];
        // 前后台定位授权 官方文档中说明info.plist中必须有NSLocationAlwaysUsageDescription键
        [self.locManager requestAlwaysAuthorization];
    }
    //判断用户定位服务是否开启
    if ([CLLocationManager locationServicesEnabled]) {
        //         kCLLocationAccuracyBestForNavigation // 最适合导航
        //         kCLLocationAccuracyBest; // 最好的
        //         kCLLocationAccuracyNearestTenMeters; // 附近10米
        //         kCLLocationAccuracyHundredMeters; // 100米
        //         kCLLocationAccuracyKilometer; // 1000米
        //         kCLLocationAccuracyThreeKilometers; // 3000米
        self.locManager .desiredAccuracy = kCLLocationAccuracyBest;
        //每隔多少米定位一次
        self.locManager.distanceFilter = 3000.0f;
        //开始定位用户的位置
        [self.locManager startUpdatingLocation];
 
        
    }else{//不能定位用户的位置
        //1.提醒用户检查当前的网络状况
        //2.提醒用户打开定位开关
        return;
    }
    
}


#pragma mark - CoreLocation Delegate
// 定位失败调用的代理方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if ([error code]==kCLErrorDenied) {
        NSLog(@"访问被拒绝");
    }
    if ([error code]==kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    NSLog(@"lati : %f  longti : %f",manager.location.coordinate.latitude,manager.location.coordinate.longitude);
    //设置经纬度
 //   CLLocation *cllocation = [[CLLocation alloc]initWithLatitude:manager.location.coordinate.latitude longitude:manager.location.coordinate.longitude];
    
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
 //   CLLocation *currentLocation = [locations lastObject];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    // 通过定位获取的经纬度坐标，反编码获取地理信息标记并打印改标记下得城市名
    [geocoder reverseGeocodeLocation:[locations lastObject] completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
              NSLog(@"error - %@", error);
            /*
            [[ZBCacheManager sharedInstance]storeContent:@"北京" forKey:@"city" path:[self locationFilePath] isSuccess:^(BOOL isSuccess) {
                if (isSuccess) {
                    NSLog(@"city存储成功");
                }
            }];
             */
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:@"北京" forKey:@"city"];
            //这里建议同步存储到磁盘中，但是不是必须的
            [userDefaults synchronize];
    
        }else{
            CLPlacemark *mark = [placemarks lastObject];
            NSString *countryName = mark.country;
            NSString *cityName = mark.locality;
            
            NSLog(@"国家 - %@", countryName);
            NSLog(@"城市 - %@", cityName);
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:cityName forKey:@"city"];
            //这里建议同步存储到磁盘中，但是不是必须的
            [userDefaults synchronize];
            /*
              [[ZBCacheManager sharedInstance]storeContent:cityName forKey:@"city" path:[self locationFilePath] isSuccess:^(BOOL isSuccess) {
                  if (isSuccess) {
                      NSLog(@"city存储成功");
                  }
              }];
             */
        }
     
    }];
    
    
    CLLocation *location = [locations lastObject];
    if(location.horizontalAccuracy < 0)
        return;
    
    // 场景演示:打印当前用户的行走方向,偏离角度以及对应的行走距离,
    // 例如:” 北偏东  30度  方向,移动了 8 米”
    // 1. 确定航向
    NSString *angleStr;
    switch ((int)location.course / 90) {
        case 0:
            angleStr = @"北偏东";
            break;
        case 1:
            angleStr = @"东偏南";
            break;
        case 2:
            angleStr = @"南偏西";
            break;
        case 3:
            angleStr = @"西偏北";
            break;
            
        default:
            angleStr = @"掉沟里去了";
            break;
    }
    
    // 2. 确定偏离角度
    NSInteger angle = (int)location.course % 90;
    if(angle == 0)
    {
        angleStr = [angleStr substringToIndex:1];
    }
    
    
    // 确定行走了多少米
    double distance = 0;
    if (_lastLocation) {
        distance = [location distanceFromLocation:_lastLocation];
    }
    _lastLocation = location;
    // 例如:” 北偏东  30度  方向,移动了 8 米”
    NSString *noticeStr;
    if (angle == 0) {
        noticeStr = [NSString stringWithFormat:@"正%@方向, 移动了%f米", angleStr, distance];
    }else
    {
        noticeStr = [NSString stringWithFormat:@"%@%zd方向, 移动了%f米", angleStr, angle, distance];
    }
    
    
    NSLog(@"%@", noticeStr);
    [manager stopUpdatingLocation];
    
}
/*
// 如果授权状态发生变化时,调用
// status : 当前的授权状态
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        {
            NSLog(@"用户未决定");
            break;
        }
        case kCLAuthorizationStatusRestricted:
        {
            NSLog(@"受限制");
            break;
        }
        case kCLAuthorizationStatusDenied:
        {
            // 判断当前设备是否支持定位, 并且定位服务是否开启()
            if([CLLocationManager locationServicesEnabled])
            {
                NSLog(@"定位开启,被拒绝");
                // ios8,0- 需要截图提醒引导用户
                
                // iOS8.0+
                //                NSURL *url = [NSURL URLWithString:]
                //                if([[UIApplication sharedApplication] openURL:<#(NSURL *)#>])
                
            }else
            {
                NSLog(@"定位服务关闭");
            }
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            NSLog(@"前后台定位授权");
            break;
        }
            
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            NSLog(@"前台定位授权");
            break;
        }
            
        default:
            break;
    }
}
 */

@end
