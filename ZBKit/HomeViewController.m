//
//  HomeViewController.m
//  ZBKit
//
//  Created by NQ UEC on 17/2/14.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "HomeViewController.h"
#import "DetailsViewController.h"
#import "SettingViewController.h"
#import "ThirdViewController.h"
#import "SecondViewController.h"
#import "FirstViewController.h"
#import "FourViewController.h"
#import "FiveViewController.h"
#import "SixViewController.h"
#import "SevenViewController.h"

#import "YYFPSLabel.h"
#import "ZBInteractiveTransition.h"
#import "ZBPushTransitioning.h"
#import "ZBPopTransitioning.h"
@interface HomeViewController ()<UINavigationControllerDelegate>
@property (nonatomic,strong) ZBInteractiveTransition *transitionController;
@property (nonatomic,strong) ZBPushTransitioning *pushAnimation;
@property (nonatomic,strong) ZBPopTransitioning *dismissAnimation;
@end

@implementation HomeViewController
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushtoad" object:nil];
}
-(ZBPushTransitioning *)pushAnimation
{
    if (!_pushAnimation) {
        _pushAnimation = [[ZBPushTransitioning alloc] init];
    }
    return _pushAnimation;
}
-(ZBPopTransitioning *)dismissAnimation
{
    if (!_dismissAnimation) {
        _dismissAnimation = [[ZBPopTransitioning alloc] init];
    }
    return _dismissAnimation;
}
-(ZBInteractiveTransition *)transitionController
{
    if (!_transitionController) {
        _transitionController = [[ZBInteractiveTransition alloc] init];
    }
    return _transitionController;
}
#pragma mark - UINavigationControllerDelegate
/** 返回转场动画实例*/
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        return self.pushAnimation;
    }else if (operation == UINavigationControllerOperationPop){
        return self.dismissAnimation;
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    return self.transitionController.interacting ? self.transitionController : nil;
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"willShowViewController - %@",self.transitionController.interacting ?@"YES":@"NO");
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"didShowViewController - %@",self.transitionController.interacting ?@"YES":@"NO");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
   self.navigationController.delegate = self;
    //点击广告链接 事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToAd:) name:@"pushtoad" object:nil];
       // 1.网络请求
    //[self add0SectionItems];
    // 2.图片操作
    [self add1SectionItems];
    // 3.数据库
  //  [self add2SectionItems];
    // 4.开屏广告
    [self add3SectionItems];
    // 5.轮播视图
   // [self add4SectionItems];
    // 6.常用方法
    [self add5SectionItems];
    // 6.设置页面
   // [self add6SectionItems];
    [self add7SectionItems];
    /*
     //homeViewController
     "homeWebimage"="圖片緩存器/動畫";
     "homeDatabase"="數據庫";
     "homeAdvertise"="廣告";
     "homeControlTool"="常用工廠方法";
     */
}

- (void)add0SectionItems{
    __weak typeof(self) weakSelf = self;
    
    //itemWithIcon
    //itemWithTitle
    ZBTableItem *requestItem = [ZBTableItem itemWithTitle:@"ZBNetworking" type:ZBTableItemTypeArrow];
    requestItem.operation = ^{
        FirstViewController *firstVC=[[FirstViewController alloc]init];
        [weakSelf.transitionController wireToViewController:self.navigationController];
        [weakSelf.navigationController pushViewController:firstVC animated:YES];
    };
    ZBTableGroup *group = [[ZBTableGroup alloc] init];
    group.items = @[requestItem];
    group.header=@"网络请求";
    group.headerHeight=35;
    group.footerHeight=5;
    [_allGroups addObject:group];
}

