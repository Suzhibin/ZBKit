//
//  DetailsViewController.h
//  ZBKit
//
//  Created by NQ UEC on 17/1/23.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "BaseViewController.h"

//用于标识不同方法
typedef NS_ENUM(NSInteger,functionType) {
    Details,
    Advertise
} ;
@interface DetailsViewController : BaseViewController
@property (nonatomic,assign) functionType functionType;
@property (nonatomic, copy) NSString *url;

@end
