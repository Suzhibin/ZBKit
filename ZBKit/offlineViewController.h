//
//  offlineViewController.h
//  ZBKit
//
//  Created by NQ UEC on 17/1/24.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "BaseViewController.h"
@protocol offlineDelegate <NSObject>

- (void)downloadWithArray:(NSMutableArray *)offlineArray;
@end
@interface offlineViewController : BaseViewController
@property (nonatomic,weak)id<offlineDelegate>delegate;
@end
