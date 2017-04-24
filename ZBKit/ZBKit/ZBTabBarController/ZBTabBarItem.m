//
//  ZBTabBarItem.m
//  ZBKit
//
//  Created by NQ UEC on 2017/4/21.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ZBTabBarItem.h"
#import "ZBConstants.h"
#import "UIView+ZBKit.h"
#import "ZBAdvertiseInfo.h"
#import "ZBAdvertiseView.h"

#define CHTumblrMenuViewTag 1999
#define CHTumblrMenuViewImageHeight 71
#define CHTumblrMenuViewTitleHeight 20
#define CHTumblrMenuViewVerticalPadding 10
#define CHTumblrMenuViewHorizontalMargin 20
#define CHTumblrMenuViewRriseAnimationID @"CHTumblrMenuViewRriseAnimationID"
#define CHTumblrMenuViewDismissAnimationID @"CHTumblrMenuViewDismissAnimationID"
#define CHTumblrMenuViewAnimationTime 0.36
#define CHTumblrMenuViewAnimationInterval (CHTumblrMenuViewAnimationTime / 5)

@interface ZBTabBarItemButton : UIControl
- (id)initWithTitle:(NSString*)title andIcon:(UIImage*)icon andSelectedBlock:(ZBTabBarItemSelectedBlock)block;
@property(nonatomic,copy)ZBTabBarItemSelectedBlock selectedBlock;
@end

@implementation ZBTabBarItemButton
{
    UIImageView *iconView_;
    UILabel *titleLabel_;
    
}

- (id)initWithTitle:(NSString*)title andIcon:(UIImage*)icon andSelectedBlock:(ZBTabBarItemSelectedBlock)block
{
    self = [super init];
    if (self) {
        iconView_ = [UIImageView new];
        iconView_.image = icon;
        titleLabel_ = [UILabel new];
        titleLabel_.textAlignment = NSTextAlignmentCenter;
        titleLabel_.backgroundColor = [UIColor clearColor];
        titleLabel_.textColor = [UIColor blackColor];
        titleLabel_.text = title;
        titleLabel_.font = [UIFont systemFontOfSize:14.0f];
        _selectedBlock = block;
        [self addSubview:iconView_];
        [self addSubview:titleLabel_];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    iconView_.frame = CGRectMake(0, 0, CHTumblrMenuViewImageHeight, CHTumblrMenuViewImageHeight);
    titleLabel_.frame = CGRectMake(0, CHTumblrMenuViewImageHeight, CHTumblrMenuViewImageHeight, CHTumblrMenuViewTitleHeight);
}


@end

@interface ZBTabBarItem()
@property (nonatomic,strong)ZBAdvertiseView *advertiseView;
@end


@implementation ZBTabBarItem
{
    NSMutableArray *buttons_;
    UIButton *_addBut;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self advertise];
        [self createTime];
        
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
        ges.delegate = self;
        [self addGestureRecognizer:ges];
        self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.98];
        
        buttons_ = [[NSMutableArray alloc] initWithCapacity:6];
        
        UIView *toolbarView = [[UIView alloc] init];
        toolbarView.backgroundColor=[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
        [toolbarView setFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
        [self addSubview:toolbarView];
        
        _addBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBut setImage:[UIImage imageNamed:@"tabbar_compose_background_icon_add.png"] forState:UIControlStateNormal];
        [_addBut setFrame:CGRectMake((toolbarView.zb_width - 44) / 2, 0, 44, 44)];
        [_addBut addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
        [toolbarView addSubview:_addBut];
        
    }
    return self;
}
- (void)advertise{
    __weak typeof(self) weakSelf = self;
    [ZBAdvertiseInfo getAdvertisingInfo:^(NSString *imagePath,NSDictionary *urlDict,BOOL isExist){
        if (isExist) {
            ZBAdvertiseView *advertiseView= [[ZBAdvertiseView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 64, SCREEN_WIDTH/2-20, 100) type:ZBAdvertiseTypeView];
            
            advertiseView.filePath = imagePath;
            advertiseView.ZBAdvertiseBlock=^{
                if ([[urlDict objectForKey:@"link"]isEqualToString:@""]) {
                    return;
                }else{
                    ///有url跳转 要在tabbarController 里 presentViewController
                    [weakSelf dismiss:nil];//跳转时 移除view
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarPushToAd" object:nil userInfo:urlDict];
                }
            };
            [self addSubview:advertiseView];
             self.advertiseView=advertiseView;
           //展示广告
        }else{
           //无广告"
        }
    }];
}
- (void)createTime{
    NSDate *currentDate = [NSDate date];
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:currentDate];
    
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 64, 120, 20)];
    timeLabel.text=currentDateStr;
    [self addSubview: timeLabel];

}

