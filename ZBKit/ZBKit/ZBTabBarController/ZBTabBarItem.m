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
#import "ZBControlTool.h"
#define ZBTabBarItemTag 1999
#define ZBTabBarItemImageHeight 71
#define ZBTabBarItemImageHeight 71
#define ZBTabBarItemTitleHeight 20
#define ZBTabBarItemVerticalPadding 10
#define ZBTabBarItemHorizontalMargin 20
#define ZBTabBarItemRriseAnimationID @"CHTumblrMenuViewRriseAnimationID"
#define ZBTabBarItemDismissAnimationID @"CHTumblrMenuViewDismissAnimationID"
#define ZBTabBarItemAnimationTime 0.36
#define ZBTabBarItemAnimationInterval (ZBTabBarItemAnimationTime / 5)

@interface ZBTabBarItemButton()
- (id)initWithTitle:(NSString*)title andIcon:(UIImage*)icon andSelectedBlock:(ZBTabBarItemSelectedBlock)block;
@property(nonatomic,copy)ZBTabBarItemSelectedBlock selectedBlock;

@end

@implementation ZBTabBarItemButton

- (id)initWithTitle:(NSString*)title andIcon:(UIImage*)icon andSelectedBlock:(ZBTabBarItemSelectedBlock)block
{
    self = [super init];
    if (self) {
        
        
        self.iconView = [UIImageView new];
        self.iconView.image = icon;
        self.titleLabel = [UILabel new];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.text = title;
        self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _selectedBlock = block;
        [self addSubview:self.iconView];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.iconView.frame = CGRectMake(0, 0, ZBTabBarItemImageHeight, ZBTabBarItemImageHeight);
    self.titleLabel.frame = CGRectMake(0, ZBTabBarItemImageHeight, ZBTabBarItemImageHeight, ZBTabBarItemTitleHeight);
}


@end

@interface ZBTabBarItem()
@property (nonatomic, strong)ZBAdvertiseView *advertiseView;
@property (nonatomic, strong) UIImageView  *backgroudView;
@end
@implementation ZBTabBarItem
{
    NSMutableArray *buttons_;
    UIButton *_addBut;
    BOOL _isDrop;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tap:)];
        Tap.delegate = self;
        [self addGestureRecognizer:Tap];
        self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.98];
        buttons_ = [[NSMutableArray alloc] initWithCapacity:6];

        [self createBackgroundView];
      //  [self advertise];
        [self createTime];
        [self locationAndWeather];
        [self createBottomButton];

    }
    return self;
}
//创建背景视图
- (void)createBackgroundView {
    ZBWeatherView* weatherView = [[ZBWeatherView alloc]initWithFrame:CGRectMake(0, 0, self.zb_width, self.zb_height)];
    [self addSubview:weatherView];
    self.weatherView=weatherView;
}

- (void)createTime{    
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-140, 64,120, 20)];
    timeLabel.text=[ZBControlTool currentDate];
    timeLabel.font = [UIFont boldSystemFontOfSize:20];
    timeLabel.textColor=[UIColor whiteColor];
    [self addSubview: timeLabel];

}
- (void)locationAndWeather{
    UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    locationButton.frame=CGRectMake(SCREEN_WIDTH-144, 90, 44, 44);
    // locationButton.backgroundColor=[UIColor yellowColor];
    locationButton.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    [locationButton setImage:[UIImage imageNamed:@"location_hardware"] forState:UIControlStateNormal];
    [self addSubview:locationButton];
    self.locationButton=locationButton;
    
    UIButton *cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cityButton.frame=CGRectMake(SCREEN_WIDTH-100, 90, 80, 44);
    //  cityButton.backgroundColor=[UIColor redColor];
    [cityButton setTitle:@"选择城市" forState:UIControlStateNormal];
    cityButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //cityButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    cityButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:cityButton];
    self.cityBtn=cityButton;
    
    UILabel *weatherLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-140, 134,120, 20)];
    weatherLabel.textColor=[UIColor whiteColor];
    weatherLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview: weatherLabel];
    self.weatherLabel=weatherLabel;
}
- (void)createBottomButton{
    UIView *addView=[[UIView alloc]init];
    [addView setFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
    [self addSubview:addView];
    
    UITapGestureRecognizer *addViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addViewTap:)];
    addViewTap.delegate = self;
    [addView addGestureRecognizer:addViewTap];
    
    _addBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addBut setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_background_icon_add.png"] forState:UIControlStateNormal];
    _addBut.bounds = (CGRect){CGPointZero, [_addBut backgroundImageForState:UIControlStateNormal].size};
    [_addBut addTarget:self action:@selector(addButClick:) forControlEvents:UIControlEventTouchUpInside];
    _addBut.translatesAutoresizingMaskIntoConstraints = NO;
    [addView addSubview:_addBut];
    NSLayoutConstraint *XConstraint = [NSLayoutConstraint constraintWithItem:_addBut attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:addView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0];
    //Y
    NSLayoutConstraint *YConstraint = [NSLayoutConstraint constraintWithItem:_addBut attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:addView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
    [addView  addConstraint:XConstraint];
    [addView  addConstraint:YConstraint];

}

