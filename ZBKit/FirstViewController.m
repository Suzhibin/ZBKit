//
//  FirstViewController.m
//  ZBKit
//
//  Created by NQ UEC on 2017/4/19.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "FirstViewController.h"
#import "ZBNetworking.h"
#import "MenuModel.h"
#import "ListModel.h"
#import "SettingCacheViewController.h"
#import "APIConstants.h"
#import <UIImageView+WebCache.h>
#import "DetailsViewController.h"
@interface FirstViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *menuTableView;
@property (nonatomic,strong)UITableView *listTableView;
@property (nonatomic,strong)NSMutableArray *menuArray;
@property (nonatomic,strong)NSMutableArray *listArray;
@property (nonatomic,strong)UIRefreshControl *refreshControl;

@end

@implementation FirstViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refresh" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

     self.automaticallyAdjustsScrollViewInsets = NO;
    // 加载左边数据
    [self loadData:menu_URL];
        
    [self.view addSubview:self.menuTableView];
    [self.view addSubview:self.listTableView];
    [self.listTableView addSubview:self.refreshControl];
    [self itemWithTitle:@"缓存设置" selector:@selector(btnClick) location:NO];
    //点击广告链接 事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeRefresh:) name:@"refresh" object:nil];

}
- (void)loadData:(NSString *)url{
    //AFNetworking 封装 请求
    [ZBNetworkManager requestWithConfig:^(ZBURLRequest *request){
        request.urlString=menu_URL;
        request.apiType=ZBRequestTypeDefault;
    }  success:^(id responseObj,apiType type){
 
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        NSArray *array=[dict objectForKey:@"authors"];
        for (NSDictionary *dic in array) {
            MenuModel *model=[[MenuModel alloc]init];
            model.name=[dic objectForKey:@"name"];
            model.wid=[dic objectForKey:@"id"];
            model.detail=[dic objectForKey:@"detail"];
            [self.menuArray addObject:model];
        }
        [self.menuTableView reloadData];
        // 选中首行
        [self.menuTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        
        MenuModel *model=[self.menuArray objectAtIndex:0];
        NSString *url=[NSString stringWithFormat:list_URL,model.wid];

        [self loadlist: url type:ZBRequestTypeDefault];
        
    } failed:^(NSError *error){
        if (error.code==NSURLErrorCancelled)return;
        if (error.code==NSURLErrorTimedOut){
            [self alertTitle:@"请求超时" andMessage:@""];
        }else{
            [self alertTitle:@"请求失败" andMessage:@""];
        }
    }];
}
- (void)loadlist:(NSString *)listUrl type:(apiType)type{
    //session 封装 请求
    [[ZBURLSessionManager sharedInstance] requestWithConfig:^(ZBURLRequest *request){
        request.urlString=listUrl;
        request.apiType=type;
    }  success:^(id responseObj,apiType type){
        //如果是刷新的数据
        if (type==ZBRequestTypeRefresh) {
            [_refreshControl endRefreshing];    //结束刷新
        }
        [self.listArray removeAllObjects]; 
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        NSArray *array=[dataDict objectForKey:@"videos"];
        for (NSDictionary *dict in array) {
            ListModel *model=[[ListModel alloc]init];
            model.wid=[dict objectForKey:@"id"];
            model.title=[dict objectForKey:@"title"];
            model.time=[dict objectForKey:@"time"];
            model.thumb=[dict objectForKey:@"thumb"];
            model.weburl=[dict objectForKey:@"weburl"];
            model.date=[dict objectForKey:@"date"];
            model.author=[dict objectForKey:@"author"];
            [self.listArray addObject:model];
        }
        [self.listTableView reloadData];
     
    } failed:^(NSError *error){
         [_refreshControl endRefreshing];    //结束刷新
        if (error.code==NSURLErrorCancelled)return;
        if (error.code==NSURLErrorTimedOut){
            [self alertTitle:@"请求超时" andMessage:@""];
        }else{
            [self alertTitle:@"请求失败" andMessage:@""];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==self.menuTableView) {
        return self.menuArray.count;
    }
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.menuTableView) {
        static NSString *menuID=@"menu";
        
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:menuID];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:menuID];
        }
        MenuModel *model=[self.menuArray objectAtIndex:indexPath.row];
        cell.textLabel.text=model.name;
        cell.textLabel.font=[UIFont systemFontOfSize:12];
        return cell;

    }else{
         static NSString *listID=@"list";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:listID];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:listID];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        ListModel *model=[self.listArray objectAtIndex:indexPath.row];
        cell.textLabel.text=model.title;
        cell.detailTextLabel.text=[NSString stringWithFormat:@"发布时间:%@",model.date];
        //判断是否是wifi环境
        if ([[ZBGlobalSettingsTool sharedInstance] downloadImagePattern]==YES) {
            NSInteger netStatus=[ZBNetworkManager startNetWorkMonitoring];
            if (netStatus==AFNetworkReachabilityStatusReachableViaWiFi) {
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:[NSBundle zb_placeholder]]];
            }else{
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:[NSBundle zb_placeholder]]];
            }
        }else{
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:[NSBundle zb_placeholder]]];
        }

        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.menuTableView) {
        MenuModel *model=[self.menuArray objectAtIndex:indexPath.row];
        NSString *url=[NSString stringWithFormat:list_URL,model.wid];
        [self loadlist:url type:ZBRequestTypeDefault];
    }else{
        ListModel *model=[self.listArray objectAtIndex:indexPath.row];
        DetailsViewController *detailsVC=[[DetailsViewController alloc]init];
        detailsVC.model=model;
        detailsVC.functionType=Details;
        [self.navigationController pushViewController:detailsVC animated:YES];
    }
}

