//
//  NSArray+ZBCheck.m
//  ZBNews
//
//  Created by NQ UEC on 2018/6/12.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "NSArray+ZBCheck.h"

@implementation NSArray (ZBCheck)
- (id)objectAtIndexCheck:(NSUInteger)index{
    if (index >= [self count]) {
          NSLog(@"数组 越界");
        return nil;
    }
    
    id value = [self objectAtIndex:index];
    if (value == [NSNull null]) {
        NSLog(@"数组value= NSNull");
        return nil;
    }
    return value;
} 
@end
