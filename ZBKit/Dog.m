
//
//  Dog.m
//  ZBKit
//
//  Created by NQ UEC on 2018/9/17.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "Dog.h"

@implementation Dog
-(instancetype)init{
    if (self=[super init]) {
        self.arr=[[NSMutableArray alloc]init];
    }
    return self;
}
//默认自动模式 默认yes
//+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key{
//    return NO;
//}
//+ (NSSet <NSString *>*)keyPathsForValuesAffectingValueForKey:(NSString *)key{
//   NSSet *keyPaths =[super keyPathsForValuesAffectingValueForKey:key];
//    
//    NSArray *arr=@[@"name",@"age"];
//    keyPaths=[keyPaths setByAddingObjectsFromArray:arr];
//    return keyPaths;
//}
@end
