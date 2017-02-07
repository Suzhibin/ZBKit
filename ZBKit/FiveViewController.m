//
//  FiveViewController.m
//  ZBKit
//
//  Created by NQ UEC on 17/2/6.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "FiveViewController.h"
#import "ZBKit.h"
@interface FiveViewController ()

@end

@implementation FiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *string=@"欢迎反馈";
    
    NSString *str=[ZBControlTool reverseWordsInString:string];
    NSLog(@"%@",str);

    NSString *str1=[ZBControlTool phoneticizeChinese:string];
    NSLog(@"%@",str1);
    
    NSString *str2=[ZBControlTool translation:@"231424"];
    NSLog(@"%@",str2);
    
   // [ZBControlTool setStatusBarBackgroundColor:[UIColor redColor]];
    
    
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
