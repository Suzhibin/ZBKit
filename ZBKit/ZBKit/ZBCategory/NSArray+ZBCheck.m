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
@implementation NSMutableArray (ZBCheck)

- (void)addObjectCheck:(id)anObject
{
    if (anObject != nil && [anObject isKindOfClass:[NSNull class]] == NO) {
        [self addObject:anObject];
    } else {
        NSLog(@"数组元素为:%@ 堆栈:%@",anObject, [NSThread callStackSymbols]);
        
    }
}
- (void)insertObjectCheck:(id)anObject atIndex:(NSUInteger)index
{
    if (index <= self.count && anObject != nil && [anObject isKindOfClass:[NSNull class]] == NO) {
        [self insertObject:anObject atIndex:index];
    } else {
        NSLog(@"%@", [NSThread callStackSymbols]);
        
    }
}

- (void)removeObjectAtIndexCheck:(NSUInteger)index
{
    if (index < self.count) {
        [self removeObjectAtIndex:index];
    } else {
        NSLog(@"数组越界:%ld 堆栈:%@", index,[NSThread callStackSymbols]);
        
    }
}
- (void)replaceObjectAtIndexCheck:(NSUInteger)index withObject:(id)anObject
{
    if (index < self.count && anObject != nil && [anObject isKindOfClass:[NSNull class]] == NO) {
        [self replaceObjectAtIndex:index withObject:anObject];
    } else {
        NSLog(@"%@", [NSThread callStackSymbols]);
        
    }
}
@end
