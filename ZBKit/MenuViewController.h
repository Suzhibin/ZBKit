//
//  MenuViewController.h
//  ZBKit
//
//  Created by Suzhibin on 2020/6/17.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol MenuViewControllerDelegate <NSObject>

- (void)didSelectItemAtIndex:(NSInteger)index;
@end
@interface MenuViewController : UIViewController
@property (nonatomic, weak)id<MenuViewControllerDelegate>delegate;
@property (nonatomic, strong)NSArray *dataArray;
@end

NS_ASSUME_NONNULL_END
