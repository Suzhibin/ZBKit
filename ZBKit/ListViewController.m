//
//  ListViewController.m
//  ZBKit
//
//  Created by NQ UEC on 17/1/24.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ListViewController.h"
#import "APIConstants.h"
#import "ListModel.h"
#import "DetailsViewController.h"
#import "ZBKit.h"
#import <UIImageView+WebCache.h>
#import "DBViewController.h"
#import "ZBCarouselView.h"
@interface ListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)ZBCarouselView *carouselView;
@end

@implementation ListViewController
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
#warning 可选实现
    /**
     1.防止网络不好 请求未完成用户就退出页面 ,而请求还在继续 浪费用户流量 ,所以页面退出 要取消请求。
     2.系统的session.delegate 是强引用, 手动取消 避免造成内存泄露.
     */
    [ZBNetworkManager requestToCancel:YES];//取消网络请求
    
    [[SDWebImageManager sharedManager] cancelAll];//取消图片下载
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    NSLog(@"urlString:%@",_urlString);
    
    /**
     *  如果页面不想要缓存 要添加 apiType 类型 ZBRequestTypeRefresh  每次就会重新请求url
     *  request.apiType==ZBRequestTypeRefresh
     */
    
    [ZBNetworkManager requestWithConfig:^(ZBURLRequest *request){
        request.urlString=_urlString;
    }  success:^(id responseObj,apiType type){
        NSLog(@"type:%zd",type);
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
            [self.dataArray addObject:model];
         
        }
        [self.view addSubview:self.tableView];
       
        [self.tableView reloadData];
        
    } failed:^(NSError *error){
        if (error.code==NSURLErrorCancelled)return;
        if (error.code==NSURLErrorTimedOut){
            [self alertTitle:@"请求超时" andMessage:@""];
        }else{
            [self alertTitle:@"请求失败" andMessage:@""];
        }
    }];
    [self addItemWithTitle:@"收藏页面" selector:@selector(collectionClick:) location:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count-3;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden=@"iden";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:iden];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    ListModel *model=[self.dataArray objectAtIndex:indexPath.row+3];
    
    cell.textLabel.text=model.title;
    
    cell.detailTextLabel.text=[NSString stringWithFormat:@"发布时间:%@",model.date];
    
    //判断是否是wifi环境
    if ([[ZBGlobalSettingsTool sharedInstance] downloadImagePattern]==YES) {
        
        NSInteger netStatus=[ZBNetworkManager startNetWorkMonitoring];
        if (netStatus==AFNetworkReachabilityStatusReachableViaWiFi) {
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
        }else{
             [cell.imageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
        }
    }else{
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
        
        //ZBimage
        //[cell.imageView zb_setImageWithURL:model.thumb placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
      
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ListModel *model=[self.dataArray objectAtIndex:indexPath.row+3];
    DetailsViewController *detailsVC=[[DetailsViewController alloc]init];
    detailsVC.model=model;
    detailsVC.functionType=Details;
    //detailsVC.url=model.weburl;
    [self.navigationController pushViewController:detailsVC animated:YES];
    
}
//懒加载
- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.tableHeaderView=self.carouselView;
        
    }
    
    return _tableView;
}
- (ZBCarouselView *)carouselView{
    if (!_carouselView) {
        _carouselView = [[ZBCarouselView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 180)];
        NSMutableArray *imageArray=[[NSMutableArray alloc]init];
        NSMutableArray *titleArray=[[NSMutableArray alloc]init];
        NSArray *array = [self.dataArray subarrayWithRange:NSMakeRange(0, 3)];
        for (ListModel *model in array) {
            [imageArray addObject:model.thumb];
            [titleArray addObject:model.title];
        }
        _carouselView.placeholderImage = [UIImage imageNamed:@"zhanweitu.png"];
        _carouselView.imageArray = imageArray;
        _carouselView.describeArray = titleArray;
        _carouselView.time =3;
        __weak typeof(self) weakSelf = self;
        _carouselView.imageClickBlock = ^(NSInteger index){
            NSLog(@"Block点击了第%ld张图片", index);
            ListModel *model= [weakSelf.dataArray objectAtIndex:index];
            DetailsViewController *detailsVC=[[DetailsViewController alloc]init];
            detailsVC.model=model;
            detailsVC.functionType=Details;
            //detailsVC.url=model.weburl;
            [weakSelf.navigationController pushViewController:detailsVC animated:YES];
        };
        
    }
    return _carouselView;
    
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (void)collectionClick:(UIButton *)sender{
    DBViewController *dbVC=[[DBViewController alloc]init];
    dbVC.functionType=collectionTable;
    [self.navigationController pushViewController:dbVC animated:YES];
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