- (void)addItemWithTitle:(NSString*)title andIcon:(UIImage*)icon andSelectedBlock:(ZBTabBarItemSelectedBlock)block{
    ZBTabBarItemButton *button = [[ZBTabBarItemButton alloc] initWithTitle:title andIcon:icon andSelectedBlock:block];
    
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    self.tabBarItemButton=button;
    [buttons_ addObject:button];
}

- (void)addViewTap:(id)sender{
    [self dismiss];
}

- (void)addButClick:(UIButton *)sender{
    [self dismiss];
}

- (void)dismiss{
    
    if (_isDrop==NO) {
        [self dropAnimation];
    }
    double delayInSeconds = ZBTabBarItemAnimationInterval * buttons_.count-1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [UIView animateWithDuration:0.5f animations:^{
            self.alpha = 0.f;
        } completion:^(BOOL finished) {
            [self.weatherView removeAnimationView];
            [self removeFromSuperview];
          
        }];
    });
}

- (void)Tap:(id)sender{
    if (_isDrop==NO) {
        [self dropAnimation];
    }else{
        [self riseAnimation];
    }
}

- (void)buttonTapped:(ZBTabBarItemButton*)sender{
    [self dismiss];
    double delayInSeconds =ZBTabBarItemAnimationInterval * buttons_.count;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        sender.selectedBlock();
    });
}

- (void)riseAnimation{
    _isDrop=NO;
    NSUInteger columnCount = 3;
    NSUInteger rowCount = buttons_.count / columnCount + (buttons_.count%columnCount>0?1:0);
    
    for (NSUInteger index = 0; index < buttons_.count; index++) {
        ZBTabBarItemButton *button = buttons_[index];
        button.layer.opacity = 0;
        CGRect frame = [self frameForButtonAtIndex:index];
        NSUInteger rowIndex = index / columnCount;
        NSUInteger columnIndex = index % columnCount;
        CGPoint fromPosition = CGPointMake(frame.origin.x + ZBTabBarItemImageHeight / 2.0,frame.origin.y +  (rowCount - rowIndex + 2)*200 + (ZBTabBarItemImageHeight + ZBTabBarItemTitleHeight) / 2.0);
        
        CGPoint toPosition = CGPointMake(frame.origin.x + ZBTabBarItemImageHeight / 2.0,frame.origin.y + (ZBTabBarItemImageHeight + ZBTabBarItemTitleHeight) / 2.0);
        
        double delayInSeconds = rowIndex * columnCount * ZBTabBarItemAnimationInterval;
        
        if (columnIndex == 1) {
            delayInSeconds += ZBTabBarItemAnimationInterval * 0.3;
        }
        else if(columnIndex == 2) {
            delayInSeconds += ZBTabBarItemAnimationInterval * 0.6;
        }
        
        CABasicAnimation *positionAnimation;
        positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:fromPosition];
        positionAnimation.toValue = [NSValue valueWithCGPoint:toPosition];
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.45f :1.2f :0.75f :1.0f];
        positionAnimation.duration = ZBTabBarItemAnimationTime;
        positionAnimation.beginTime = [button.layer convertTime:CACurrentMediaTime() fromLayer:nil] + delayInSeconds;
        [positionAnimation setValue:[NSNumber numberWithUnsignedInteger:index] forKey:ZBTabBarItemRriseAnimationID];
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
        
    }
}

- (void)dropAnimation{
    _isDrop=YES;
    NSUInteger columnCount = 3;
    NSUInteger rowCount = buttons_.count / columnCount + (buttons_.count%columnCount>0?1:0);
    
    for (NSInteger index = buttons_.count-1; index >= 0; index--) {
        ZBTabBarItemButton *button = buttons_[index];
        CGRect frame = [self frameForButtonAtIndex:index];
        NSUInteger rowIndex = (buttons_.count - 1 - index) / columnCount;
        NSUInteger columnIndex = index % columnCount;
        
        CGPoint toPosition = CGPointMake(frame.origin.x + ZBTabBarItemImageHeight / 2.0,frame.origin.y +  (rowCount - rowIndex + 2)*200 + (ZBTabBarItemImageHeight + ZBTabBarItemTitleHeight) / 2.0);
        
        CGPoint fromPosition = CGPointMake(frame.origin.x + ZBTabBarItemImageHeight / 2.0,frame.origin.y + (ZBTabBarItemImageHeight + ZBTabBarItemTitleHeight) / 2.0);
        
        double delayInSeconds = rowIndex * columnCount * ZBTabBarItemAnimationInterval;
        if (columnIndex == 1) {
            delayInSeconds += ZBTabBarItemAnimationInterval*0.3;
        }
        else if(columnIndex == 0) {
            delayInSeconds += ZBTabBarItemAnimationInterval * 0.6;
        }
        
        CABasicAnimation *positionAnimation;
        
        positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:fromPosition];
        positionAnimation.toValue = [NSValue valueWithCGPoint:toPosition];
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.3 :0.5f :1.0f :1.0f];
        positionAnimation.duration = ZBTabBarItemAnimationTime;
        positionAnimation.beginTime = [button.layer convertTime:CACurrentMediaTime() fromLayer:nil] + delayInSeconds;
        [positionAnimation setValue:[NSNumber numberWithUnsignedInteger:index] forKey:ZBTabBarItemDismissAnimationID];
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
        
    }
}

