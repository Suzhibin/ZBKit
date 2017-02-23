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
    
    [ZBAdvertiseInfo getAdvertising:^(NSString *filePath,NSDictionary *urlDict,BOOL isExist){
        if (isExist) {
            ZBAdvertiseView *advertiseView2 = [[ZBAdvertiseView alloc] initWithFrame:self.view.bounds];
            advertiseView2.filePath = filePath;
            advertiseView2.linkdict = urlDict;
            [advertiseView2 show];
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
