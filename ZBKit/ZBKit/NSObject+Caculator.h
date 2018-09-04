//
//  NSObject+Caculator.h
//  ZBKit
//
//  Created by NQ UEC on 2018/5/17.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CalculateMananger;
@interface NSObject (Caculator)
+ (int)makeCaculator:(void(^)(CalculateMananger *make))CalculateMananger;


@end
