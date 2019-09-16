//
//  ZBMacros.h
//  ZBNews
//
//  Created by NQ UEC on 2017/10/20.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#ifndef ZBMacros_h
#define ZBMacros_h

#define ZBKBUG_LOG 1
#if(ZBKBUG_LOG == 1)
# define ZBKLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
# define ZBKLog(...);
#endif

// 获取时间间隔
#define TICK   CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
#define TOCK   NSLog(@"Time: %f", CFAbsoluteTimeGetCurrent() - start)

//设备屏幕大小
#define  MainScreenFrame   [[UIScreen mainScreen] bounds]

//屏幕宽
#define ZB_SCREEN_WIDTH                ([UIScreen mainScreen].bounds.size.width)
//屏幕高
#define ZB_SCREEN_HEIGHT               ([UIScreen mainScreen].bounds.size.height)

#define ZB_TABBAR_HEIGHT   CGRectGetHeight(self.tabBarController.tabBar.frame)
#define ZB_NAVBAR_HEIGHT       self.navigationController.navigationBar.frame.size.height
#define ZB_STATUS_HEIGHT  [[UIApplication sharedApplication] statusBarFrame].size.height

//是否为ios7
#define is_ios7  [[[UIDevice currentDevice]systemVersion]floatValue]>=7

//4的设备
#define ZB_DEVICE_IS_Retina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
//5,5s的设备
#define ZB_DEVICE_IS_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define ZB_DEVICE_IS_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define ZB_DEVICE_IS_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define ZB_DEVICE_IS_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//判断是否是ipad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//判断iPhoneX
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

//iPhoneX系列
#define k_Height_NavContentBar 44.0f
#define k_Height_StatusBar ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 44.0 : 20.0)
#define k_Height_NavBar ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 88.0 : 64.0)
#define k_Height_TabBar ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 83.0 : 49.0)



#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
//随机颜色
#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

//取消键盘响应
#define HIDE_KEYBOARD [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];[[[UIApplication sharedApplication] keyWindow] endEditing:YES];

/** 判断是否为iPhone*/
#define ISiPhone   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
/** 判断是否为iPad*/
#define ISiPad     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

/** 判断是真机还是模拟器*/
#if TARGET_OS_IPHONE
//真机
#endif
#if TARGET_IPHONE_SIMULATOR
//模拟器
#endif


//夜间模式
static NSString * const READStyle = @"showNightView";
//无网不显示图片
static NSString * const READIMAGE = @"showImage";
//定位城市
static NSString * const CITY = @"locationCity";

/*
 platform:ios,'8.0'
 target :'ZBNews' do
 pod 'VTMagic', :git => 'https://github.com/tianzhuo112/VTMagic.git'
 pod 'SDWebImage'
 pod 'MJRefresh'
 pod 'UITableView+FDTemplateLayoutCell'
 pod 'FMDB'
 pod 'FSCalendar'
 pod 'SDAutoLayout'
 pod 'AFNetworking'
 pod 'FLAnimatedImage'
 pod 'UMengAnalytics'
 pod 'ReactiveObjC'
 use_frameworks!
 
 end
 */
//growingIO   Fabric
/*
用vi修改文件，保存文件时，提示“readonly option is set”的解决方法。
1.按Esc键2.输入 :set noreadonly3.然后就能正常保存了，你可以输入 :wq 来保存文件了
 */
/*
 介绍对象啊
 这你就算找对人了，专业对口.要介绍对象，要先说说类。 类是对逻辑上相关函数与数据的封装，是对问题的抽象，而对象就是类的特定实例。Object obj=new Object(),obj就是Object类的对象。
 */

#endif /* ZBMacros_h */
