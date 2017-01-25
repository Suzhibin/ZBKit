//
//  GlobalSettingsTool.m
//  ZBKit
//
//  Created by NQ UEC on 16/12/6.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "GlobalSettingsTool.h"
#import "sys/utsname.h"
#import <UIKit/UIKit.h>
@implementation GlobalSettingsTool
+ (GlobalSettingsTool*)sharedSetting
{
    static GlobalSettingsTool *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
    
}


- (id)init{
    self = [super init];
    if (self) {
        self.enabledPush = YES;
 
    }
    return self;
}
- (void) setDefaultPreferences {

    self.fontSize = 1;
    self.enabledPush = YES;
 
}
//得到模式选项  YES：夜间模式  NO：白天模式
+ (BOOL)getNightPattern{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"readStyle"]) {
        //  NSLog(@"夜间模式");
        return YES;
    }else{
        //    NSLog(@"日间模式");
        return NO;
    }
}
+ (BOOL)downloadImagePattern{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"readImage"]) {
        //NSLog(@"仅WIFI网络下载图片");
        return YES;
    }else{
       // NSLog(@"所有网络都可以下载图片");
        return NO;
    }
}

- (int) getArticleFontSize {
    switch (self.fontSize) {
        case 0:
            return 14;
            break;
        case 1:
            return 16;
            break;
        case 2:
            return 20;
            break;
            
        default:
            return 15;
            break;
    }
}

//跳转设置页面
- (void)openSettings{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}
//跳转评论
- (void)openURL:(NSString *)APPID{
    NSString *appstr=[NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",APPID];
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appstr]];
}
//禁止锁屏，
- (void)timerDisabled
{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}


//字符串反转
- (NSString*)reverseWordsInString:(NSString*)str
{
    NSMutableString *reverString = [NSMutableString stringWithCapacity:str.length];
    [str enumerateSubstringsInRange:NSMakeRange(0, str.length) options:NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences  usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [reverString appendString:substring];
    }];
    return reverString;
}
//两种方法删除NSUserDefaults所有记录
- (void)removeUserDefaults{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}
//应用的名字
- (NSString *)appBundleName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}

- (NSString *)appBundleID {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
}

- (NSString *)appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

- (NSString *)appBuildVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

- (NSString *)machineName {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    return deviceString;
}
@end
