//
//  ClearCacheViewController.m
//  ZBKit
//
//  Created by NQ UEC on 17/1/25.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ClearCacheViewController.h"
#import "ZBKit.h"
#import "APIConstants.h"
#import <SDImageCache.h>
@interface ClearCacheViewController ()
@property (nonatomic,copy)NSString *ZBKitCacheStr;
@end

@implementation ClearCacheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    float system=  [[ZBCacheManager sharedManager]diskSystemSpace];
    NSLog(@"磁盘总空间:%@",[[ZBCacheManager sharedManager] fileUnitWithSize:system]);
    //================================================
    float freeSystem = [[ZBCacheManager sharedManager]diskFreeSystemSpace];
    NSLog(@"可用空间:%@",[[ZBCacheManager sharedManager] fileUnitWithSize:freeSystem]);
    //================================================
    float TakeupSystem = system-freeSystem;
    NSLog(@"已经使用空间:%@",[[ZBCacheManager sharedManager] fileUnitWithSize:TakeupSystem]);
    //================================================
    NSLog(@"应用名字:%@",[[GlobalSettingsTool sharedSetting] appBundleName]);
    //================================================
    float ZBKit=[[ZBCacheManager sharedManager ]getFileSizeWithpath:[[ZBCacheManager sharedManager]homePath]];
    NSString *ZBKitSize=[[ZBCacheManager sharedManager] fileUnitWithSize:ZBKit];
    NSLog(@"ZBkit应用大小:%@",ZBKitSize);
    //================================================
    
    //得到沙盒cache文件夹
    NSString *cachePath= [[ZBCacheManager sharedManager]cachesPath];
    NSString *Snapshots=@"Snapshots";
    //拼接cache文件夹下的 Snapshots 文件夹
     NSString *path=[NSString stringWithFormat:@"%@/%@",cachePath,Snapshots];
    
    float cacheSize=[[ZBCacheManager sharedManager]getCacheSize];//json缓存文件大小
    float imageSize = [[SDImageCache sharedImageCache]getSize];//图片缓存大小
    float SnapshotsSize=[[ZBCacheManager sharedManager]getFileSizeWithpath:path];//某个沙盒路径文件大小
    float AppCacheSize=cacheSize+imageSize+SnapshotsSize;
    AppCacheSize=AppCacheSize/1000.0/1000.0;
    self.ZBKitCacheStr=[NSString stringWithFormat:@"%.2fM",AppCacheSize];
    NSLog(@"ZBkit缓存大小:%@",self.ZBKitCacheStr);
    //================================================
    NSString *ZBkitStr=[NSString stringWithFormat:@"应用:%@(缓存:%@)",ZBKitSize,self.ZBKitCacheStr];

    //================================================
    float otherSystem=TakeupSystem-ZBKit;
    NSLog(@"其他应用空间:%@",[[ZBCacheManager sharedManager] fileUnitWithSize:otherSystem]);
    //================================================
    //[[ZBCacheManager sharedManager]getFileAttributes:menu_URL];
    
    NSArray *titleArray=[NSArray arrayWithObjects:@"总空间",[[GlobalSettingsTool sharedSetting] appBundleName],@"其他",@"可用",nil];
    for (int i = 0; i<titleArray.count; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20 ,120+50*i, 60, 20)];
        label.text=[titleArray objectAtIndex:i];
        label.textAlignment=NSTextAlignmentCenter;
        label.backgroundColor=randomColor;
        [self.view addSubview:label];
        
    }
    //================================================
    
    NSArray *sizeArray=[NSArray arrayWithObjects:[[ZBCacheManager sharedManager] fileUnitWithSize:system],ZBkitStr,[[ZBCacheManager sharedManager] fileUnitWithSize:otherSystem],[[ZBCacheManager sharedManager] fileUnitWithSize:freeSystem],nil];
    for (int i = 0; i<sizeArray.count; i++) {
        UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(100,120+50*i, 220, 20)];
        label1.text=[sizeArray objectAtIndex:i];
        label1.textAlignment=NSTextAlignmentLeft;
        [self.view addSubview:label1];
        
    }
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(100, 350, 100, 40);
    [button setTitle:@"清除缓存" forState:UIControlStateNormal];
    button.backgroundColor=[UIColor brownColor];

    button.titleLabel.textAlignment=NSTextAlignmentCenter;
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    [button addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)btnClicked
{
    //清除json缓存后的操作
    [[ZBCacheManager sharedManager]clearCacheOnOperation:^{
        //清除图片缓存
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];
        //清除系统内存文件
        [[NSURLCache sharedURLCache]removeAllCachedResponses];
        
        [self alertTitle:@"清除缓存" andMessage:self.ZBKitCacheStr];
        
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