#pragma mark - 刷新
- (UIRefreshControl *)refreshControl{
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];    //下拉刷新
        _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新..."];      //标题
        [_refreshControl addTarget:self action:@selector(refreshDown:) forControlEvents:UIControlEventValueChanged];  //事件
    }
    return _refreshControl;
}
- (void)refreshDown:(UIRefreshControl*)refreshControl{
    //开始刷新
    [refreshControl beginRefreshing];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"加载中"];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timer) userInfo:nil repeats:NO];
}

- (void)timer{
    /**
     *  下拉刷新是不读缓存的 要添加 apiType 类型 ZBRequestTypeRefresh  每次就会重新请求url
     *  请求下来的缓存会覆盖原有的缓存文件
     */
    MenuModel *model= self.menuArray[[[self.menuTableView indexPathForSelectedRow] row]];
    NSString *url=[NSString stringWithFormat:list_URL,model.wid];
    [self loadlist: url type:ZBRequestTypeRefresh];

    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新..."];
    /**
     * 上拉加载 要添加 apiType 类型 ZBRequestTypeLoadMore
     */
}
- (void)btnClick{
    SettingCacheViewController *cacheVC=[[SettingCacheViewController alloc]init];
    [self.navigationController pushViewController:cacheVC animated:YES];
}
- (void)homeRefresh:(NSNotification *)noti{
    self.listTableView.contentOffset = CGPointMake(0, -100);
    [self refreshDown:self.refreshControl];
}
//懒加载
- (UITableView *)menuTableView{
    if (!_menuTableView) {
        _menuTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, 100, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _menuTableView.delegate=self;
        _menuTableView.dataSource=self;
        _menuTableView.tableFooterView=[[UIView alloc]init];
    }
    return _menuTableView;
}
//懒加载
- (UITableView *)listTableView{
    
    if (!_listTableView) {
        _listTableView=[[UITableView alloc]initWithFrame:CGRectMake(100, 64,SCREEN_WIDTH-100, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _listTableView.delegate=self;
        _listTableView.dataSource=self;
        _listTableView.tableFooterView=[[UIView alloc]init];
    }
    return _listTableView;
}

- (NSMutableArray *)menuArray {
    if (!_menuArray) {
        _menuArray = [[NSMutableArray alloc] init];
    }
    return _menuArray;
}

- (NSMutableArray *)listArray {
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc] init];
    }
    return _listArray;
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
