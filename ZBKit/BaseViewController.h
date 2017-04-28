//
//  BaseViewController.h
//  ZBNews
//
//  Created by NQ UEC on 16/11/18.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBConstants.h"
#import "ZBKit.h"
#import "APIConstants.h"

#define IMAGE1   @"http://img04.tooopen.com/images/20130701/tooopen_10055061.jpg"

#define IMAGE2   @"http://img06.tooopen.com/images/20161214/tooopen_sy_190570171299.jpg"

#define IMAGE3   @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1488532000714&di=854b7b39d266a9cbd43d684995040e7f&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fforum%2Fw%253D580%2Fsign%3D195f5319ddc451daf6f60ce386fc52a5%2Febc4b74543a98226cd76e0608a82b9014b90ebc6.jpg"

@interface BaseViewController : UIViewController
//title 设置btn的标题; selector点击btn实现的方法; isLeft 标记btn的位置
- (void)addItemWithTitle:(NSString *)title selector:(SEL)selector location:(BOOL)isLeft;
- (void)alertTitle:(NSString *)title andMessage:(NSString *)message;
@end
