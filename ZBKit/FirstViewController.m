//
//  FirstViewController.m
//  ZBKit
//
//  Created by NQ UEC on 2017/4/19.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "FirstViewController.h"
#import "MenuModel.h"
#import "ListModel.h"
#import "SettingCacheViewController.h"
#import <FLAnimatedImageView+WebCache.h>
#import <SDWebImageManager.h>
#import "DetailsViewController.h"
#import "MenuTableViewCell.h"
#import <FLAnimatedImageView.h>
#import "TableViewAnimationKit.h"
#import "ZBSandboxViewController.h"
#import <UIRefreshControl+AFNetworking.h>
@interface FirstViewController ()<UITableViewDelegate,UITableViewDataSource,ZBURLRequestDelegate>

@property (nonatomic,strong)UITableView *menuTableView;
@property (nonatomic,strong)UITableView *listTableView;
@property (nonatomic,strong)NSMutableArray *menuArray;
@property (nonatomic,strong)NSMutableArray *listArray;
@property (nonatomic,strong)UIRefreshControl *refreshControl;
@property (nonatomic,copy)NSString *filePath;
@property (nonatomic,assign)NSUInteger identifier;
@end

@implementation FirstViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tabRefresh" object:nil];
      NSLog(@"释放%s",__func__);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

     self.automaticallyAdjustsScrollViewInsets = NO;
    ZBNetworkReachabilityStatus status=[ZBRequestManager networkReachability];
    switch (status) {
        case ZBNetworkReachabilityStatusUnknown:
            NSLog(@"Unknown");
            break;
        case ZBNetworkReachabilityStatusNotReachable:
            NSLog(@"NotReachable");
            break;
        case ZBNetworkReachabilityStatusViaWWAN:
            NSLog(@"WWAN");
            break;
        case ZBNetworkReachabilityStatusViaWiFi:
            NSLog(@"WiFi");
            break;
        default:
            break;
    }
    if ([ZBRequestManager isNetworkWiFi]==YES) {
        NSLog(@"WiFi");
    }else{
        NSLog(@"非WiFi");
    }
    
    // 加载左边数据
    [self loadData];
        
    [self.view addSubview:self.menuTableView];
    [self.view addSubview:self.listTableView];
    [self.listTableView addSubview:self.refreshControl];
    UIButton*rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (@available(iOS 13.0, *)) {
        UIImage *image=[[UIImage systemImageNamed:@"list.dash"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [rightButton setImage:image forState:UIControlStateNormal];
    }else{
        [rightButton setTitle:@"设置缓存" forState:UIControlStateNormal];
    }
     [rightButton addTarget:self action:@selector(rightNavItemButtonAction:) forControlEvents:UIControlEventTouchUpInside];
     UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
     //self.navigationItem.rightBarButtonItem= rightItem;
    
    UIButton *cacheFileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cacheFileBtn addTarget:self action:@selector(cacheFileBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    if (@available(iOS 13.0, *)) {
        [cacheFileBtn setImage:[[UIImage systemImageNamed:@"folder"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    } else {
           // Fallback on earlier versions
    }
    UIBarButtonItem *cacheFileBtnItem = [[UIBarButtonItem alloc] initWithCustomView:cacheFileBtn];
    self.navigationItem.rightBarButtonItems =@[rightItem,cacheFileBtnItem];
    
    [self addItemWithTitle:@"取消请求" selector:@selector(cancelClick) location:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeRefresh:) name:@"tabRefresh" object:nil];
}
- (void)cancelClick{
    [ZBRequestManager cancelRequest:self.identifier];
}
- (void)loadData{
    [ZBRequestManager requestWithConfig:^(ZBURLRequest *request){
        request.url=menu_URL;
        request.apiType=ZBRequestTypeRefresh;
    }  success:^(id responseObject,ZBURLRequest *request){
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *array=[responseObject objectForKey:@"authors"];
            for (NSDictionary *dic in array) {
                MenuModel *model=[[MenuModel alloc]initWithDict:dic];
                [self.menuArray addObject:model];
            }
            [self.menuTableView reloadData];
            // 选中首行
            [self.menuTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
            
            MenuModel *model=[self.menuArray objectAtIndex:0];
            NSString *url=[NSString stringWithFormat:list_URL,model.wid];
            
            [self loadlist: url type:ZBRequestTypeCache];
        }
    } failure:^(NSError *error){
        if (error.code==NSURLErrorCancelled)return;
        if (error.code==NSURLErrorTimedOut){
            [self alertTitle:@"请求超时" andMessage:@""];
        }else{
            [self alertTitle:@"请求失败" andMessage:@""];
        }
    }];
}
 
- (void)loadlist:(NSString *)listUrl type:(ZBApiType)type{
   
    self.identifier = [ZBRequestManager requestWithConfig:^(ZBURLRequest *request) {
        request.url=listUrl;
        request.parameters=@{@"adada":@"ffdf"};
        request.apiType=type;
    } target:self];//ZBRequestDelegate
 
    /*
    [ZBRequestManager requestWithConfig:^(ZBURLRequest *request) {
        request.URLString=listUrl;
        request.apiType=type;
    } success:^(id responseObject, ZBURLRequest *request) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dataDict = (NSDictionary *)responseObject;
            NSArray *array=[dataDict objectForKey:@"videos"];
            for (NSDictionary *dict in array) {
                ListModel *model=[[ListModel alloc]initWithDict:dict];
                [self.listArray addObject:model];
            }
            [self.listTableView reloadData];
            [_refreshControl endRefreshing];    //结束刷新
            if (request.isCache) {
                self.filePath=request.filePath;
                ZBKLog(@"使用了缓存");  [ZBToast showCenterWithText:@"使用了缓存"];
            }else{
                self.filePath=nil;
                ZBKLog(@"重新请求");  [ZBToast showCenterWithText:@"重新请求"];
            }
        }
    } failure:^(NSError *error) {
        if (error.code==NSURLErrorCancelled)return;
           if (error.code==NSURLErrorTimedOut){
               [ZBToast showCenterWithText:@"请求超时"];
           }else{
               [ZBToast showCenterWithText:@"请求失败"];
           }
    }];
     */
}

#pragma mark - ZBURLRequestDelegate
- (void)request:(ZBURLRequest *)request successForResponseObject:(id)responseObject{
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *dataDict = (NSDictionary *)responseObject;
        NSArray *array=[dataDict objectForKey:@"videos"];
        for (NSDictionary *dict in array) {
            ListModel *model=[[ListModel alloc]initWithDict:dict];
            [self.listArray addObject:model];
        }
        [self.listTableView reloadData];
        [_refreshControl endRefreshing];    //结束刷新
        if (request.isCache) {
            self.filePath=request.filePath;
            ZBKLog(@"使用了缓存");  [ZBToast showCenterWithText:@"使用了缓存"];
        }else{
            ZBKLog(@"response:%@",request.response);
            self.filePath=nil;
            ZBKLog(@"重新请求");  [ZBToast showCenterWithText:@"重新请求"];
        }
    }
}
- (void)request:(ZBURLRequest *)request failedForError:(NSError * _Nullable)error{
    if (error.code==NSURLErrorCancelled)return;
    if (error.code==NSURLErrorTimedOut){
        [ZBToast showCenterWithText:@"请求超时"];
    }else{
        [ZBToast showCenterWithText:@"请求失败"];
    }
    NSLog(@"domain:%@",error.domain);
    [_refreshControl endRefreshing];    //结束刷新
}
- (void)request:(ZBURLRequest *)request forProgress:(NSProgress *)progress{
    NSLog(@"onProgress: %.f", 100.f * progress.completedUnitCount/progress.totalUnitCount);
}
- (void)request:(ZBURLRequest *)request finishedForResponseObject:(id)responseObject forError:(NSError *)error{
//    NSLog(@"code:%ld",error.code);
//    NSLog(@"URLString:%@",request.URLString);
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==self.menuTableView) {
        return self.menuArray.count;
    }
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.menuTableView) {
        static NSString *menuID=@"menu";
        
        MenuTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:menuID];
        if (cell==nil) {
            cell=[[MenuTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:menuID];
            //设置点击cell不变色
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
       cell.menuModel=self.menuArray [indexPath.row];
  
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
        [cell.imageView zb_original:model.thumb thumbnail:model.thumb placeholder:[NSBundle zb_placeholder]];
//        FLAnimatedImageView *FLView = [[FLAnimatedImageView alloc]init];
//        FLView.frame = CGRectMake(0, 0, 44, 44);
//        [cell.contentView addSubview:FLView];
//        NSLog(@"model.thumb:%@",model.thumb);
//        [FLView sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:[NSBundle zb_placeholder]]];
        
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.menuTableView) {
        
        [[SDWebImageManager sharedManager]cancelAll];//如果点了其他频道 应暂停所在频道的图片下载  节省流量  具体看产品需求
        MenuModel *model=[self.menuArray objectAtIndex:indexPath.row];
   
        NSString *url=[NSString stringWithFormat:list_URL,model.wid];
        ZBKLog(@"url:%@",url);
        [self loadlist:url type:ZBRequestTypeCache];
      //  [TableViewAnimationKit showWithAnimationType:indexPath.row tableView:self.listTableView];
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
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerClick) userInfo:nil repeats:NO];
}

- (void)timerClick{
    /**
     *  下拉刷新是不读缓存的 要添加 apiType 类型 ZBRequestTypeRefresh  每次就会重新请求url
     *  请求下来的缓存会覆盖原有的缓存文件
     */
    if (self.menuArray.count>0) {
        MenuModel *model= self.menuArray[[[self.menuTableView indexPathForSelectedRow] row]];
        NSString *url=[NSString stringWithFormat:list_URL,model.wid];
        
        [self loadlist: url type:ZBRequestTypeRefreshAndCache];
        
        _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新..."];
        /**
         * 上拉加载 要添加 apiType 类型 ZBRequestTypeLoadMore
         */
    }else{
        return;
    }
}
- (void)cacheFileBtnAction:(UIButton *)sender{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         CGFloat cacheCount=[[ZBCacheManager sharedInstance]getCacheCount];//json缓存文件个数
        if (self.filePath.length<=0||cacheCount<=0) {
            [ZBToast showCenterWithText:@"没有缓存文件"];
            return;
        }
        NSArray* spliteArray = [self.filePath componentsSeparatedByString: @"/"];
        NSString* lastString = [spliteArray lastObject];
        NSMutableArray *fileNames=[[NSMutableArray alloc]initWithObjects:@"Library",@"Caches",@"ZBKit",@"AppCache",lastString, nil];
        NSString *lastStr=[fileNames lastObject];
        NSLog(@"lastStr:%@",lastStr);
        if ([lastStr isEqualToString:@"memoryCache"]) {
            [ZBToast showCenterWithText:@"内存缓存"];
        }else{
            ZBSandboxViewController *sandboxVC=[[ZBSandboxViewController alloc]init];
            sandboxVC.fileNames=fileNames;
            sandboxVC.model = [[ZBFileModel alloc] initWithFileURL:[NSURL fileURLWithPath:NSHomeDirectory() isDirectory:YES]];
            [self.navigationController pushViewController:sandboxVC animated:YES];
        }
    });
   
}
- (void)rightNavItemButtonAction:(UIButton *)sender{
    SettingCacheViewController *cacheVC=[[SettingCacheViewController alloc]init];
    [self.navigationController pushViewController:cacheVC animated:YES];
}
- (void)homeRefresh:(NSNotification *)noti{
    [self homeRefresh];
}
- (void)homeRefresh{
    self.listTableView.contentOffset = CGPointMake(0, -100);
    [self refreshDown:self.refreshControl];
}
//懒加载
- (UITableView *)menuTableView{
    if (!_menuTableView) {
        _menuTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,ZB_SafeAreaTopHeight+44, 100, ZB_SCREEN_HEIGHT-(ZB_SafeAreaTopHeight+44+ZB_TABBAR_HEIGHT)) style:UITableViewStylePlain];
        _menuTableView.delegate=self;
        _menuTableView.dataSource=self;
        _menuTableView.tableFooterView=[[UIView alloc]init];
    }
    return _menuTableView;
}
//懒加载
- (UITableView *)listTableView{
    
    if (!_listTableView) {
        _listTableView=[[UITableView alloc]initWithFrame:CGRectMake(100, ZB_SafeAreaTopHeight+44,ZB_SCREEN_WIDTH-100, ZB_SCREEN_HEIGHT-(ZB_SafeAreaTopHeight+44+ZB_TABBAR_HEIGHT)) style:UITableViewStylePlain];
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
