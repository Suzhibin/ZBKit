//
//  FourViewController.m
//  ZBKit
//
//  Created by NQ UEC on 17/1/24.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "FourViewController.h"
#import "ZBLabel.h"
@interface FourViewController ()

@end

@implementation FourViewController
- (void)dealloc{

    NSLog(@"释放%s",__func__);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"开屏广告";
    

    [self createAdvertise];
    
    ZBLabel *label=[[ZBLabel alloc]initWithFrame:CGRectMake(20, 100, SCREEN_WIDTH-40,200)];
    [label setAlignment:ZBTextAlignmentTop];
    label.backgroundColor=[UIColor redColor];
    label.textAlignment=NSTextAlignmentRight;
    label.text=@"点击显示广告(text显示在label的top)";
    [self.view addSubview:label];
    
    ZBLabel *label1=[[ZBLabel alloc]initWithFrame:CGRectMake(20, 300, SCREEN_WIDTH-40,200)];
    [label1 setAlignment:ZBTextAlignmentBottom];
    label1.backgroundColor=[UIColor yellowColor];
    label1.text=@"点击显示广告(text显示在label的Bottom)";
    [self.view addSubview:label1];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self createAdvertise];
}

- (void)createAdvertise{
     __weak typeof(self) weakSelf = self;
    [ZBAdvertiseInfo getAdvertisingInfo:^(NSString *imagePath,NSDictionary *urlDict,BOOL isExist){
        if (isExist) {
            ZBAdvertiseView *advertiseView = [[ZBAdvertiseView alloc] initWithFrame:weakSelf.view.bounds type:ZBAdvertiseTypeScreen];
            advertiseView.filePath = imagePath;
            advertiseView.ZBAdvertiseBlock=^{
                if ([[urlDict objectForKey:@"link"]isEqualToString:@""]) {
                    NSLog(@"没有url");
                    return;
                }else{
                     NSLog(@"有url跳转");
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushtoad" object:nil userInfo:urlDict];
                }
            };

            NSLog(@"展示广告");
        }else{
            NSLog(@"无广告");
        }
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
