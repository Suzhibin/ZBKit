//
//  ZBDebug.h
//  ZBKit
//
//  Created by NQ UEC on 2018/4/24.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBDebug : NSObject

+ (instancetype)sharedInstance;

- (void)enable;
- (void)close;
@end
