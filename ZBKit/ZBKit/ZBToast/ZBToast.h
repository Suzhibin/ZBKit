//
//  ZBToast.h
//  ZBKit
//
//  Created by NQ UEC on 2018/1/18.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZBToast : NSObject
#pragma mark-中间显示
/**
 *  中间显示
 *
 *  @param text 内容
 */
+ (void)showCenterWithText:(NSString *)text;
/**
 *  中间显示+自定义停留时间
 *
 *  @param text     内容
 *  @param duration 停留时间
 */
+ (void)showCenterWithText:(NSString *)text duration:(CGFloat)duration;

#pragma mark-上方显示
/**
 *  上方显示
 *
 *  @param text 内容
 */
+ (void)showTopWithText:(NSString *)text;
/**
 *  上方显示+自定义停留时间
 *
 *  @param text     内容
 *  @param duration 停留时间
 */
+ (void)showTopWithText:(NSString *)text duration:(CGFloat)duration;
/**
 *  上方显示+自定义距顶端距离
 *
 *  @param text      内容
 *  @param topOffset 到顶端距离
 */
+ (void)showTopWithText:(NSString *)text topOffset:(CGFloat)topOffset;

/**
 *  上方显示+自定义距顶端距离+自定义停留时间
 *
 *  @param text      内容
 *  @param topOffset 到顶端距离
 *  @param color     背景颜色
 */
+ (void)showTopWithText:(NSString *)text topOffset:(CGFloat)topOffset color:(UIColor *)color;
/**
 *  上方显示+自定义距顶端距离+自定义停留时间
 *
 *  @param text      内容
 *  @param topOffset 到顶端距离
 *  @param duration  停留时间
 *  @param color     背景颜色
 */
+ (void)showTopWithText:(NSString *)text topOffset:(CGFloat)topOffset duration:(CGFloat)duration color:(UIColor *)color;

#pragma mark-下方显示
/**
 *  下方显示
 *
 *  @param text 内容
 */
+ (void)showBottomWithText:(NSString *)text;
/**
 *  下方显示+自定义停留时间
 *
 *  @param text     内容
 *  @param duration 停留时间
 */
+ (void)showBottomWithText:(NSString *)text duration:(CGFloat)duration;
/**
 *  下方显示+自定义距底端距离
 *
 *  @param text         内容
 *  @param bottomOffset 距底端距离
 */
+ (void)showBottomWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset;
/**
 *  下方显示+自定义距底端距离+自定义停留时间
 *
 *  @param text         内容
 *  @param bottomOffset 距底端距离
 *  @param duration     停留时间
 */
+ (void)showBottomWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset duration:(CGFloat)duration;

@end
