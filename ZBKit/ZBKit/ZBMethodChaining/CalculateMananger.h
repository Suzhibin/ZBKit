//
//  CalculateMananger.h
//  ZBKit
//
//  Created by NQ UEC on 2018/5/17.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculateMananger : NSObject

@property (nonatomic,assign) int result;

- (CalculateMananger *(^)(int))add;

- (CalculateMananger *(^)(int))sub;
//- (CalculateMananger *(^)(int))muilt;
//- (CalculateMananger *(^)(int))divide;

@end
