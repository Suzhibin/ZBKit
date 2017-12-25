//
//  ZBTabBarItem.h
//  ZBKit
//
//  Created by NQ UEC on 2017/4/21.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBWeatherView.h"
@interface ZBTabBarItemButton : UIControl

@property(nonatomic,strong) UIImageView *iconView;
@property(nonatomic,strong) UILabel *titleLabel;
@end

typedef void (^ZBTabBarItemSelectedBlock)();

@interface ZBTabBarItem : UIView
@property (nonatomic, strong)UIButton *cityBtn;
@property (nonatomic, strong)UIButton *locationButton;
@property (nonatomic, strong)UILabel *weatherLabel;
@property (nonatomic, strong)ZBWeatherView* weatherView;
@property (nonatomic, strong)ZBTabBarItemButton* tabBarItemButton;

/**
 添加点击按钮

 @param title 按钮title
 @param icon 按钮图片
 @param block 按钮回调
 */
- (void)addItemWithTitle:(NSString*)title andIcon:(UIImage*)icon andSelectedBlock:(ZBTabBarItemSelectedBlock)block;

/**
 显示按钮
 */
- (void)show;
@end
