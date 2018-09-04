//
//  ZBToastView.m
//  ZBKit
//
//  Created by NQ UEC on 2018/5/24.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "ZBToastView.h"
#import <objc/runtime.h>
@interface ZBToastView ()
@property(nonatomic,strong)UILabel *textLabel;

@end
@implementation ZBToastView
- (id)init{
    if (self = [super init]) {
        
        //        UIFont *font = [UIFont boldSystemFontOfSize:16];
        //        NSDictionary * dict=[NSDictionary dictionaryWithObject: font forKey:NSFontAttributeName];
        //        CGRect rect=[text boundingRectWithSize:CGSizeMake(250,CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,100,30)];
        
        textLabel.textColor = [UIColor whiteColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        //  textLabel.font = font;
        textLabel.numberOfLines = 0;
        self.textLabel=textLabel;
        
    }
    return self;
}

- (ZBToastView *(^)(NSString *))textString{
    return ^ZBToastView *(NSString * value){
        self.textLabel.text=value;
        [self showIn:[self window]];
        return self;
    };
}
- (ZBToastView *(^)(UIColor *))backgroundColor{
    return ^ZBToastView *(UIColor * value){
        self.textLabel.backgroundColor =value;
        [self showIn:[self window]];
        return self;
    };
}
- (ZBToastView *(^)(UIColor *))textColor{
    return ^ZBToastView *(UIColor * value){
        self.textLabel.textColor =value;
        [self showIn:[self window]];
        return self;
    };
}

- (void)showIn:(UIView *)view{
    self.textLabel.center = view.center;
    [view addSubview:self.textLabel];
}
- (UIWindow *)window{
    UIWindow *window =  [[[UIApplication sharedApplication] windows] lastObject];
    if(window && !window.hidden) return window;
    window = [UIApplication sharedApplication].delegate.window;
    return window;
}
@end

@implementation ZBToastView (ChainFunction)
- (ZBToastView *)toastView{
    ZBToastView *toast = objc_getAssociatedObject(self, _cmd);
    if (!toast) {
        toast = [ZBToastView new];
        objc_setAssociatedObject(self, _cmd, toast, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return toast;
}


@end
