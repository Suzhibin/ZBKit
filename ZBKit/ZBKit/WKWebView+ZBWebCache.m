//
//  WKWebView+ZBWebCache.m
//  ZBKit
//
//  Created by NQ UEC on 17/3/17.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "WKWebView+ZBWebCache.h"
#import "ZBCacheManager.h"
@implementation WKWebView (ZBWebCache)

- (void)zb_loadRequestWithUrl:(NSString *)urlString{
    
    if ([[ZBCacheManager sharedInstance]diskCacheExistsWithKey:urlString]){
        [[ZBCacheManager sharedInstance]getCacheDataForKey:urlString value:^(NSData *data,NSString *filePath) {
            
        [self loadData:data MIMEType:@"text/plain" characterEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:urlString]];
        
        }];
    }else{
        [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
        
     //   [[ZBCacheManager sharedInstance] storeContent:responseObject forKey:urlString];
    }
}


@end
