//
//  ViewController.m
//  ZBKit
//
//  Created by NQ UEC on 17/1/12.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ViewController.h"
#import "ZBKit.h"
@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"写文章";
    [self itemWithTitle:@"取消" selector:@selector(dismiss) location:NO];
    NSHashTable *hashTable=[NSHashTable hashTableWithOptions:NSPointerFunctionsStrongMemory];
    [hashTable addObject:@"hello"];
    [hashTable addObject:@"aaa"];
   BOOL isco = [hashTable containsObject:@"aaa"];
     NSLog(@"isco:%d",isco);
    NSLog(@"allObjects:%@",[hashTable allObjects]);
    [hashTable removeObject:@"aaa"];
    NSLog(@"allObjects:%@",[hashTable allObjects]);
//    [hashTable removeAllObjects];
    
    NSMapTable *mapTable=[NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableWeakMemory];
     [mapTable setObject:@"jfjfj" forKey:@"key"];
     [mapTable removeAllObjects];
    [mapTable setObject:@"dada" forKey:@"key11"];
     [mapTable setObject:@"tata" forKey:@"key12"];
    NSLog(@"keys:%@",[[mapTable keyEnumerator]allObjects]);
    NSLog(@"objs:%@",[[mapTable objectEnumerator]allObjects]);
    NSLog(@"key11:%@",[mapTable objectForKey:@"key11"]);
    [mapTable removeObjectForKey:@"key11"];
     NSLog(@"objs:%@",[[mapTable objectEnumerator]allObjects]);
   
    
    NSPointerArray *pointerArray=[NSPointerArray pointerArrayWithOptions:NSPointerFunctionsStrongMemory];
    [pointerArray addPointer:@"dadada"];
    [pointerArray addPointer:@"vmvmvm"];
    [pointerArray removePointerAtIndex:1];
    [pointerArray insertPointer:@"alala" atIndex:1];
    NSLog(@"pointerArray:%@",[pointerArray allObjects]);
    [pointerArray compact];
     NSLog(@"count:%ld",[pointerArray count]);
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 110, 150, 30)];
    [rightButton addTarget:self action:@selector(downLoadRequest) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [rightButton setTitle:@"下载" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:28];
    [self.view addSubview:rightButton];
}

#pragma mark - 下载文件方法
- (void)downLoadRequest{
    //  request.URLString=@"http://m4.pc6.com/cjh3/LogMeInInstaller7009.zip";
    [ZBRequestManager requestWithConfig:^(ZBURLRequest * request) {
        request.url=@"https://fcvideo.cdn.bcebos.com/smart/f103c4fc97d2b2e63b15d2d5999d6477.mp4";
        request.methodType=ZBMethodTypeDownLoad;
    } progress:^(NSProgress * _Nullable progress) {
        NSLog(@"onProgress: %.2f", 100.f * progress.completedUnitCount/progress.totalUnitCount);
        
    } success:^(id  responseObject,ZBURLRequest * request) {
        NSLog(@"ZBMethodTypeDownLoad 此时会返回存储路径文件: %@", responseObject);
        [self downLoadPathSize:[ZBRequestManager AppDownloadPath]];//返回下载路径的大小
      //  [self downLoadPathSize:[[ZBCacheManager sharedInstance] tmpPath]];//返回下载路径的大小
        
        sleep(5);
        [[NSFileManager defaultManager] removeItemAtPath:responseObject error:nil];
//        //删除下载的文件
//        [[ZBCacheManager sharedInstance]clearDiskWithPath:request.downloadSavePath completion:^{
            NSLog(@"删除下载的文件");
            [self downLoadPathSize:[ZBRequestManager AppDownloadPath]];
     //   }];
        
        
    } failure:^(NSError * _Nullable error) {
        NSLog(@"error: %@", error);
    }];
}

- (void)downLoadPathSize:(NSString *)path{
    CGFloat downLoadPathSize=[[ZBCacheManager sharedInstance]getFileSizeWithPath:path];
    downLoadPathSize=downLoadPathSize/1000.0/1000.0;
    NSLog(@"downLoadPathSize: %.2fM", downLoadPathSize);
}

- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
