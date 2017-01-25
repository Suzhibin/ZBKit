//
//  ListModel.h
//  ZBKit
//
//  Created by NQ UEC on 17/1/24.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListModel : NSObject
@property (nonatomic,copy)NSString *author;
@property (nonatomic,copy)NSString *date;
@property (nonatomic,copy)NSString *thumb;
@property (nonatomic,copy)NSString *time;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *wid;
@property (nonatomic,copy)NSString *weburl;

-(instancetype)initWithDict:(NSDictionary *)dict;
@end
