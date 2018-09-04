//
//  ZBSandboxViewController.h
//  ZBKit
//
//  Created by NQ UEC on 2018/4/25.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBFileModel.h"
@class ZBDebug;
@interface ZBSandboxViewController : UIViewController
@property (nonatomic, assign, getter=isHomeDirectory) BOOL homeDirectory;
@property (nonatomic, strong) ZBFileModel *model;
@end
