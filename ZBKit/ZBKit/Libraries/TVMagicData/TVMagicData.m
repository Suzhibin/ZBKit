//
//  TVMagicData.m
//  Budejie
//
//  Created by NQ UEC on 2017/7/4.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "TVMagicData.h"
@interface TVMagicData()

@property (nonatomic, strong) NSMutableDictionary *dataInfo;

@end
@implementation TVMagicData

+ (instancetype)sharedInstance {
    static TVMagicData *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        sharedManager.dataInfo = [[NSMutableDictionary alloc] init];
    });
    return sharedManager;
}

- (void)savePageInfo:(NSArray *)infoList menuId:(NSString *)menuId {
    if (menuId) {
        [_dataInfo setObject:[NSArray arrayWithArray:infoList] forKey:menuId];
        //NSLog(@"_dataInfo:%@",_dataInfo);
    }
}

- (NSArray *)pageInfoWithMenuId:(NSString *)menuId {
    return [_dataInfo objectForKey:menuId];
}
- (void)clearPageInfo
{
    [_dataInfo removeAllObjects];
}
@end
