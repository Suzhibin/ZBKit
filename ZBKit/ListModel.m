


//
//  ListModel.m
//  ZBKit
//
//  Created by NQ UEC on 17/1/24.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ListModel.h"

@implementation ListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.wid=value;
    }
}

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}


@end
