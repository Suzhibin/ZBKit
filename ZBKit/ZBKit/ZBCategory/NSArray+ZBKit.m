
//
//  NSArray+ZBKit.m
//  ZBKit
//
//  Created by NQ UEC on 2017/7/6.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "NSArray+ZBKit.h"

@implementation NSArray (ZBKit)

- (NSArray *)zb_filterArray:(NSArray *)array{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF  in %@",array];
    return [self filteredArrayUsingPredicate:predicate];
}

- (NSArray *)zb_containElement:(NSString *)element{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS [cd] %@ ",element];
    return [self filteredArrayUsingPredicate:predicate];
}

- (NSArray *)zb_beginsWithElement:(NSString *)element{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH [cd] %@ ",element];
    return [self filteredArrayUsingPredicate:predicate];
}

- (NSArray *)zb_endsWithElement:(NSString *)element{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF ENDSWITH [cd] %@ ",element];
    return [self filteredArrayUsingPredicate:predicate];
}

- (NSArray *)zb_selfElement:(NSString *)element{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == %@",element];
    return [self filteredArrayUsingPredicate:predicate];
}

- (NSArray *)zb_betweenAtIndex:(NSUInteger)idx1 index:(NSUInteger)idx2{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF BETWEEN {%d,%d}",idx1,idx2];
    return [self filteredArrayUsingPredicate:predicate];
}

- (NSArray *)zb_greaterToCompare:(NSUInteger)compare{
   
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF > %d",compare];
    return [self filteredArrayUsingPredicate:predicate];
}

- (NSArray *)zb_lessToCompare:(NSUInteger)compare{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF < %d",compare];
    return [self filteredArrayUsingPredicate:predicate];
}


@end


