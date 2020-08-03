//
//  ASMagnifierManger.h
//  ASMagnifierMangerDemo
//
//  Created by OneForAll on 2018/1/29.
//  Copyright © 2018年 OneForAll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ASMagnifierManger : NSObject
/* 放大镜的宽度  - 默认90*/
@property (nonatomic, assign) float magnifierWidth;
/* 放大镜放大倍数 -默认1.5  必须大于1*/
@property (nonatomic, assign) float magnification;

//+ (instancetype)sharedInstance;

- (void)magnifier_touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event view:(UIView *)view;
- (void)magnifier_touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event view:(UIView *)view;
- (void)magnifier_touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
@end
