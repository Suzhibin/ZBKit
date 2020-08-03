//
//  PlayCoverViewCell.h
//  ZBKit
//
//  Created by Suzhibin on 2020/6/18.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ListModel;
NS_ASSUME_NONNULL_BEGIN

@interface PlayCoverViewCell : UICollectionViewCell
/**
 根据数据布局，封面图&播放 url
 */
@property (nonatomic,strong)ListModel *listModel;

- (void)layoutWithVideoCoverUrl:(NSString *)videoCoverUrl;
@end

NS_ASSUME_NONNULL_END
