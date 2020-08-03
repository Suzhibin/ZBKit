//
//  ZBToast.m
//  ZBKit
//
//  Created by NQ UEC on 2018/1/18.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "ZBToast.h"
//Toast默认停留时间
#define ToastDispalyDuration 1.5f
//Toast到顶端/底端默认距离
#define ToastSpace 100.0f
//Toast背景颜色
#define ToastBackgroundColor [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.75]
@interface ZBToast ()
@property(nonatomic,strong)UIButton *contentView;
@property(nonatomic,assign)CGFloat duration;
@end
@implementation ZBToast
- (id)initWithText:(NSString *)text{
    if (self = [super init]) {
        
        UIFont *font = [UIFont boldSystemFontOfSize:16];
        NSDictionary * dict=[NSDictionary dictionaryWithObject: font forKey:NSFontAttributeName];
        CGRect rect=[text boundingRectWithSize:CGSizeMake(250,CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];

        self.contentView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.contentView.frame=CGRectMake(0, 0, rect.size.width+40, rect.size.height+20);
        self.contentView.titleLabel.font=font;
        self.contentView.titleLabel.numberOfLines = 0;
        self.contentView.titleLabel.textAlignment=NSTextAlignmentCenter;
        [self.contentView setTitle:text forState:UIControlStateNormal];
        self.contentView.layer.cornerRadius = 20.0f;
        self.contentView.backgroundColor = ToastBackgroundColor;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addTarget:self action:@selector(toastTaped:) forControlEvents:UIControlEventTouchDown];
        self.contentView.alpha = 0.0f;
        self.duration = ToastDispalyDuration;
    }
    
    return self;
}

-(void)dismissToast{
    
    [self.contentView removeFromSuperview];
}

-(void)toastTaped:(UIButton *)sender{
    
    [self hideAnimation];
}

-(void)showAnimation{
    [UIView beginAnimations:@"show" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.3];
    self.contentView.alpha = 1.0f;
    [UIView commitAnimations];
}

-(void)hideAnimation{
    [UIView beginAnimations:@"hide" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(dismissToast)];
    [UIView setAnimationDuration:0.3];
    self.contentView.alpha = 0.0f;
    [UIView commitAnimations];
}
+(UIWindow *)window
{
    UIWindow *window =  [[[UIApplication sharedApplication] windows] lastObject];
    if(window && !window.hidden) return window;
    window = [UIApplication sharedApplication].delegate.window;
    return window;
}

- (void)showIn:(UIView *)view{
    self.contentView.center = view.center;
    [view  addSubview:self.contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:self.duration];
}

- (void)showIn:(UIView *)view fromTopOffset:(CGFloat)top color:(UIColor *)color{
    self.contentView.center = CGPointMake(view.center.x, top + self.contentView.frame.size.height/2);
    self.contentView.backgroundColor = color;
    [view  addSubview:self.contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:self.duration];
}

- (void)showIn:(UIView *)view fromBottomOffset:(CGFloat)bottom{
    self.contentView.center = CGPointMake(view.center.x, view.frame.size.height-(bottom + self.contentView.frame.size.height/2));
    [view  addSubview:self.contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:self.duration];
}

#pragma mark-中间显示
+ (void)showCenterWithText:(NSString *)text{
    
    [ZBToast showCenterWithText:text duration:ToastDispalyDuration];
}

+ (void)showCenterWithText:(NSString *)text duration:(CGFloat)duration{
    
    ZBToast *toast = [[ZBToast alloc] initWithText:text];
    toast.duration = duration;
    [toast showIn:[self window]];
}
#pragma mark-上方显示
+ (void)showTopWithText:(NSString *)text{
    
    [ZBToast showTopWithText:text  topOffset:ToastSpace duration:ToastDispalyDuration color:ToastBackgroundColor];
}
+ (void)showTopWithText:(NSString *)text duration:(CGFloat)duration
{
    [ZBToast showTopWithText:text  topOffset:ToastSpace duration:duration color:ToastBackgroundColor];
}
+ (void)showTopWithText:(NSString *)text topOffset:(CGFloat)topOffset{
    [ZBToast showTopWithText:text  topOffset:topOffset duration:ToastDispalyDuration color:ToastBackgroundColor];
}
+ (void)showTopWithText:(NSString *)text topOffset:(CGFloat)topOffset color:(UIColor *)color{
    [ZBToast showTopWithText:text  topOffset:topOffset duration:ToastDispalyDuration color:color];
}
+ (void)showTopWithText:(NSString *)text topOffset:(CGFloat)topOffset duration:(CGFloat)duration color:(UIColor *)color{
    ZBToast *toast = [[ZBToast alloc] initWithText:text];
    toast.duration = duration;
    [toast showIn:[self window] fromTopOffset:topOffset color:color];
}
#pragma mark-下方显示
+ (void)showBottomWithText:(NSString *)text{
    
    [ZBToast showBottomWithText:text  bottomOffset:ToastSpace duration:ToastDispalyDuration];
}
+ (void)showBottomWithText:(NSString *)text duration:(CGFloat)duration
{
    [ZBToast showBottomWithText:text  bottomOffset:ToastSpace duration:duration];
}
+ (void)showBottomWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset{
    [ZBToast showBottomWithText:text  bottomOffset:bottomOffset duration:ToastDispalyDuration];
}

+ (void)showBottomWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset duration:(CGFloat)duration{
    ZBToast *toast = [[ZBToast alloc] initWithText:text];
    toast.duration = duration;
    [toast showIn:[self window] fromBottomOffset:bottomOffset];
}

@end
