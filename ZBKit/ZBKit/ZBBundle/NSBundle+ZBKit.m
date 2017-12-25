//
//  NSBundle+ZBKit.m
//  ZBKit
//
//  Created by NQ UEC on 17/1/13.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "NSBundle+ZBKit.h"

@implementation NSBundle (ZBKit)

+ (NSString *)zb_navigationReturn
{
    static NSString *navigationReturn=@"ZBKit.bundle/ZBNavigation/navigationButtonReturn";
    return navigationReturn;
}

+ (NSString *)zb_navigationReturnClick
{
    static NSString *navigationReturnClick=@"ZBKit.bundle/ZBNavigation/navigationButtonReturnClick";
    return navigationReturnClick;
}
+ (NSString *)zb_placeholder
{
    static NSString *placeholder=@"ZBKit.bundle/zhanweitu";
    return placeholder;
}
+ (NSString *)zb_IDInfo
{
    static NSString *IDInfo=@"ZBKit.bundle/ZBSetting/IDInfo";
    return IDInfo;
}
+ (NSString *)zb_handShake
{
    static NSString *handShake=@"ZBKit.bundle/ZBSetting/handShake";
    return handShake;
}
+ (NSString *)zb_MoreAbout
{
    static NSString *MoreAbout=@"ZBKit.bundle/ZBSetting/MoreAbout";
    return MoreAbout;
}
+ (NSString *)zb_MoreHelp
{
    static NSString *MoreHelp=@"ZBKit.bundle/ZBSetting/MoreHelp";
    return MoreHelp;
}
+ (NSString *)zb_MoreMessage
{
    static NSString *MoreMessage=@"ZBKit.bundle/ZBSetting/MoreMessage";
    return MoreMessage;
}
+ (NSString *)zb_MorePush
{
    static NSString *MorePush=@"ZBKit.bundle/ZBSetting/MorePush";
    return MorePush;
}
+ (NSString *)zb_MoreShare
{
    static NSString *MoreShare=@"ZBKit.bundle/ZBSetting/MoreShare";
    return MoreShare;
}
+ (NSString *)zb_MoreUpdate
{
    static NSString *MoreUpdate=@"ZBKit.bundle/ZBSetting/MoreUpdate";
    return MoreUpdate;
}
+ (NSString *)zb_Arrow
{
    static NSString *Arrow=@"ZBKit.bundle/ZBSetting/sliderMenu_rightArrow";
    return Arrow;
}
@end
