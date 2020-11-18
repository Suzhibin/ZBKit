//
//  PlayCoverViewCell.m
//  ZBKit
//
//  Created by Suzhibin on 2020/6/18.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import "PlayCoverViewCell.h"
#import "ZBKit.h"
#import "ListModel.h"
@interface PlayCoverViewCell ()
@property (nonatomic, strong, readwrite) UIImageView *coverView;
@property (nonatomic, strong, readwrite) UILabel *title;
@end

@implementation PlayCoverViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:({
            _title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 20)];
            _title;
        })];
        [self addSubview:({
            _coverView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, frame.size.width, frame.size.height-20)];
            _coverView;
        })];
        
    }
    return self;
}
- (void)setListModel:(ListModel *)listModel{
    _listModel=listModel;
    _title.text=listModel.title;

    [_coverView zb_original:listModel.thumb thumbnail:listModel.thumb placeholder:[NSBundle zb_placeholder]];
    /**
     NSString *cachePath= [[ZBCacheManager sharedInstance]cachesPath];
           //得到沙盒cache文件夹下的 SDWebimage 存储路径
           NSString *sdImage=@"default/com.hackemist.SDWebImageCache.default";
        NSString *imagePath=[NSString stringWithFormat:@"%@/%@",cachePath,sdImage];
        [[ZBCacheManager sharedInstance]getCacheDataForKey:listModel.thumb path:imagePath value:^(NSData *data,NSString *filePath) {
            NSLog(@"aaa:%@",[[ZBCacheManager sharedInstance] getDiskFileAttributesWithFilePath:filePath]);
        }];
     */
}
- (void)layoutWithVideoCoverUrl:(NSString *)videoCoverUrl{
//    _coverView.image = [UIImage imageNamed:videoCoverUrl];
   
}

@end
