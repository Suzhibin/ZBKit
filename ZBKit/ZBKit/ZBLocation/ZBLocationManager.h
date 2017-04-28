//
//  ZBLocationManager.h
//  ZBKit
//
//  Created by NQ UEC on 2017/4/27.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface ZBLocationManager : NSObject<CLLocationManagerDelegate>
+ (ZBLocationManager *)sharedInstance;
//@property (nonatomic, copy) void (^LocationBlock)(NSString *cityName); // 右侧头像点击
- (void)startlocation;

- (NSString *)locationFilePath;
@end
