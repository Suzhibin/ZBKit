//
//  ZBNavigationController.m
//  ZBKit
//
//  Created by NQ UEC on 17/4/13.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ZBNavigationController.h"
#import "NSBundle+ZBKit.h"
@interface ZBNavigationController ()

@end

@implementation ZBNavigationController

+ (void)initialize{
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
    [bar setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:16]}];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        UIButton *button = [[UIButton alloc] init];
        [button setImage:[UIImage imageNamed:[NSBundle zb_navigationReturn]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[NSBundle zb_navigationReturnClick]] forState:UIControlStateHighlighted];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        button.bounds = CGRectMake(0, 0, 70, 30);
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back{
    [self popViewControllerAnimated:YES];
}

#pragma mark -  横屏设置
- (BOOL)shouldAutorotate
{
    return NO;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIDeviceOrientationPortrait);
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
/*
 //需要横屏页面使用  改页面要用present 推出
 - (BOOL)shouldAutorotate
 {
 return NO;
 }
 
 - (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
 {
 return UIInterfaceOrientationLandscapeRight;
 }
 
 - (UIInterfaceOrientationMask)supportedInterfaceOrientations
 {
 return UIInterfaceOrientationMaskLandscapeRight;
 }
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
