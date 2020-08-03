//
//  ZBToastView.h
//  ZBKit
//
//  Created by NQ UEC on 2018/5/24.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ZBToastView : NSObject
- (ZBToastView *(^)(NSString *))textString;

- (ZBToastView *(^)(UIColor *))backgroundColor;

- (ZBToastView *(^)(UIColor *))textColor;
@end

@interface ZBToastView (ChainFunction)

@property (nonatomic, strong, readonly) ZBToastView *toastView;

@end