- (void)animationDidStart:(CAAnimation *)anim{
    NSUInteger columnCount = 3;
    if([anim valueForKey:ZBTabBarItemRriseAnimationID]) {
        NSUInteger index = [[anim valueForKey:ZBTabBarItemRriseAnimationID] unsignedIntegerValue];
        UIView *view = buttons_[index];
        CGRect frame = [self frameForButtonAtIndex:index];
        CGPoint toPosition = CGPointMake(frame.origin.x + ZBTabBarItemImageHeight / 2.0,frame.origin.y + (ZBTabBarItemImageHeight + ZBTabBarItemTitleHeight) / 2.0);
        CGFloat toAlpha = 1.0;
        
        view.layer.position = toPosition;
        view.layer.opacity = toAlpha;
        
        //        [_addBut setImage:[UIImage imageNamed:@"tabbar_compose_background_icon_close@2x.png"] forState:UIControlStateNormal];
    }
    else if([anim valueForKey:ZBTabBarItemDismissAnimationID]) {
        NSUInteger index = [[anim valueForKey:ZBTabBarItemDismissAnimationID] unsignedIntegerValue];
        NSUInteger rowIndex = index / columnCount;
        
        UIView *view = buttons_[index];
        CGRect frame = [self frameForButtonAtIndex:index];
        CGPoint toPosition = CGPointMake(frame.origin.x + ZBTabBarItemImageHeight / 2.0,frame.origin.y -  (rowIndex + 2)*200 + (ZBTabBarItemImageHeight + ZBTabBarItemTitleHeight) / 2.0);
        
        view.layer.position = toPosition;
    }
}

- (CGRect)frameForButtonAtIndex:(NSUInteger)index{
    NSUInteger columnCount = 3;
    NSUInteger columnIndex =  index % columnCount;
    
    NSUInteger rowCount = buttons_.count / columnCount + (buttons_.count%columnCount>0?1:0);
    NSUInteger rowIndex = index / columnCount;
    
    CGFloat itemHeight = (ZBTabBarItemImageHeight + ZBTabBarItemTitleHeight) * rowCount + (rowCount > 1?(rowCount - 1) * ZBTabBarItemHorizontalMargin:0);
    CGFloat offsetY = (self.bounds.size.height - itemHeight) / 2.0;
    CGFloat verticalPadding = (self.bounds.size.width - ZBTabBarItemHorizontalMargin * 2 - ZBTabBarItemImageHeight * 3) / 2.0;
    
    CGFloat offsetX = ZBTabBarItemHorizontalMargin;
    offsetX += (ZBTabBarItemImageHeight+ verticalPadding) * columnIndex;
    
    offsetY += (ZBTabBarItemImageHeight + ZBTabBarItemTitleHeight + ZBTabBarItemVerticalPadding) * rowIndex;
    
    return CGRectMake(offsetX, offsetY, ZBTabBarItemImageHeight, (ZBTabBarItemImageHeight+ZBTabBarItemTitleHeight));
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    for (NSUInteger i = 0; i < buttons_.count; i++) {
        ZBTabBarItemButton *button = buttons_[i];
        button.frame = [self frameForButtonAtIndex:i];
    }
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([touch.view isKindOfClass:[ZBTabBarItemButton class]])
    {
        return NO;
    }
    return YES;
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

- (void)show{
   
    UIViewController *appRootViewController;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    appRootViewController = window.rootViewController;
    UIViewController *topViewController = appRootViewController;
    while (topViewController.presentedViewController != nil)
    {
        topViewController = topViewController.presentedViewController;
    }
    if ([topViewController.view viewWithTag:ZBTabBarItemTag]) {
        [[topViewController.view viewWithTag:ZBTabBarItemTag] removeFromSuperview];
    }
    self.frame = topViewController.view.bounds;
    [topViewController.view addSubview:self];
    [self riseAnimation];
}
/*
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
*/
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