- (void)add1SectionItems;
{
    __weak typeof(self) weakSelf = self;
    ZBTableItem *imageItem = [ZBTableItem itemWithTitle:ZBLocalized(@"homeWebimage",nil) type:ZBTableItemTypeArrow];
    imageItem.operation = ^{
           [weakSelf.transitionController wireToViewController:self.navigationController];
        SecondViewController*secondVC = [[SecondViewController alloc] init];
        [weakSelf.navigationController pushViewController:secondVC animated:YES];
    };
    ZBTableGroup *group1 = [[ZBTableGroup alloc] init];
    group1.items = @[imageItem];
    group1.header=@"图片操作/动画";
    group1.headerHeight=35;
    group1.footerHeight=5;
    [_allGroups addObject:group1];
}
/*
- (void)add2SectionItems{
    
    __weak typeof(self) weakSelf = self;
    ZBTableItem *dbItem = [ZBTableItem itemWithTitle:ZBLocalized(@"homeDatabase",nil) type:ZBTableItemTypeArrow];
    dbItem.operation = ^{
        ThirdViewController*ThirdVC = [[ThirdViewController alloc] init];
        [weakSelf.navigationController pushViewController:ThirdVC animated:YES];
    };
    ZBTableGroup *group2 = [[ZBTableGroup alloc] init];
    group2.items = @[dbItem];
    group2.header=@"数据库操作";
    group2.headerHeight=35;
    group2.footerHeight=5;
    [_allGroups addObject:group2];
}
*/
- (void)add3SectionItems{
    __weak typeof(self) weakSelf = self;
    ZBTableItem *adItem = [ZBTableItem itemWithTitle:ZBLocalized(@"homeAdvertise",nil) type:ZBTableItemTypeArrow];
    adItem.operation = ^{
        FourViewController*adVC = [[FourViewController alloc] init];
        
        [weakSelf.navigationController pushViewController:adVC animated:YES];
    };
    ZBTableGroup *group3 = [[ZBTableGroup alloc] init];
    group3.items = @[adItem];
    group3.header=@"开屏广告";
    group3.headerHeight=35;
    group3.footerHeight=5;
    [_allGroups addObject:group3];
    
}

- (void)add4SectionItems{
    __weak typeof(self) weakSelf = self;
    ZBTableItem *toolItem = [ZBTableItem itemWithTitle:@"ZBCarouselView" type:ZBTableItemTypeArrow];
    toolItem.operation = ^{
        FiveViewController*toolVC = [[FiveViewController alloc] init];
        [weakSelf.transitionController wireToViewController:self.navigationController];
        [weakSelf.navigationController pushViewController:toolVC animated:YES];
    };
    ZBTableGroup *group4 = [[ZBTableGroup alloc] init];
    group4.items = @[toolItem];
    group4.header=@"轮播控件";
    group4.headerHeight=35;
    group4.footerHeight=5;
    [_allGroups addObject:group4];
   
}

- (void)add5SectionItems{
    __weak typeof(self) weakSelf = self;
    ZBTableItem *carouselItem = [ZBTableItem itemWithTitle:ZBLocalized(@"homeControlTool",nil) type:ZBTableItemTypeArrow];
    carouselItem.operation = ^{
        [weakSelf.transitionController wireToViewController:self.navigationController];
        SixViewController *sixVC=[[SixViewController alloc]init];
        [weakSelf.navigationController pushViewController:sixVC animated:YES];
    };
    ZBTableGroup *group5 = [[ZBTableGroup alloc] init];
    group5.items = @[carouselItem];
    group5.header=@"常用工厂方法";
    group5.headerHeight=35;
    group5.footerHeight=5;
    [_allGroups addObject:group5];
}

- (void)add6SectionItems{
    __weak typeof(self) weakSelf = self;
    ZBTableItem *settingItem = [ZBTableItem itemWithTitle:@"ZBTableView" type:ZBTableItemTypeArrow];
    settingItem.operation = ^{
        SettingViewController*settingVC = [[SettingViewController alloc] init];
        
        [weakSelf.navigationController pushViewController:settingVC animated:YES];
    };
    ZBTableGroup *group6 = [[ZBTableGroup alloc] init];
    group6.items = @[settingItem];
    group6.header=@"设置页面";
    group6.headerHeight=35;
    group6.footerHeight=5;
    [_allGroups addObject:group6];
}
- (void)add7SectionItems{
    __weak typeof(self) weakSelf = self;
    ZBTableItem *item = [ZBTableItem itemWithTitle:@"练习" type:ZBTableItemTypeArrow];
    item.operation = ^{
        SevenViewController*itemVC = [[SevenViewController alloc] init];
        
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    };
    ZBTableGroup *group7 = [[ZBTableGroup alloc] init];
    group7.items = @[item];
    group7.header=@"练习";
    group7.headerHeight=35;
    group7.footerHeight=5;
    [_allGroups addObject:group7];
}
- (void)pushToAd:(NSNotification *)noti{
 
     DetailsViewController* detailsVC=[[DetailsViewController alloc]init];
     detailsVC.url=[noti.userInfo objectForKey:@"link"];
     detailsVC.functionType=Advertise;
     [self.navigationController pushViewController:detailsVC animated:YES];
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
