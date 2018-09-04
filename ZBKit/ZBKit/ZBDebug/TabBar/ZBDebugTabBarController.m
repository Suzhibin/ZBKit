//
//  ZBDebugTabBarController.m
//  ZBKit
//
//  Created by NQ UEC on 2018/4/25.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "ZBDebugTabBarController.h"
#import "ZBDebugNetWorkViewController.h"
#import "ZBSandboxViewController.h"
#import "ZBAPPInfoViewController.h"
#import "ZBDebug.h"
@interface ZBDebugTabBarController ()

@end

@implementation ZBDebugTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self createTabBar];

    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:31/255.0 green:33/255.0 blue:36/255.0 alpha:1.0]];
    [UITabBar appearance].translucent = NO;
    self.tabBar.tintColor =[UIColor greenColor];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0F], NSForegroundColorAttributeName :[UIColor greenColor]} forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0F],  NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
}
- (void)createTabBar{

    ZBDebugNetWorkViewController *netWork=[[ZBDebugNetWorkViewController alloc]init];
     [self setupChildViewController:netWork title:@"Network" image:@"network" selectedImage:@""];
    
    
    ZBAPPInfoViewController *info=[[ZBAPPInfoViewController alloc]init];
    [self setupChildViewController:info title:@"AppInfo" image:@"app" selectedImage:@""];
    
    ZBSandboxViewController *sandboxVC=[[ZBSandboxViewController alloc]init];
    sandboxVC.homeDirectory=YES;
    sandboxVC.model = [[ZBFileModel alloc] initWithFileURL:[NSURL fileURLWithPath:NSHomeDirectory() isDirectory:YES]];
    [self setupChildViewController:sandboxVC title:@"Sandbox" image:@"sandbox" selectedImage:@""];
    
}
- (void)setupChildViewController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    vc.title = title;
    vc.tabBarItem.image=[UIImage imageNamed:image];
//    vc.tabBarItem.image=[[UIImage imageNamed:image]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    vc.tabBarItem.selectedImage=[[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // vc.tabBarItem.badgeValue =@"";//角标
    // vc.tabBarItem.imageInsets = UIEdgeInsetsMake(8, 0, -8, 0);//设置按钮上下
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.barTintColor =[UIColor colorWithRed:31/255.0 green:33/255.0 blue:36/255.0 alpha:1.0];
    nav.navigationBar.translucent = NO;
    
    nav.navigationBar.tintColor =[UIColor greenColor];
    [nav.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor greenColor]}];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] style:UIBarButtonItemStyleDone target:self action:@selector(exit)];
    leftItem.tintColor = [UIColor colorWithRed:66/255.0 green:212/255.0 blue:89/255.0 alpha:1.0];
    nav.topViewController.navigationItem.leftBarButtonItem = leftItem;
    [self addChildViewController:nav];
}
- (void)exit{
    [[ZBDebug sharedInstance]enable];
    [self dismissViewControllerAnimated:YES completion:nil];
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
