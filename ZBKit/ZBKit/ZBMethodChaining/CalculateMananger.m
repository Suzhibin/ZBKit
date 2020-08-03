//
//  CalculateMananger.m
//  ZBKit
//
//  Created by NQ UEC on 2018/5/17.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "CalculateMananger.h"

@implementation CalculateMananger
- (CalculateMananger *(^)(int))add{
    return ^CalculateMananger *(int value){
        _result+=value;
        return self;
    };
}
- (CalculateMananger *(^)(int))sub{
    return ^CalculateMananger *(int value){
        _result-=value;
        return self;
    };
}
@end
