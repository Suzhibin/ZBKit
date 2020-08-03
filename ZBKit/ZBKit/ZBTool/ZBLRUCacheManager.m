//
//  ZBLRUCacheManager.m
//  ZBKit
//
//  Created by Suzhibin on 2020/7/31.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import "ZBLRUCacheManager.h"
@interface ZBLRUCacheManager ()
@property (nonatomic ,strong) NSMutableArray *lruArray;
@end
@implementation ZBLRUCacheManager
+ (ZBLRUCacheManager *)sharedInstance{
    static ZBLRUCacheManager *LRUInstance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        LRUInstance = [[ZBLRUCacheManager alloc] init];
    });
    return LRUInstance;
}
- (id)init{
    self = [super init];
    if (self) {
        self.lruArray=[[NSMutableArray alloc]init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backgroundCleanCacheaa) name:NSExtensionHostDidEnterBackgroundNotification object:nil];
    }
    return self;
}
- (void)addObj:(id)obj{
    [self.lruArray addObject:obj];
}
- (void)getCacheObj:(id)obj{
    if ([self.lruArray containsObject:obj]) {
        [self.lruArray removeObject:obj];
        [self.lruArray addObject:obj];
    }
}
- (void)backgroundCleanCacheaa{
    if (self.lruArray.count>20) {
       [self.lruArray removeObjectsInRange:NSMakeRange(0, 10)];
    }
}
@end