- (void)addItemWithTitle:(NSString*)title andIcon:(UIImage*)icon andSelectedBlock:(ZBTabBarItemSelectedBlock)block{
    ZBTabBarItemButton *button = [[ZBTabBarItemButton alloc] initWithTitle:title andIcon:icon andSelectedBlock:block];
    
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    [buttons_ addObject:button];

}

- (CGRect)frameForButtonAtIndex:(NSUInteger)index{
    NSUInteger columnCount = 3;
    NSUInteger columnIndex =  index % columnCount;
    
    NSUInteger rowCount = buttons_.count / columnCount + (buttons_.count%columnCount>0?1:0);
    NSUInteger rowIndex = index / columnCount;
    
    CGFloat itemHeight = (CHTumblrMenuViewImageHeight + CHTumblrMenuViewTitleHeight) * rowCount + (rowCount > 1?(rowCount - 1) * CHTumblrMenuViewHorizontalMargin:0);
    CGFloat offsetY = (self.bounds.size.height - itemHeight) / 2.0;
    CGFloat verticalPadding = (self.bounds.size.width - CHTumblrMenuViewHorizontalMargin * 2 - CHTumblrMenuViewImageHeight * 3) / 2.0;
    
    CGFloat offsetX = CHTumblrMenuViewHorizontalMargin;
    offsetX += (CHTumblrMenuViewImageHeight+ verticalPadding) * columnIndex;
    
    offsetY += (CHTumblrMenuViewImageHeight + CHTumblrMenuViewTitleHeight + CHTumblrMenuViewVerticalPadding) * rowIndex;
    
    return CGRectMake(offsetX, offsetY, CHTumblrMenuViewImageHeight, (CHTumblrMenuViewImageHeight+CHTumblrMenuViewTitleHeight));
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    for (NSUInteger i = 0; i < buttons_.count; i++) {
        ZBTabBarItemButton *button = buttons_[i];
        button.frame = [self frameForButtonAtIndex:i];
    }
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer.view isKindOfClass:[ZBTabBarItemButton class]]) {
        return NO;
    }
    
    CGPoint location = [gestureRecognizer locationInView:self];
    for (UIView* subview in buttons_) {
        if (CGRectContainsPoint(subview.frame, location)) {
            return NO;
        }
    }
    
    return YES;
}

- (void)dismiss:(id)sender{
    [self dropAnimation];
 
    double delayInSeconds = CHTumblrMenuViewAnimationInterval * buttons_.count-1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        [UIView animateWithDuration:0.5f animations:^{
            self.alpha = 0.f;
        } completion:^(BOOL finished) {
            [self.advertiseView dismiss];
            [self removeFromSuperview];
        }];
    });
}

- (void)buttonTapped:(ZBTabBarItemButton*)btn{
    [self dismiss:nil];
    double delayInSeconds =CHTumblrMenuViewAnimationInterval * buttons_.count;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        btn.selectedBlock();
    });
}

