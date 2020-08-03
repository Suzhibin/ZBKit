//
//  ZBSuspensionView.m
//  ZBKit
//
//  Created by NQ UEC on 2018/4/23.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "ZBSuspensionView.h"
#import "YYFPSLabel.h"
#import "ZBMacros.h"
#import "ZBGlobalSettingsTool.h"
#define kLeanProportion (8/55.0)
#define kVerticalMargin 15.0
@implementation ZBSuspensionView

+ (instancetype)defaultSuspensionView
{
    ZBSuspensionView *sus = [[ZBSuspensionView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-55, [UIScreen mainScreen].bounds.size.height-200, 55, 55)];
    return sus;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
      // self.delegate = delegate;
        self.userInteractionEnabled = YES;
        self.backgroundColor =  [UIColor blackColor];
        self.alpha =1;
        self.clipsToBounds = YES;
        self.layer.cornerRadius = self.frame.size.width <= self.frame.size.height ? self.frame.size.width / 2.0 : self.frame.size.height / 2.0;
       
    
        UILabel *versionString=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, 60,15)];
        versionString.textColor=[UIColor greenColor];;
        versionString.font=[UIFont systemFontOfSize:10];
        versionString.textAlignment=NSTextAlignmentCenter;
        versionString.numberOfLines=2;
        versionString.text=[NSString stringWithFormat:@"V:%@",[[ZBGlobalSettingsTool sharedInstance]appVersion]];
        [self addSubview:versionString];
 
        // 初始化FPS label (监控FPS 调试使用)
        YYFPSLabel *fps = [[YYFPSLabel alloc]initWithFrame:CGRectMake(0,25, 60, 10)];//fps监测
               fps.font=[UIFont systemFontOfSize:12];
        [self addSubview:fps];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signalTap:)];
        [self addGestureRecognizer:tap];

        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        pan.delaysTouchesBegan = YES;
        [self addGestureRecognizer:pan];
        
        self.hidden=YES;
        UIWindow *currentKeyWindow = [UIApplication sharedApplication].keyWindow;
        [currentKeyWindow addSubview:self];
    }
    return self;
}

- (void)signalTap:(UITapGestureRecognizer *)tap{
    if([self.delegate respondsToSelector:@selector(suspensionViewClick)]){
        [self.delegate suspensionViewClick];
    }
}
- (void)pan:(UIPanGestureRecognizer *)pan{
    UIWindow *appWindow = [UIApplication sharedApplication].delegate.window;
    CGPoint panPoint = [pan locationInView:appWindow];
    
    if(pan.state == UIGestureRecognizerStateBegan) {
        self.alpha = 0.7;
    }else if(pan.state == UIGestureRecognizerStateChanged) {
        self.center = CGPointMake(panPoint.x, panPoint.y);
    }else if(pan.state == UIGestureRecognizerStateEnded
             || pan.state == UIGestureRecognizerStateCancelled) {
        self.alpha = 1;
        
        CGFloat ballWidth = self.frame.size.width;
        CGFloat ballHeight = self.frame.size.height;
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        
        CGFloat left = fabs(panPoint.x);
        CGFloat right = fabs(screenWidth - left);
        CGFloat top = fabs(panPoint.y);
        //CGFloat bottom = fabs(screenHeight - top);
        
        CGFloat minSpace = 0;

        minSpace = MIN(left, right);
        
        CGPoint newCenter = CGPointZero;
        CGFloat targetY = 0;
        
        //Correcting Y
        if (panPoint.y < kVerticalMargin + ballHeight / 2.0) {
            targetY = kVerticalMargin + ballHeight / 2.0;
        }else if (panPoint.y > (screenHeight - ballHeight / 2.0 - kVerticalMargin)) {
            targetY = screenHeight - ballHeight / 2.0 - kVerticalMargin;
        }else{
            targetY = panPoint.y;
        }
        
        CGFloat centerXSpace = (0.6 - kLeanProportion) * ballWidth;
        CGFloat centerYSpace = (0.5 - kLeanProportion) * ballHeight;
        
        if (minSpace == left) {
            newCenter = CGPointMake(centerXSpace, targetY);
        }else if (minSpace == right) {
            newCenter = CGPointMake(screenWidth - centerXSpace, targetY);
        }else if (minSpace == top) {
            newCenter = CGPointMake(panPoint.x, centerYSpace);
        }else {
            newCenter = CGPointMake(panPoint.x, screenHeight - centerYSpace);
        }
        
        [UIView animateWithDuration:.25 animations:^{
           self.center = newCenter;
        }];
    }else{
        ZBKLog(@"pan state : %zd", pan.state);
    }
}
- (void)show{
    self.hidden=NO;
}
- (void)hide{
    self.hidden=YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
