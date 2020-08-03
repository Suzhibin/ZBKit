//
//  NSArray+ZBCheck.h
//  ZBNews
//
//  Created by NQ UEC on 2018/6/12.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (ZBCheck)
/*
 @method objectAtIndexCheck:
 @abstract 检查是否越界和NSNull如果是返回nil
 @result 返回对象
 */
- (id)objectAtIndexCheck:(NSUInteger)index;
@end
@interface NSMutableArray (ZBCheck)

- (void)addObjectCheck:(id)anObject;

- (void)insertObjectCheck:(id)anObject atIndex:(NSUInteger)index;

- (void)removeObjectAtIndexCheck:(NSUInteger)index;

- (void)replaceObjectAtIndexCheck:(NSUInteger)index withObject:(id)anObject;


@end
