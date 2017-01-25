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

@property (nonatomic,copy)NSString *path;
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
    NSLog(@"ZBkit应用大小:%@",[self getZBKitSize]);
    //================================================

    NSLog(@"ZBkit缓存大小:%@",[self getCacheSize]);
    //================================================
    float otherSystem=TakeupSystem-ZBKit;
    NSLog(@"其他应用空间:%@",[[ZBCacheManager sharedManager] fileUnitWithSize:otherSystem]);
    //================================================
    //[[ZBCacheManager sharedManager]getFileAttributes:menu_URL];
    
    NSArray *titleArray=[NSArray arrayWithObjects:@"总空间",[[GlobalSettingsTool sharedSetting] appBundleName],@"缓存",@"其他",@"可用",nil];
    for (int i = 0; i<titleArray.count; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20 ,120+50*i, 60, 20)];
        label.text=[titleArray objectAtIndex:i];
        label.textAlignment=NSTextAlignmentCenter;
        label.backgroundColor=randomColor;
        [self.view addSubview:label];
        
    }
    //================================================
    
    NSArray *sizeArray=[NSArray arrayWithObjects:[[ZBCacheManager sharedManager] fileUnitWithSize:system],[self getZBKitSize],[self getCacheSize],[[ZBCacheManager sharedManager] fileUnitWithSize:otherSystem],[[ZBCacheManager sharedManager] fileUnitWithSize:freeSystem],nil];
    for (int i = 0; i<sizeArray.count; i++) {
        UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(100,120+50*i, 220, 20)];
        label1.tag=3000+i;
        label1.text=[sizeArray objectAtIndex:i];
        label1.textAlignment=NSTextAlignmentLeft;
        [self.view addSubview:label1];
        
    }
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(100, 370, 100, 40);
    [button setTitle:@"清除缓存" forState:UIControlStateNormal];
    button.backgroundColor=[UIColor brownColor];

    button.titleLabel.textAlignment=NSTextAlignmentCenter;
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    [button addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)btnClicked
{
    [self alertTitle:@"清除缓存" andMessage:[self getCacheSize]];
    
    //清除json缓存后的操作
    [[ZBCacheManager sharedManager]clearCacheOnOperation:^{
        //清除图片缓存
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];
        //清除沙盒某个文件夹
        [[ZBCacheManager sharedManager]clearDiskWithpath:self.path];
        //清除系统内存文件
        [[NSURLCache sharedURLCache]removeAllCachedResponses];
       
      
        UILabel *label1 = (UILabel *)[self.view viewWithTag:3001];
        label1.text=[self getZBKitSize];
        UILabel *label2 = (UILabel *)[self.view viewWithTag:3002];
        label2.text=[self getCacheSize];
    }];
 
}
- (NSString *)getZBKitSize{
    float ZBKit=[[ZBCacheManager sharedManager ]getFileSizeWithpath:[[ZBCacheManager sharedManager]homePath]];
    NSString *ZBKitSize=[[ZBCacheManager sharedManager] fileUnitWithSize:ZBKit];
    return ZBKitSize;
}

- (NSString *)getCacheSize{
    //得到沙盒cache文件夹
    NSString *cachePath= [[ZBCacheManager sharedManager]cachesPath];
    NSString *Snapshots=@"Snapshots";
    //拼接cache文件夹下的 Snapshots 文件夹
    self.path=[NSString stringWithFormat:@"%@/%@",cachePath,Snapshots];
    
    float cacheSize=[[ZBCacheManager sharedManager]getCacheSize];//json缓存文件大小
    float imageSize = [[SDImageCache sharedImageCache]getSize];//图片缓存大小
    float SnapshotsSize=[[ZBCacheManager sharedManager]getFileSizeWithpath:self.path];//某个沙盒路径文件大小
    float AppCacheSize=cacheSize+imageSize+SnapshotsSize;
    AppCacheSize=AppCacheSize/1000.0/1000.0;
    return [NSString stringWithFormat:@"%.2fM",AppCacheSize];
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
