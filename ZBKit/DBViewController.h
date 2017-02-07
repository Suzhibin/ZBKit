//
//  DBViewController.h
//  ZBKit
//
//  Created by NQ UEC on 17/2/6.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "BaseViewController.h"
//用于标识不同方法
typedef NS_ENUM(NSInteger,thirdfunctionType) {
    collectionTable,
    userTable
} ;
@interface DBViewController : BaseViewController
@property (nonatomic,assign) thirdfunctionType functionType;
@end
