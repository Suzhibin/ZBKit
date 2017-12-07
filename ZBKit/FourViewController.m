//
//  FourViewController.m
//  ZBKit
//
//  Created by NQ UEC on 17/1/24.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "FourViewController.h"
#import "ZBLabel.h"
#import <FLAnimatedImageView.h>
#import <FLAnimatedImageView+WebCache.h>
@interface FourViewController ()

@end

@implementation FourViewController
- (void)dealloc{

    NSLog(@"释放%s",__func__);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
 
    
    FLAnimatedImageView *FLView = [[FLAnimatedImageView alloc]init];
    FLView.frame = CGRectMake(0, 64, ZB_SCREEN_WIDTH, 280);
    [FLView sd_setImageWithURL:[NSURL URLWithString:IMAGE3] placeholderImage:[UIImage imageNamed:[NSBundle zb_placeholder]]];
    //FLAnimatedImageView 自带加载方法
    //NSData  *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:IMAGE3]];
    //imgView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:imageData];
  //  [self.view addSubview:FLView];

    
    
    ZBLabel *label=[[ZBLabel alloc]initWithFrame:CGRectMake(20, 400, ZB_SCREEN_WIDTH-40,100)];
    [label setAlignment:ZBTextAlignmentTop];
    label.backgroundColor=[UIColor redColor];
    label.textAlignment=NSTextAlignmentRight;
    label.text=@"点击显示广告(text显示在label的top)";
    [self.view addSubview:label];
    
    ZBLabel *label1=[[ZBLabel alloc]initWithFrame:CGRectMake(20, 500, ZB_SCREEN_WIDTH-40,100)];
    [label1 setAlignment:ZBTextAlignmentBottom];
    label1.backgroundColor=[UIColor yellowColor];
    label1.text=@"点击显示广告(text显示在label的Bottom)";
    [self.view addSubview:label1];

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
