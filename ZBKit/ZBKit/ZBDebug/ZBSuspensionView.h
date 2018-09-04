//
//  ZBSuspensionView.h
//  ZBKit
//
//  Created by NQ UEC on 2018/4/23.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZBSuspensionViewDelegate <NSObject>

- (void)suspensionViewClick;
@end

@interface ZBSuspensionView : UIView

@property (nonatomic,copy)NSString *title;

@property (nonatomic, weak) id<ZBSuspensionViewDelegate> delegate;

+ (instancetype)defaultSuspensionView;

- (void)show;

- (void)hide;
@end
