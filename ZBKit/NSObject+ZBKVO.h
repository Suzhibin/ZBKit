//
//  NSObject+ZBKVO.h
//  ZBKit
//
//  Created by NQ UEC on 2018/9/18.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ZBKVO)
- (void)zb_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;
@end
