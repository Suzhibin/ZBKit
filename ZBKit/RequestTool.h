//
//  RequestTool.h
//  ZBNetworkingDemo
//
//  Created by Suzhibin on 2020/6/2.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#define server_URL @"http://api.dotaly.com"
#define list_URL @"/lol/api/v1/authors"

#define details_URL @"/lol/api/v1/shipin/latest"

#define m4_URL @"http://m4.pc6.com"

NS_ASSUME_NONNULL_BEGIN

@interface RequestTool : NSObject
+ (void)setupPublicParameters;
@end

NS_ASSUME_NONNULL_END
