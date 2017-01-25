//
//  MenuViewController.h
//  ZBKit
//
//  Created by NQ UEC on 17/1/24.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "BaseViewController.h"
//用于标识不同方法的请求
typedef NS_ENUM(NSInteger,functionType) {
    
    AFNetworking,
    sessionblock ,
    sessiondelegate
    
} ;
@interface MenuViewController : BaseViewController
@property (nonatomic,assign) functionType functionType;
@end
