//
//  ZBWeatherView.h
//  ZBKit
//
//  Created by NQ UEC on 2017/4/27.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBWeatherView : UIView

/**
 添加天气动画

 @param weatherType 动画类型
 @param isNight     是否为夜晚
 */
- (void)addAnimationWithType:(NSString *)weatherType isNight:(BOOL)isNight;

/**
 删除动画
 */
- (void)removeAnimationView ;
@end
