//
//  NSArray+ZBKit.h
//  ZBKit
//
//  Created by NQ UEC on 2017/7/6.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (ZBKit)

/**
 俩个数组相同的值 返回得数组

 @param array 要比较的数组
 @return 过滤后的数组
 */
- (NSArray *)zb_filterArray:(NSArray *)array;
/**
 返回包含某个元素的数组

 @param element 元素
 @return 过滤后的数组
 */
- (NSArray *)zb_containElement:(NSString *)element;

/**
 已某个元素的开头数组
 
 @param element 元素
 @return 过滤后的数组
 */
- (NSArray *)zb_beginsWithElement:(NSString *)element;

/**
 已某个元素的结尾数组
 
 @param element 元素
 @return 过滤后的数组
 */
- (NSArray *)zb_endsWithElement:(NSString *)element;

/**
 含有某个完整元素的数组
 
 @param element 元素
 @return 过滤后的数组
 */
- (NSArray *)zb_selfElement:(NSString *)element;

/**
 取俩个数值范围之间的数组
 
 @param idx1 元素
 @param idx2 元素
 @return 过滤后的数组
 */
- (NSArray *)zb_betweenAtIndex:(NSUInteger)idx1 index:(NSUInteger)idx2;

/**
 比某个元素大的数组
 
 @param compare 元素
 @return 过滤后的数组
 */
- (NSArray *)zb_greaterToCompare:(NSUInteger)compare;

/**
  比某个元素小的数组
 
 @param compare 元素
 @return 过滤后的数组
 */
- (NSArray *)zb_lessToCompare:(NSUInteger)compare;
@end
