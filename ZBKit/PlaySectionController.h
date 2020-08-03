//
//  PlaySectionController.h
//  ZBKit
//
//  Created by Suzhibin on 2020/6/18.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import "IGListSectionController.h"
#import "ListModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol PlaySectionControllerDelegate <NSObject>
- (void)playSectiondidSelectItemAtIndex:(NSInteger)index model:(ListModel *)model;
@end
@interface PlaySectionController : IGListSectionController
@property(nonatomic,weak)id<PlaySectionControllerDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
