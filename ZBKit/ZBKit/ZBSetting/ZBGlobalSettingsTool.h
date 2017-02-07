//
//  ZBGlobalSettingsTool.h
//  ZBKit
//
//  Created by NQ UEC on 17/2/6.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZBGlobalSettingsTool : NSObject

//开启推送
@property (nonatomic, assign, getter=isEnabledPush) BOOL enabledPush;

//正文字号 0 == 小 1 == 中 2 == 大;
@property (nonatomic, assign) int fontSize;

+ (ZBGlobalSettingsTool*)sharedInstance;

/**
 文字大小

 @return size
 */
- (int) getArticleFontSize;

/**
 夜间模式

 @return 是否夜间模式
 */
- (BOOL)getNightPattern;

/**
 图片WIFI浏览
 
 @return 是否WIFI
 */
- (BOOL)downloadImagePattern;

/**
 应用的名字
 
 @return 应用的名字
 */
- (NSString *)appBundleName;

/**
 应用的BundleID
 
 @return 应用的BundleID
 */
- (NSString *)appBundleID;

/**
 应用的版本
 
 @return 应用的版本
 */
- (NSString *)appVersion;

/**
 应用的Build
 
 @return 应用的Build
 */
- (NSString *)appBuildVersion;

/**
 设备名字
 
 @return 设备名字
 */
- (NSString *)machineName;

/**
 跳转评论

 @param APPID 应用ID
 */
- (void)openURL:(NSString *)APPID;

/**
 跳转设置页面
 */
- (void)openSettings;


@end
