//
//  FirstViewController.m
//  ZBKit
//
//  Created by NQ UEC on 17/2/14.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "FirstViewController.h"
#import "MenuViewController.h"
@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 1.第0租
    [self add1SectionItems];
    // 2.第1组
    [self add2SectionItems];
    // 3.第2组
    [self add3SectionItems];
    
}
- (void)add1SectionItems{
    __weak typeof(self) weakSelf = self;
    ZBTableItem *AFNetwork = [ZBTableItem itemWithTitle:@"AFNetworking" type:ZBTableItemTypeArrow];
    AFNetwork.operation = ^{
        MenuViewController *MenuVC = [[MenuViewController alloc] init];
        MenuVC.functionType=AFNetworking;
        [weakSelf.navigationController pushViewController:MenuVC animated:YES];
    };
    
    ZBTableGroup *group1= [[ZBTableGroup alloc] init];
    group1.items = @[AFNetwork];
    group1.header=@"AFNetworking封装";
    group1.footer=@"三种方法的缓存文件是相通共用的";
    group1.headerHeight=40;
    group1.footerHeight=25;
    [_allGroups addObject:group1];
}

- (void)add2SectionItems{
    __weak typeof(self) weakSelf = self;
    ZBTableItem *session1 = [ZBTableItem itemWithTitle:@"NSURLSessionBlock" type:ZBTableItemTypeArrow];
    session1.operation = ^{
        MenuViewController *MenuVC1 = [[MenuViewController alloc] init];
        MenuVC1.functionType=sessionblock;
        [weakSelf.navigationController pushViewController:MenuVC1 animated:YES];
        
    };
    
    ZBTableGroup *group2= [[ZBTableGroup alloc] init];
    group2.items = @[session1];
    group2.header=@"NSURLSession封装";
    group2.footer=@"三种方法的缓存文件是相通共用的";
    group2.headerHeight=40;
    group2.footerHeight=25;
    [_allGroups addObject:group2];
}

- (void)add3SectionItems{
    __weak typeof(self) weakSelf = self;
    ZBTableItem *session2 = [ZBTableItem itemWithTitle:@"NSURLSessionDelegate" type:ZBTableItemTypeArrow];
    session2.operation = ^{
        MenuViewController *MenuVC2 = [[MenuViewController alloc] init];
        MenuVC2.functionType=sessiondelegate;
        [weakSelf.navigationController pushViewController:MenuVC2 animated:YES];
    };
    ZBTableGroup *group3 = [[ZBTableGroup alloc] init];
    group3.items = @[session2];
    group3.header=@"NSURLSession封装";
    group3.footer=@"三种方法的缓存文件是相通共用的";
    group3.headerHeight=40;
    group3.footerHeight=25;
    [_allGroups addObject:group3];
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
