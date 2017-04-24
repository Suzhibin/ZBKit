//
//  ZBTabBarController.m
//  ZBKit
//
//  Created by NQ UEC on 2017/4/20.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ZBTabBarController.h"
#import "ZBNavigationController.h"
#import "NSBundle+ZBKit.h"
#import "ZBConstants.h"
#import "ZBTabBar.h"
#import "ZBTabBarItem.h"
#import "ViewController.h"
@interface ZBTabBarController ()<UITabBarControllerDelegate>
@property (nonatomic,weak) UIViewController *lastViewController;
@property (nonatomic,strong) UIButton *middleButton;

@end

@implementation ZBTabBarController

+ (void)initialize
{
    UITabBarItem *appearance = [UITabBarItem appearance];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    [appearance setTitleTextAttributes:attrs forState:UIControlStateSelected];
    
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    //__weak typeof(self) weakSelf = self;
    ZBTabBar*tabbar=  [[ZBTabBar alloc] init];
    [tabbar.publishButton addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
    /**
     *  利用 KVC 把系统的 tabBar 类型改为自定义类型。
     */
    [self setValue:tabbar forKeyPath:@"tabBar"];
    
    [self createTabBar];

    // 设置代理 监听tabBar上按钮点击
    self.delegate = self;
    _lastViewController = self.childViewControllers.firstObject;
}
-(void)publishClick{
    ZBTabBarItem *tableItem=[[ZBTabBarItem alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    [tableItem addItemWithTitle:@"文字" andIcon:[UIImage imageNamed:@"tabbar_compose_idea"] andSelectedBlock:^{
        
        ViewController *textVC = [[ViewController alloc] init];
        ZBNavigationController *nav = [[ZBNavigationController alloc] initWithRootViewController:textVC];
        ZBTabBarController * rootView = (ZBTabBarController *)[[UIApplication sharedApplication].delegate window].rootViewController;
        [rootView presentViewController:nav animated:YES completion:nil];
        
    }];
    
    [tableItem addItemWithTitle:@"相册" andIcon:[UIImage imageNamed:@"tabbar_compose_photo"] andSelectedBlock:^{
        NSLog(@"相册");
    }];
    [tableItem addItemWithTitle:@"拍摄" andIcon:[UIImage imageNamed:@"tabbar_compose_camera"] andSelectedBlock:^{
        NSLog(@"拍摄");
        
    }];
    [tableItem addItemWithTitle:@"签到" andIcon:[UIImage imageNamed:@"tabbar_compose_lbs"] andSelectedBlock:^{
        NSLog(@"签到");
        
    }];
    [tableItem addItemWithTitle:@"点评" andIcon:[UIImage imageNamed:@"tabbar_compose_review"] andSelectedBlock:^{
        NSLog(@"点评");
        
    }];
    [tableItem addItemWithTitle:@"更多" andIcon:[UIImage imageNamed:@"tabbar_compose_more"] andSelectedBlock:^{
        NSLog(@"更多");
        
    }];
     
    
    [tableItem show];
}
- (void)createTabBar
{
   
    NSArray *vcArray=@[@"HomeViewController",@"FirstViewController",@"FiveViewController",@"SettingViewController"];
    NSArray *images=@[@"tabBar_essence_icon",@"tabBar_new_icon",@"tabBar_friendTrends_icon",@"tabBar_me_icon"];
    NSArray *seleImages=@[@"tabBar_essence_click_icon",@"tabBar_new_click_icon",@"tabBar_friendTrends_click_icon",@"tabBar_me_click_icon"];

    NSArray *titles=@[@"首页",@"ZBNetworking",@"ZBCarouselView",@"ZBTableView"];

   // NSArray *badgeValueArr=@[@"N",@"1",@"2",@"3"];
    
    for (int i=0; i<vcArray.count; i++) {
        
        Class cls=NSClassFromString(vcArray[i]);
        
        UIViewController *vc=[[cls alloc]init];
        vc.title=titles[i];
                
        NSString *image=[images objectAtIndex:i];
        NSString *seleImage=[seleImages objectAtIndex:i];

        vc.tabBarItem.image=[[UIImage imageNamed:image]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.selectedImage=[[UIImage imageNamed:seleImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        if (i==1) {
             vc.tabBarItem.badgeValue =@"N";//角标
        }
       // vc.tabBarItem.badgeValue = [badgeValueArr objectAtIndex:i];//角标
       // vc.tabBarItem.imageInsets = UIEdgeInsetsMake(8, 0, -8, 0);//设置按钮上下
        
        [self addChildViewController:[[ZBNavigationController alloc] initWithRootViewController:vc]];
    }
}

// tabBarItem是否可以选中
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
    if (_lastViewController == viewController) {
        //重复点击
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil userInfo:nil];
    }
       _lastViewController = viewController;
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
