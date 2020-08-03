//
//  UIImageView+ZBReachability.m
//  ZBKit
//
//  Created by NQ UEC on 2017/10/30.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "UIImageView+ZBReachability.h"
#import <AFNetworkReachabilityManager.h>
#import <UIImageView+WebCache.h>
@implementation UIImageView (ZBReachability)

- (void)zb_original:(NSString *)original thumbnail:(NSString *)thumbnail placeholder:(NSString *)placeholder{
    
    UIImage *placeholderImage = [UIImage imageNamed:placeholder];
    
    // 从内存\沙盒缓存中获得原图，
    UIImage *originalImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:original];
    if (originalImage) { // 如果内存\沙盒缓存有原图，那么就直接显示原图（不管现在是什么网络状态）
        self.image = originalImage;
    } else { // 内存\沙盒缓存没有原图
        AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
        if (mgr.isReachableViaWiFi) { // 在使用Wifi, 下载原图
            [self sd_setImageWithURL:[NSURL URLWithString:original] placeholderImage:placeholderImage];
        } else if (mgr.isReachableViaWWAN) { // 在使用手机自带网络
            [self sd_setImageWithURL:[NSURL URLWithString:thumbnail] placeholderImage:placeholderImage];
        } else { // 没有网络
            UIImage *thumbnailImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:thumbnail];
            if (thumbnailImage) { // 内存\沙盒缓存中有小图
                self.image = thumbnailImage;
            } else { // 处理离线状态，而且有没有缓存时的情况
                self.image = placeholderImage;
            }
        }
    }
}

@end
