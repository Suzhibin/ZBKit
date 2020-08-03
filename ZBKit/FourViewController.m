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
#import "VTMagic.h"
#import "UIViewController+XPModal.h"
#import "EightViewController.h"
#import "MenuViewController.h"
@interface FourViewController ()

@end

@implementation FourViewController
- (void)dealloc{
    NSLog(@"释放%s",__func__);
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];


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
