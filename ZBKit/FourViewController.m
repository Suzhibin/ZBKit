//
//  FourViewController.m
//  ZBKit
//
//  Created by NQ UEC on 17/1/24.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "FourViewController.h"

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
    
    UILabel *label=[ZBControlTool createLabelWithFrame:CGRectMake(195, 220, 25,200) text:@"点\n击\n屏\n幕\n显\n示\n广\n告" tag:0];
    label.numberOfLines = [label.text length];
    label.font=[UIFont boldSystemFontOfSize:20];
    [self.view addSubview:label];

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
