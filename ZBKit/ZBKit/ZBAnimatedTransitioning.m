//
//  ZBAnimatedTransitioning.m
//  ZBKit
//
//  Created by NQ UEC on 17/2/9.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ZBAnimatedTransitioning.h"

@implementation ZBAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.8f;
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    // 获取动画的源控制器和目标控制器
    UIViewController * fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
     UIViewController * toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect finalFrameForVc = [transitionContext finalFrameForViewController:toVc];
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    toVc.view.frame = CGRectOffset(finalFrameForVc, 0, bounds.size.height);
    
    [[transitionContext containerView] addSubview:toVc.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         fromVc.view.alpha = 0.8;
                         toVc.view.frame = finalFrameForVc;
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                         fromVc.view.alpha = 1.0;
                     }];

}
@end
