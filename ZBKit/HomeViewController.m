//
//  HomeViewController.m
//  ZBKit
//
//  Created by NQ UEC on 17/1/22.
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
@interface HomeViewController ()

@end

@implementation HomeViewController
- (void)dealloc{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushtoad" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.title=@"ZBKit";
    
    //点击广告链接 事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToAd:) name:@"pushtoad" object:nil];
    
    // 1.网络请求
    [self add0SectionItems];
    // 2.图片操作
    [self add1SectionItems];
    // 3.数据库
    [self add2SectionItems];
    // 4.设置页面
    [self add3SectionItems];
    // 5.开屏广告
    [self add4SectionItems];
    // 6.常用方法
    [self add5SectionItems];
    
}

- (void)add0SectionItems{
    __weak typeof(self) weakSelf = self;
    
    //itemWithIcon
    //itemWithTitle
    ZBSettingItem *request = [ZBSettingItem itemWithTitle:@"ZBNetWorking" type:ZBSettingItemTypeArrow];
    request.operation = ^{
        FirstViewController *firstVC=[[FirstViewController alloc]init];
        [weakSelf.navigationController pushViewController:firstVC animated:YES];
    };
    ZBSettingGroup *group = [[ZBSettingGroup alloc] init];
    group.items = @[request];
    group.header=@"网络请求";
    group.headerHeight=35;
    group.footerHeight=5;
    [_allGroups addObject:group];
}

- (void)add1SectionItems;
{
    __weak typeof(self) weakSelf = self;
    ZBSettingItem *request = [ZBSettingItem itemWithTitle:@"ZBImage" type:ZBSettingItemTypeArrow];
    request.operation = ^{
        SecondViewController*secondVC = [[SecondViewController alloc] init];
        [weakSelf.navigationController pushViewController:secondVC animated:YES];
    };
    ZBSettingGroup *group1 = [[ZBSettingGroup alloc] init];
    group1.items = @[request];
    group1.header=@"图片操作/动画";
    group1.headerHeight=35;
    group1.footerHeight=5;
    [_allGroups addObject:group1];
}

- (void)add2SectionItems{

    __weak typeof(self) weakSelf = self;
    ZBSettingItem *db = [ZBSettingItem itemWithTitle:@"ZBDataBase" type:ZBSettingItemTypeArrow];
    db.operation = ^{
        ThirdViewController*ThirdVC = [[ThirdViewController alloc] init];
        [weakSelf.navigationController pushViewController:ThirdVC animated:YES];
    };
    ZBSettingGroup *group2 = [[ZBSettingGroup alloc] init];
    group2.items = @[db];
    group2.header=@"数据库操作";
    group2.headerHeight=35;
    group2.footerHeight=5;
    [_allGroups addObject:group2];
}

- (void)add3SectionItems{
    __weak typeof(self) weakSelf = self;
    ZBSettingItem *ad = [ZBSettingItem itemWithTitle:@"ZBAdvertise" type:ZBSettingItemTypeArrow];
    ad.operation = ^{
        FourViewController*adVC = [[FourViewController alloc] init];
   
        [weakSelf.navigationController pushViewController:adVC animated:YES];
    };
    ZBSettingGroup *group4 = [[ZBSettingGroup alloc] init];
    group4.items = @[ad];
    group4.header=@"开屏广告页面";
    group4.headerHeight=35;
    group4.footerHeight=5;
    [_allGroups addObject:group4];
    
}

- (void)add4SectionItems{
    __weak typeof(self) weakSelf = self;
    ZBSettingItem *ad = [ZBSettingItem itemWithTitle:@"ZBControlTool" type:ZBSettingItemTypeArrow];
    ad.operation = ^{
        FiveViewController*adVC = [[FiveViewController alloc] init];
        
        [weakSelf.navigationController pushViewController:adVC animated:YES];
    };
    ZBSettingGroup *group5 = [[ZBSettingGroup alloc] init];
    group5.items = @[ad];
    group5.header=@"常用工厂方法";
    group5.headerHeight=35;
    group5.footerHeight=5;
    [_allGroups addObject:group5];
}


- (void)add5SectionItems{
    __weak typeof(self) weakSelf = self;
    ZBSettingItem *db = [ZBSettingItem itemWithTitle:@"ZBSetting" type:ZBSettingItemTypeArrow];
    db.operation = ^{
        SettingViewController*settingVC = [[SettingViewController alloc] init];
        
        [weakSelf.navigationController pushViewController:settingVC animated:YES];
    };
    ZBSettingGroup *group3 = [[ZBSettingGroup alloc] init];
    group3.items = @[db];
    group3.header=@"设置页面";
    group3.headerHeight=35;
    group3.footerHeight=5;
    [_allGroups addObject:group3];
    
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
