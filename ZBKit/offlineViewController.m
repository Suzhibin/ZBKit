//
//  offlineViewController.m
//  ZBKit
//
//  Created by NQ UEC on 17/1/24.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "offlineViewController.h"
#import "ZBNetworking.h"
#import "MenuModel.h"
#import "APIConstants.h"
@interface offlineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *offlineArray;
@end

@implementation offlineViewController
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray=[[NSMutableArray alloc]init];

    [ZBRequestManager requestWithConfig:^(ZBURLRequest *request) {
        request.URLString=menu_URL;
        request.apiType=ZBRequestTypeRefresh;
        request.responseSerializer=ZBHTTPResponseSerializer;
    } success:^(id responseObj,ZBURLRequest *request) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *array=[dict objectForKey:@"authors"];
        
        for (NSDictionary *dic in array) {
            MenuModel *model=[[MenuModel alloc]init];
            model.name=[dic objectForKey:@"name"];
            model.wid=[dic objectForKey:@"id"];
            [self.dataArray addObject:model];
            
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        if (error.code==NSURLErrorCancelled)return;
        if (error.code==NSURLErrorTimedOut) {
            [self alertTitle:@"请求超时" andMessage:@""];
        }else{
            [self alertTitle:@"请求失败" andMessage:@""];
        }
    }];
    
    
    [self.view addSubview:self.tableView];
    
    [self addItemWithTitle:@"离线下载" selector:@selector(offlineBtnClick) location:NO];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIde=@"cellIde";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    UISwitch *sw = [[UISwitch alloc] init];
    sw.center = CGPointMake(160, 90);
    sw.tag = indexPath.row;
    [sw addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = sw;
    
    MenuModel *model=[self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text=model.name;
    return cell;
}

- (void)switchValueChanged:(UISwitch *)sw{
    MenuModel *model=[self.dataArray objectAtIndex:sw.tag];
   // NSString *url=[NSString stringWithFormat:list_URL,model.wid];
    if (sw.isOn == YES) {
        //添加请求列队
        if ([self.offlineArray containsObject:model]==NO) {
             [self.offlineArray addObject:model];
        }
    }else{
        //删除请求列队
        if ([self.offlineArray containsObject:model]==YES) {
             [self.offlineArray removeObject:model];
        }
    }
}

- (void)offlineBtnClick{
    
    if (self.offlineArray.count==0) {
        
        [self alertTitle:@"请添加栏目" andMessage:@""];
        
    }else{
        
         ZBKLog(@"离线请求的栏目/url个数:%lu",self.offlineArray.count);
        
        for (MenuModel *model in self.offlineArray) {
            NSLog(@"离线请求的name:%@",model.name);
        }
        
        [self.delegate downloadWithArray:self.offlineArray];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.tableFooterView=[[UIView alloc]init];
    }
    return _tableView;
}
- (NSMutableArray *)offlineArray{
    if (!_offlineArray) {
        _offlineArray=[[NSMutableArray alloc]init];
    }
    return _offlineArray;
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
