


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
#pragma mark -

- (nonnull id<NSObject>)diffIdentifier {
    return _wid;
}

- (BOOL)isEqualToDiffableObject:(nullable id<IGListDiffable>)object {
    if (self == object) {
        return YES;
    }

    if (![((NSObject *)object) isKindOfClass:[ListModel class]]) {
        return NO;
    }
    
    return [_wid isEqualToString:((ListModel *)object).wid];
}


@end
