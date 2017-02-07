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
    
    self.title=@"缓存清理";
    
    float system=  [[ZBCacheManager sharedInstance]diskSystemSpace];
    NSLog(@"磁盘总空间:%@",[[ZBCacheManager sharedInstance] fileUnitWithSize:system]);
    
    //================================================
    
    float freeSystem = [[ZBCacheManager sharedInstance]diskFreeSystemSpace];
    NSLog(@"可用空间:%@",[[ZBCacheManager sharedInstance] fileUnitWithSize:freeSystem]);
    
    //================================================
    
    float TakeupSystem = system-freeSystem;
    NSLog(@"已经使用空间:%@",[[ZBCacheManager sharedInstance] fileUnitWithSize:TakeupSystem]);
    
    //================================================
    
    NSLog(@"应用名字:%@",[[ZBGlobalSettingsTool sharedInstance] appBundleName]);
    
    //================================================
   
    NSLog(@"ZBkit应用大小:%@",[self getZBKitSize]);
    
    //================================================
    
    NSLog(@"ZBkit缓存大小:%@",[self getAllCacheSize]);
    
    //================================================
    
    float ZBKit=[[ZBCacheManager sharedInstance ]getFileSizeWithpath:[[ZBCacheManager sharedInstance]homePath]];
    float otherSystem=TakeupSystem-ZBKit; //已经使用空间 减去本应用所占空间
    NSLog(@"其他应用空间:%@",[[ZBCacheManager sharedInstance] fileUnitWithSize:otherSystem]);
    
    //================================================
    //[[ZBCacheManager sharedManager]getFileAttributes:menu_URL];
    
    NSArray *colorArr=@[[UIColor redColor],[UIColor grayColor],[UIColor greenColor]];
    
    NSString *zbkitSize=[NSString stringWithFormat:@"%@(%@)",[self getZBKitSize],[self getAllCacheSize]];
    
    NSArray *sizeArray=[NSArray arrayWithObjects:zbkitSize,[[ZBCacheManager sharedInstance] fileUnitWithSize:otherSystem],[[ZBCacheManager sharedInstance] fileUnitWithSize:freeSystem],nil];
    
    ZBChart *ring = [[ZBChart alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_WIDTH)];
  
    ring.backgroundColor = [UIColor whiteColor];

    ring.valueDataArr = sizeArray;
    
    ring.ringWidth = 55.0;
    
    ring.fillColorArray = colorArr;

    [ring showAnimation];
    
    [self.view addSubview:ring];
    
    UILabel * totalLabel=[[UILabel alloc]initWithFrame:CGRectMake(155 ,160, 100, 100)];
    totalLabel.text=[NSString stringWithFormat:@"磁盘总空间\n%@",[[ZBCacheManager sharedInstance] fileUnitWithSize:system]];
    totalLabel.textAlignment=NSTextAlignmentCenter;
    totalLabel.numberOfLines=0;
    [ring addSubview:totalLabel];

    //================================================
    NSString *zbkitStr=[NSString stringWithFormat:@"%@%@",[[ZBGlobalSettingsTool sharedInstance] appBundleName],@"(缓存)"];
    NSArray *titleArray=[NSArray arrayWithObjects:zbkitStr,@"其他",@"可用",nil];
    for (int i = 0; i<titleArray.count; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20+140*i ,410, 100, 20)];
        label.text=[titleArray objectAtIndex:i];
        label.textAlignment=NSTextAlignmentCenter;
        label.backgroundColor=[colorArr objectAtIndex:i];
        [self.view addSubview:label];
        
    }
    //================================================
    
    
    for (int i = 0; i<sizeArray.count; i++) {
        UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(20+140*i,430, 100, 20)];
        label1.tag=3000+i;
        label1.text=[sizeArray objectAtIndex:i];
        label1.font=[UIFont systemFontOfSize:12];
        label1.textAlignment=NSTextAlignmentCenter;
        [self.view addSubview:label1];
        
    }
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(40, SCREEN_HEIGHT-150, SCREEN_WIDTH-80, 40);
    [button setTitle:@"清除缓存" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor=[UIColor colorWithRed:0.49 green:0.83 blue:0.98 alpha:1.00];
    
    button.titleLabel.textAlignment=NSTextAlignmentCenter;
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    [button addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)btnClicked
{
    [self alertTitle:@"清除缓存" andMessage:[self getAllCacheSize]];
    
    //清除json缓存后的操作
    [[ZBCacheManager sharedInstance]clearCacheOnOperation:^{
        //清除图片缓存
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];
        //清除沙盒某个文件夹
        [[ZBCacheManager sharedInstance]clearDiskWithpath:self.path];
        //清除系统内存文件
        [[NSURLCache sharedURLCache]removeAllCachedResponses];
       
        UILabel *label1 = (UILabel *)[self.view viewWithTag:3000];
        NSString *zbkitSize=[NSString stringWithFormat:@"%@(%@)",[self getZBKitSize],[self getAllCacheSize]];
        label1.text=zbkitSize;
    }];
 
}
- (NSString *)getZBKitSize{
    float ZBKit=[[ZBCacheManager sharedInstance ]getFileSizeWithpath:[[ZBCacheManager sharedInstance]homePath]];
    NSString *ZBKitSize=[[ZBCacheManager sharedInstance] fileUnitWithSize:ZBKit];
    return ZBKitSize;
}

- (NSString *)getAllCacheSize{
    //得到沙盒cache文件夹
    NSString *cachePath= [[ZBCacheManager sharedInstance]cachesPath];
    NSString *Snapshots=@"Snapshots";
    //拼接cache文件夹下的 Snapshots 文件夹
    self.path=[NSString stringWithFormat:@"%@/%@",cachePath,Snapshots];
    
    float cacheSize=[[ZBCacheManager sharedInstance]getCacheSize];//json缓存文件大小
    float imageSize = [[SDImageCache sharedImageCache]getSize];//图片缓存大小
    float SnapshotsSize=[[ZBCacheManager sharedInstance]getFileSizeWithpath:self.path];//某个沙盒路径文件大小
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