- (void)riseAnimation{
  
    NSUInteger columnCount = 3;
    NSUInteger rowCount = buttons_.count / columnCount + (buttons_.count%columnCount>0?1:0);
    
    
    for (NSUInteger index = 0; index < buttons_.count; index++) {
        ZBTabBarItemButton *button = buttons_[index];
        button.layer.opacity = 0;
        CGRect frame = [self frameForButtonAtIndex:index];
        NSUInteger rowIndex = index / columnCount;
        NSUInteger columnIndex = index % columnCount;
        CGPoint fromPosition = CGPointMake(frame.origin.x + CHTumblrMenuViewImageHeight / 2.0,frame.origin.y +  (rowCount - rowIndex + 2)*200 + (CHTumblrMenuViewImageHeight + CHTumblrMenuViewTitleHeight) / 2.0);
        
        CGPoint toPosition = CGPointMake(frame.origin.x + CHTumblrMenuViewImageHeight / 2.0,frame.origin.y + (CHTumblrMenuViewImageHeight + CHTumblrMenuViewTitleHeight) / 2.0);
        
        double delayInSeconds = rowIndex * columnCount * CHTumblrMenuViewAnimationInterval;
        
        if (columnIndex == 1) {
            delayInSeconds += CHTumblrMenuViewAnimationInterval * 0.3;
        }
        else if(columnIndex == 2) {
            delayInSeconds += CHTumblrMenuViewAnimationInterval * 0.6;
        }
        
        CABasicAnimation *positionAnimation;
        
        
        positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:fromPosition];
        positionAnimation.toValue = [NSValue valueWithCGPoint:toPosition];
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.45f :1.2f :0.75f :1.0f];
        positionAnimation.duration = CHTumblrMenuViewAnimationTime;
        positionAnimation.beginTime = [button.layer convertTime:CACurrentMediaTime() fromLayer:nil] + delayInSeconds;
        [positionAnimation setValue:[NSNumber numberWithUnsignedInteger:index] forKey:CHTumblrMenuViewRriseAnimationID];
        positionAnimation.delegate = self;
        
        [button.layer addAnimation:positionAnimation forKey:@"riseAnimation"];
        
        
        CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D fromValue = _addBut.layer.transform;
        // 设置动画开始的属性值
        anim.fromValue = [NSValue valueWithCATransform3D:fromValue];
        // 绕Z轴旋转180度
        CATransform3D toValue = CATransform3DRotate(fromValue, M_PI_4 / 6, 0 , 0 , 1);
        // 设置动画结束的属性值
        anim.toValue = [NSValue valueWithCATransform3D:toValue];
        anim.duration = 0.2;
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        _addBut.layer.transform = toValue;
        anim.removedOnCompletion = YES;
        [_addBut.layer addAnimation:anim forKey:nil];
        
        /*
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"composer_open" ofType:@"wav"];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        SystemSoundID soundId;
        AudioServicesCreateSystemSoundID((CFURLRef)url, &soundId);
        AudioServicesPlayAlertSound(soundId);
         */
    }
}

