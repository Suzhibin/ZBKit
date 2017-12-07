//
//  MenuModel.m
//  ZBKit
//
//  Created by NQ UEC on 17/1/24.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "MenuModel.h"

@implementation MenuModel
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    //  NSLog(@"undefinedKey:%@",key);
    if ([key isEqualToString:@"id"]) {
        self.wid=value;
    }
}
@end
