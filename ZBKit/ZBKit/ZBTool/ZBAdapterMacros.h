//
//  ZBAdapterMacros.h
//  ZBKit
//
//  Created by NQ UEC on 2017/10/30.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#ifndef ZBAdapterMacros_h
#define ZBAdapterMacros_h
//屏幕宽
#define ZB_SCREEN_WIDTH   ([UIScreen mainScreen].bounds.size.width)
//屏幕高
#define ZB_SCREEN_HEIGHT  ([UIScreen mainScreen].bounds.size.height)

#define ZB_iPhone5W 320.0
#define ZB_iPhone5H 568.0
// 计算比例
// x比例 1.293750 在iPhone7的屏幕上
#define ZB_ScaleX ZB_SCREEN_WIDTH / ZB_iPhone5W
// y比例 1.295775
#define ZB_ScaleY ZB_SCREEN_HEIGHT / ZB_iPhone5H
// X坐标
#define ZBLineX(l) l*ZB_ScaleX
// Y坐标
#define ZBLineY(l) l*ZB_ScaleY
// 字体
#define ZBFont(x) [UIFont systemFontOfSize:x*ZB_ScaleX]


#endif /* ZBAdapterMacros_h */