- (void)dropAnimation{
    NSUInteger columnCount = 3;
    NSUInteger rowCount = buttons_.count / columnCount + (buttons_.count%columnCount>0?1:0);
    
    for (NSInteger index = buttons_.count-1; index >= 0; index--) {
        ZBTabBarItemButton *button = buttons_[index];
        CGRect frame = [self frameForButtonAtIndex:index];
        NSUInteger rowIndex = (buttons_.count - 1 - index) / columnCount;
        NSUInteger columnIndex = index % columnCount;
        
        CGPoint toPosition = CGPointMake(frame.origin.x + CHTumblrMenuViewImageHeight / 2.0,frame.origin.y +  (rowCount - rowIndex + 2)*200 + (CHTumblrMenuViewImageHeight + CHTumblrMenuViewTitleHeight) / 2.0);
        
        CGPoint fromPosition = CGPointMake(frame.origin.x + CHTumblrMenuViewImageHeight / 2.0,frame.origin.y + (CHTumblrMenuViewImageHeight + CHTumblrMenuViewTitleHeight) / 2.0);
        
        double delayInSeconds = rowIndex * columnCount * CHTumblrMenuViewAnimationInterval;
        if (columnIndex == 1) {
            delayInSeconds += CHTumblrMenuViewAnimationInterval*0.3;
        }
        else if(columnIndex == 0) {
            delayInSeconds += CHTumblrMenuViewAnimationInterval * 0.6;
        }
        
        CABasicAnimation *positionAnimation;
        
        positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:fromPosition];
        positionAnimation.toValue = [NSValue valueWithCGPoint:toPosition];
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.3 :0.5f :1.0f :1.0f];
        positionAnimation.duration = CHTumblrMenuViewAnimationTime;
        positionAnimation.beginTime = [button.layer convertTime:CACurrentMediaTime() fromLayer:nil] + delayInSeconds;
        [positionAnimation setValue:[NSNumber numberWithUnsignedInteger:index] forKey:CHTumblrMenuViewDismissAnimationID];
        positionAnimation.delegate = self;
        
        [button.layer addAnimation:positionAnimation forKey:@"riseAnimation"];
        
        
        
        CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D fromValue = _addBut.layer.transform;
        // 设置动画开始的属性值
        anim.fromValue = [NSValue valueWithCATransform3D:fromValue];
        // 绕Z轴旋转180度
        CATransform3D toValue = CATransform3DRotate(fromValue, - M_PI_4 / 6, 0 , 0 , 1);
        // 设置动画结束的属性值
        anim.toValue = [NSValue valueWithCATransform3D:toValue];
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        anim.duration = 0.2;
        _addBut.layer.transform = toValue;
        anim.removedOnCompletion = YES;
        [_addBut.layer addAnimation:anim forKey:nil];
        
        /*
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"composer_close" ofType:@"wav"];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        SystemSoundID soundId;
        AudioServicesCreateSystemSoundID((CFURLRef)url, &soundId);
        AudioServicesPlayAlertSound(soundId);
        */
    }
}

- (void)animationDidStart:(CAAnimation *)anim{
    NSUInteger columnCount = 3;
    if([anim valueForKey:CHTumblrMenuViewRriseAnimationID]) {
        NSUInteger index = [[anim valueForKey:CHTumblrMenuViewRriseAnimationID] unsignedIntegerValue];
        UIView *view = buttons_[index];
        CGRect frame = [self frameForButtonAtIndex:index];
        CGPoint toPosition = CGPointMake(frame.origin.x + CHTumblrMenuViewImageHeight / 2.0,frame.origin.y + (CHTumblrMenuViewImageHeight + CHTumblrMenuViewTitleHeight) / 2.0);
        CGFloat toAlpha = 1.0;
        
        view.layer.position = toPosition;
        view.layer.opacity = toAlpha;
        
        //        [_addBut setImage:[UIImage imageNamed:@"tabbar_compose_background_icon_close@2x.png"] forState:UIControlStateNormal];
    }
    else if([anim valueForKey:CHTumblrMenuViewDismissAnimationID]) {
        NSUInteger index = [[anim valueForKey:CHTumblrMenuViewDismissAnimationID] unsignedIntegerValue];
        NSUInteger rowIndex = index / columnCount;
        
        UIView *view = buttons_[index];
        CGRect frame = [self frameForButtonAtIndex:index];
        CGPoint toPosition = CGPointMake(frame.origin.x + CHTumblrMenuViewImageHeight / 2.0,frame.origin.y -  (rowIndex + 2)*200 + (CHTumblrMenuViewImageHeight + CHTumblrMenuViewTitleHeight) / 2.0);
        
        view.layer.position = toPosition;
    }
}

- (void)show{
   
    UIViewController *appRootViewController;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    appRootViewController = window.rootViewController;
    
    UIViewController *topViewController = appRootViewController;
    while (topViewController.presentedViewController != nil)
    {
        topViewController = topViewController.presentedViewController;
    }
    
    if ([topViewController.view viewWithTag:CHTumblrMenuViewTag]) {
        [[topViewController.view viewWithTag:CHTumblrMenuViewTag] removeFromSuperview];
    }
    
    self.frame = topViewController.view.bounds;
    [topViewController.view addSubview:self];
    /*
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    */
    [self riseAnimation];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
