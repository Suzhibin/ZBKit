
//
//  ZBDebugNetWorkViewController.m
//  ZBKit
//
//  Created by NQ UEC on 2018/4/25.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "ZBDebugNetWorkViewController.h"
#import "ZBDebug.h"
#import "ZBNetworking.h"
#import "MenuModel.h"
#import "ListModel.h"
#import "APIConstants.h"
#import "ZBMacros.h"
#import "ZBDebugNetWorkDetailViewController.h"
@interface ZBDebugNetWorkViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation ZBDebugNetWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor blackColor];

    NSArray *titles = @[@"release", @"verify",@"contentserver"];
    UISegmentedControl *sc = [[UISegmentedControl alloc] initWithItems:titles];
    sc.frame=CGRectMake(10, 0, ZB_SCREEN_WIDTH-20, 44);
    sc.backgroundColor=[UIColor greenColor];
     sc.selectedSegmentIndex = 0;
    [sc addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:sc];
    [self.view addSubview:self.tableView];
    
    [self loadData:menu_URL];
}
- (void)loadData:(NSString *)url{

    [ZBRequestManager requestWithConfig:^(ZBURLRequest *request) {
        request.URLString=url;
        request.apiType=ZBRequestTypeCache;
    } success:^(id responseObj, ZBURLRequest *request) {

        [self.dataArray removeAllObjects];
        NSArray *array=[responseObj objectForKey:@"authors"];
        
        for (NSDictionary *dic in array) {
            MenuModel *model=[[MenuModel alloc]init];
            model.name=[dic objectForKey:@"name"];
            model.wid=[dic objectForKey:@"id"];
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        if (error.code==NSURLErrorCancelled)return;
        if (error.code==NSURLErrorTimedOut) {
            
        }else{
            
        }
    }];
}
- (void)segmentValueChanged:(UISegmentedControl *)sc{
    if (sc.selectedSegmentIndex == 0) {
        [self loadData:menu_URL];
    } else if (sc.selectedSegmentIndex == 1) {

    } else {

    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIde=@"NetworkCellIde";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIde];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor blackColor];
        cell.contentView.backgroundColor=[UIColor blackColor];
        cell.textLabel.textColor=[UIColor grayColor];
        cell.detailTextLabel.textColor=[UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
  
    MenuModel *model=[self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text=model.name;
    NSString *url=[NSString stringWithFormat:list_URL,model.wid];
    cell.detailTextLabel.text=url;
    cell.detailTextLabel.numberOfLines=0;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuModel *model=[self.dataArray objectAtIndex:indexPath.row];
    NSString *url=[NSString stringWithFormat:list_URL,model.wid];
    ZBDebugNetWorkDetailViewController *detailVC=[[ZBDebugNetWorkDetailViewController alloc]init];
    detailVC.title=model.name;
    detailVC.URLString=url;
    [self.navigationController pushViewController:detailVC animated:YES];
}
//懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44,ZB_SCREEN_WIDTH , ZB_SCREEN_HEIGHT-(ZB_SafeAreaTopHeight+ZB_TABBAR_HEIGHT+ZB_NAVBAR_HEIGHT+44)) style:UITableViewStylePlain];
        _tableView.backgroundColor=[UIColor blackColor];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.tableFooterView=[[UIView alloc]init];
        _tableView.rowHeight=66;
    }
    return _tableView;
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
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
