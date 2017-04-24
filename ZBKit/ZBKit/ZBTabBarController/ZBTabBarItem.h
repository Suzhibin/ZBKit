//
//  ZBTabBarItem.h
//  ZBKit
//
//  Created by NQ UEC on 2017/4/21.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ZBTabBarItemSelectedBlock)();

@interface ZBTabBarItem : UIView<UIGestureRecognizerDelegate,CAAnimationDelegate>
- (void)addItemWithTitle:(NSString*)title andIcon:(UIImage*)icon andSelectedBlock:(ZBTabBarItemSelectedBlock)block;
- (void)show;
@end
