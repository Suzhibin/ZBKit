//
//  UIViewController+XPModal.h
//  https://github.com/xiaopin/iOS-Modal.git
//
//  Created by xiaopin on 2018/4/23.
//  Copyright © 2018年 xiaopin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XPModalConfiguration.h"

/** 配置的Block */
typedef void (^ModalConfigBlock)(XPModalConfiguration * _Nonnull config);

typedef void(^ModalCompletionHandler)(void);


@interface UIViewController (XPModal)

/**
 显示一个模态视图控制器

 @param controller  模态视图控制器
 @param configBlock     模态窗口的配置信息
 @param completion      模态窗口显示完毕时的回调
 */
- (void)presentModalWithController:(UIViewController *_Nullable)controller
                       configBlock:(ModalConfigBlock _Nullable )configBlock  completion:(ModalCompletionHandler _Nullable)completion NS_AVAILABLE_IOS(8_0);

/**
 显示一个模态视图
 
 @param view            模态视图控制器
 @param configBlock     模态窗口的配置信息
 @param completion      模态窗口显示完毕时的回调
 */
- (void)presentModalWithView:(UIView *_Nullable)view configBlock:(ModalConfigBlock _Nullable )configBlock completion:(ModalCompletionHandler _Nullable)completion NS_AVAILABLE_IOS(8_0);

@end
