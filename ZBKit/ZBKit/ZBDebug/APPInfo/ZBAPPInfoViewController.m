//
//  ZBAPPInfoViewController.m
//  ZBKit
//
//  Created by NQ UEC on 2018/4/25.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "ZBAPPInfoViewController.h"
#import "ZBGlobalSettingsTool.h"
#import "ZBMacros.h"
@interface ZBAPPInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ZBAPPInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 3;
    }
    return 4;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return [NSString stringWithFormat:@"Application informations"];
    }
   return [NSString stringWithFormat:@"device"];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIde=@"infocellIde";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIde];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.00];
        cell.contentView.backgroundColor=[UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.00];
        cell.textLabel.textColor=[UIColor grayColor];
        cell.detailTextLabel.textColor=[UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            cell.textLabel.text=@"appName";
            cell.detailTextLabel.text=[[ZBGlobalSettingsTool sharedInstance]appBundleName];
        }
        if (indexPath.row==1) {
            cell.textLabel.text=@"Version";
            cell.detailTextLabel.text=[[ZBGlobalSettingsTool sharedInstance]appVersion];
        }
        if (indexPath.row==2) {
            cell.textLabel.text=@"Build";
            cell.detailTextLabel.text=[[ZBGlobalSettingsTool sharedInstance]appBuildVersion];
        }
        
    }else if (indexPath.section==1){

        if (indexPath.row==0) {
            cell.textLabel.text=@"device";
            cell.detailTextLabel.text=[[ZBGlobalSettingsTool sharedInstance]deviceName];
        }
        if (indexPath.row==1) {
            cell.textLabel.text=@"iPhoneName";
            cell.detailTextLabel.text=[[ZBGlobalSettingsTool sharedInstance]iPhoneName];
        }
        
        if (indexPath.row==2) {
            cell.textLabel.text=@"iOS Version";
            cell.detailTextLabel.text=[[ZBGlobalSettingsTool sharedInstance]systemVersion];
        }
        if (indexPath.row==3) {
            cell.textLabel.text=@"uuid";
            cell.detailTextLabel.text=[[ZBGlobalSettingsTool sharedInstance]uuid];
        }
    }
  
    return cell;
}
//懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0,ZB_SCREEN_WIDTH , ZB_SCREEN_HEIGHT-(ZB_SafeAreaTopHeight+ZB_TABBAR_HEIGHT+44)) style:UITableViewStyleGrouped];
        _tableView.backgroundColor=[UIColor blackColor];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.tableFooterView=[[UIView alloc]init];
    }
    return _tableView;
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
