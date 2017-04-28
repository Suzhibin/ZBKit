//
//  ZBCityViewController.h
//  ZBKit
//
//  Created by NQ UEC on 2017/4/26.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ZBCityGroup : NSObject
@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, copy) NSString *title;

@end
typedef void(^ZBCityBlock)(NSString *cityName);
@interface ZBCityViewController : UIViewController
@property(nonatomic,copy)NSString *currentCity;
//block传值
@property(nonatomic,copy)ZBCityBlock cityBlock;
@end
