//
//  ZBAdvertiseView.h
//  ZBKit
//
//  Created by NQ UEC on 17/1/10.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,AdvertiseType) {
    
    ZBAdvertiseTypeScreen,
    ZBAdvertiseTypeView
} ;

@interface ZBAdvertiseView : UIView

@property (copy, nonatomic) void (^ZBAdvertiseBlock)();

/**
 *  用于标识不同类型的request
 */
@property (nonatomic,assign) AdvertiseType adType;

/*
 *  创建广告视图
 */
- (instancetype)initWithFrame:(CGRect)frame type:(AdvertiseType)type;
/*
 *  显示到UIWindow上 
 *  如果不是开屏广告 不用此方法，添加到对应的视图上即可
 */
- (void)showWindow;

/**
 移除广告
 */
- (void)dismiss;
/*
 *  图片
 */
@property (nonatomic, strong) UIImage *adImage;

/*
 *  图片路径
 */
@property (nonatomic, copy) NSString *filePath;

/*
 *  跳转url
@property (nonatomic, copy) NSString *linkUrl;
*/

/*
 *  跳转字典
 */
@property (nonatomic, strong) NSDictionary *linkdict;
@end
