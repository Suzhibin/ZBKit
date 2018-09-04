//
//  NSObject+Caculator.m
//  ZBKit
//
//  Created by NQ UEC on 2018/5/17.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "NSObject+Caculator.h"
#import <UIKit/UIKit.h>
#import "CalculateMananger.h"
@implementation NSObject (Caculator)
+ (int)makeCaculator:(void (^)(CalculateMananger *))block{
    
    CalculateMananger *mgr=[[CalculateMananger alloc]init];
    block(mgr);
    
    return mgr.result;
}
@end
