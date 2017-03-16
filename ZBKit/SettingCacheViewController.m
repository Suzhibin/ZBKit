//
//  SettingCacheViewController.m
//  ZBKit
//
//  Created by NQ UEC on 17/1/24.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "SettingCacheViewController.h"
#import "ZBKit.h"
#import "OfflineView.h"
#import "offlineViewController.h"
#import "APIConstants.h"
#import "ListModel.h"
#import <SDImageCache.h>
#import <SDWebImageManager.h>
static const NSInteger cacheTime = 30;
@interface SettingCacheViewController ()<UITableViewDelegate,UITableViewDataSource,offlineDelegate>
@property (nonatomic,copy)NSString *path;
@property (nonatomic,copy)NSString *imagePath;
@property (nonatomic,strong)NSMutableArray *imageArray;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)OfflineView *offlineView;
@end

@implementation SettingCacheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //得到沙盒cache文件夹下的系统缓存文件路径
    NSString *cachePath= [[ZBCacheManager sharedInstance]cachesPath];
  //  NSString *appID=@"github.com-Suzhibin.ZBKit";
    NSString *appID=[[ZBGlobalSettingsTool sharedInstance]appBundleID];
    NSString *fsCachedData=@"fsCachedData";
    self.path=[NSString stringWithFormat:@"%@/%@/%@",cachePath,appID,fsCachedData];
    
    NSString *sdImage=@"default/com.hackemist.SDWebImageCache.default";
    self.imagePath=[NSString stringWithFormat:@"%@/%@",cachePath,sdImage];
    
    [self.view addSubview:self.tableView];
    
    [self addItemWithTitle:@"star" selector:@selector(starBtnClick) location:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 14;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIde=@"cellIde";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIde];
    }
    if (indexPath.row==0) {
        cell.textLabel.text=@"清除全部缓存";
        
        CGFloat cacheSize=[[ZBCacheManager sharedInstance]getCacheSize];//json缓存文件大小
        CGFloat sdimageSize = [[SDImageCache sharedImageCache]getSize];//图片缓存大小
        CGFloat zbimage=[[ZBWebImageManager sharedInstance] imageFileSize];
        CGFloat fsCachedDataSize=[[ZBCacheManager sharedInstance]getFileSizeWithpath:self.path];//系统缓存沙盒路径文件大小
        CGFloat AppCacheSize=cacheSize+sdimageSize+zbimage+fsCachedDataSize;
        AppCacheSize=AppCacheSize/1000.0/1000.0;

        cell.detailTextLabel.text=[NSString stringWithFormat:@"%.2fM",AppCacheSize];
    }
    if (indexPath.row==1) {
        cell.textLabel.text=@"全部缓存数量";
        cell.userInteractionEnabled = NO;
        
        CGFloat cacheCount=[[ZBCacheManager sharedInstance]getCacheCount];//json缓存文件个数
        CGFloat imageCount=[[SDImageCache sharedImageCache]getDiskCount];//图片缓存个数
        CGFloat zbimageCount=[[ZBWebImageManager sharedInstance] imageFileCount];
        CGFloat fsCachedDataCount=[[ZBCacheManager sharedInstance]getFileCountWithpath:self.path];//系统缓存沙盒路径文件个数
        CGFloat AppCacheCount=cacheCount+imageCount+zbimageCount+fsCachedDataCount;
        
        cell.detailTextLabel.text= [NSString stringWithFormat:@"%.f",AppCacheCount];
    }
    if (indexPath.row==2) {
        cell.textLabel.text=@"清除json缓存";
        
        CGFloat cacheSize=[[ZBCacheManager sharedInstance]getCacheSize];//json缓存文件大小
        
        cacheSize=cacheSize/1000.0/1000.0;
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%.2fM",cacheSize];
    }
    if (indexPath.row==3) {
        cell.textLabel.text=@"json缓存数量";
        cell.userInteractionEnabled = NO;
        CGFloat cacheCount=[[ZBCacheManager sharedInstance]getCacheCount];//json缓存文件个数
        cell.detailTextLabel.text= [NSString stringWithFormat:@"%.f",cacheCount];
    }
    
    if (indexPath.row==4) {
        cell.textLabel.text=@"清除SDwebImage缓存";
        CGFloat sdimageSize = [[SDImageCache sharedImageCache]getSize];//图片缓存大小
        
        sdimageSize=sdimageSize/1000.0/1000.0;
        
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%.2fM",sdimageSize];
    }
    
    if (indexPath.row==5) {
        cell.textLabel.text=@"SDwebImage缓存数量";
        cell.userInteractionEnabled = NO;
        
        CGFloat sdimageCount=[[SDImageCache sharedImageCache]getDiskCount];//图片缓存个数
    
        cell.detailTextLabel.text= [NSString stringWithFormat:@"%.f",sdimageCount];
    }
    
    if (indexPath.row==6) {
        cell.textLabel.text=@"清除ZBImage缓存";
        CGFloat ZBImageSize=[[ZBWebImageManager sharedInstance] imageFileSize];
       
        ZBImageSize=ZBImageSize/1000.0/1000.0;
        
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%.2fM",ZBImageSize];
    }
    
    if (indexPath.row==7) {
        cell.textLabel.text=@"ZBImage缓存数量";
        
        CGFloat ZBImageCount=[[ZBWebImageManager sharedInstance] imageFileCount];
        
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%.f",ZBImageCount];
        
    }
    if (indexPath.row==8) {

        cell.textLabel.text=@"清除系统缓存路径下的所有文件";
        
        CGFloat size=[[ZBCacheManager sharedInstance]getFileSizeWithpath:self.path];
        
        //fileUnitWithSize 转换单位方法
        cell.detailTextLabel.text=[[ZBCacheManager sharedInstance] fileUnitWithSize:size];
    }
    if (indexPath.row==9) {
     
        cell.textLabel.text=@"系统缓存路径下所有文件数量";
        cell.userInteractionEnabled = NO;
        
        CGFloat count=[[ZBCacheManager sharedInstance]getFileCountWithpath:self.path];
        
        cell.detailTextLabel.text= [NSString stringWithFormat:@"%.f",count];
    }
    if (indexPath.row==10) {
        cell.textLabel.text=@"清除单个json缓存文件(例:删除menu)";
    }
    
    if (indexPath.row==11) {
        cell.textLabel.text=@"按时间清除json缓存(例:超过30秒)";
    }
    if (indexPath.row==12) {
        cell.textLabel.text=@"按时间清除图片缓存(例:超过30秒)";
    }
    
    if (indexPath.row==13) {
        cell.textLabel.text=@"离线下载";
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row==0) {
        //清除json缓存后的操作
        [[ZBCacheManager sharedInstance]clearCacheOnCompletion:^{
            //清除SDImage缓存
            [[SDImageCache sharedImageCache] clearDisk];
            [[SDImageCache sharedImageCache] clearMemory];
            //清除ZBImage缓存
             [[ZBWebImageManager sharedInstance] clearImageFile];
            //清除系统缓存文件
            //[[NSURLCache sharedURLCache]removeAllCachedResponses];
            //用ZBCacheManager 方法代替上面的系统方法 清除系统缓存文件
            [[ZBCacheManager sharedInstance]clearDiskWithpath:self.path];
            
            [self.tableView reloadData];
        }];
    }
    
    if (indexPath.row==2) {
        //清除json缓存
        //[[ZBCacheManager sharedManager]clearCache];
        [[ZBCacheManager sharedInstance]clearCacheOnCompletion:^{
            [self.tableView reloadData];
        }];
        
    }
    
    if (indexPath.row==4) {
        //清除SDImage缓存
        //  [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [[SDImageCache sharedImageCache] clearMemory];
            [self.tableView reloadData];
            
        }];
    }
    
    if (indexPath.row==6) {
        //清除ZBImage缓存
       // [[ZBImageDownloader sharedInstance] clearImageFile];
        [[ZBWebImageManager sharedInstance] clearImageFileCompletion:^{
             [self.tableView reloadData];
        }];
       
    }
    
    if (indexPath.row==8) {
        
        //清除系统缓存路径下所有文件
        //[[NSURLCache sharedURLCache]removeAllCachedResponses];
        
        //用ZBCacheManager 方法代替上面的系统方法 清除系统缓存文件
        // [[ZBCacheManager sharedManager]clearDiskWithpath:self.path];
        [[ZBCacheManager sharedInstance]clearDiskWithpath:self.path completion:^{
            
            [self.tableView reloadData];
            
        }];
    }
    
    if (indexPath.row==10) {
        
        //清除单个缓存文件
        // [[ZBCacheManager sharedManager]clearCacheForkey:menu_URL];
        [[ZBCacheManager sharedInstance]clearCacheForkey:menu_URL completion:^{
            
            [self.tableView reloadData];
        }];
    }
    if (indexPath.row==11) {
        //时间前要加 “-” 减号
        [[ZBCacheManager sharedInstance]clearCacheWithTime:-cacheTime completion:^{
             [self.tableView reloadData];
        }];
    }
    if (indexPath.row==12) {
        //时间前要加 “-” 减号 ， 路径要准确
        [[ZBCacheManager sharedInstance]clearCacheWithTime:-cacheTime path:self.imagePath completion:^{
            
            [[ZBCacheManager sharedInstance]clearCacheWithTime:-cacheTime path:[[ZBWebImageManager sharedInstance] imageFilePath] completion:nil];
            
            [self.tableView reloadData];
        }];
    }
    
    if (indexPath.row==13) {
        offlineViewController *offlineVC=[[offlineViewController alloc]init];
        offlineVC.delegate=self;
        [self.navigationController pushViewController:offlineVC animated:YES];
    }
}
#pragma mark offlineDelegate
- (void)downloadWithArray:(NSMutableArray *)offlineArray{
    
    [self requestOffline:offlineArray];
    
    //创建下载进度视图
    self.offlineView=[[OfflineView alloc]initWithFrame:CGRectMake(0, 0, [UIApplication sharedApplication].keyWindow .frame.size.width,[UIApplication sharedApplication].keyWindow .frame.size.height)];
    [self.offlineView.cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:self.offlineView];
    
    
}
- (void)reloadJsonNumber{
    //离线页面的频道列表也会缓存的 如果之前清除了缓存，就刷新显示出来+1个缓存数量
    [self.tableView reloadData];
    
}

#pragma mark - AFNetworking
- (void)requestOffline:(NSMutableArray *)offlineArray{
    
    //[ZBURLSessionManager sharedManager]requestWithConfig
    
    [ZBNetworkManager requestWithConfig:^(ZBURLRequest *request){
        
        request.urlArray=offlineArray;
        request.apiType=ZBRequestTypeOffline;   //离线请求 apiType:ZBRequestTypeOffline
        
    }  success:^(id responseObj,apiType type){
        //如果是离线请求的数据
        if (type==ZBRequestTypeOffline) {
            NSLog(@"添加了几个url请求  就会走几遍");
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
            NSArray *array=[dict objectForKey:@"videos"];
            for (NSDictionary *dic in array) {
                ListModel *model=[[ListModel alloc]init];
                model.thumb=[dic objectForKey:@"thumb"]; //找到图片的key
                [self.imageArray addObject:model];
                
                //使用SDWebImage 下载图片
                BOOL isKey=[[SDImageCache sharedImageCache]diskImageExistsWithKey:model.thumb];
                if (isKey) {
                    self.offlineView.progressLabel.text=@"已经下载了";
                } else{
                    
                    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:model.thumb] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize){
                        
                        NSLog(@"%@",[self progressStrWithSize:(double)receivedSize/expectedSize]);
                        
                        self.offlineView.progressLabel.text=[self progressStrWithSize:(double)receivedSize/expectedSize];
                        
                        self.offlineView.pv.progress =(double)receivedSize/expectedSize;
                        
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,BOOL finished,NSURL *imageURL){
                        
                        NSLog(@"单个图片下载完成");
                        self.offlineView.progressLabel.text=nil;
                        
                        self.offlineView.progressLabel.text=[self progressStrWithSize:0.0];
                        
                        self.offlineView.pv.progress = 0.0;
                        
                        [self.tableView reloadData];
                        //让 下载的url与模型的最后一个比较，如果相同证明下载完毕。
                        NSString *imageURLStr = [imageURL absoluteString];
                        NSString *lastImage=[NSString stringWithFormat:@"%@",((ListModel *)[self.imageArray lastObject]).thumb];
                        if ([imageURLStr isEqualToString:lastImage]) {
                            NSLog(@"下载完成");
                            
                            [self.offlineView hide];//取消下载进度视图
                            [self alertTitle:@"下载完成"andMessage:@""];
                        }
                        
                        if (error) {
                            NSLog(@"下载失败");
                        }
                    }];
                    
                }
                
            }
            
        }
        
    } failed:^(NSError *error){
        if (error.code==NSURLErrorCancelled)return;
        if (error.code==NSURLErrorTimedOut){
            NSLog(@"请求超时");
        }else{
            NSLog(@"请求失败");
        }
    }];
    
}

- (void)cancelClick{
    [ZBNetworkManager requestToCancel:YES];//取消网络请求
    [[SDWebImageManager sharedManager] cancelAll];//取消图片下载
    [self.offlineView hide];//取消下载进度视图
    NSLog(@"取消下载");
}
- (void)starBtnClick{
    
    [self alertTitle:@"感觉不错给star吧 谢谢" andMessage:@"https://github.com/Suzhibin/ZBNetworking"];
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

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc] init];
    }
    return _imageArray;
}

- (NSString *)progressStrWithSize:(double)size{
    NSString *progressStr = [NSString stringWithFormat:@"下载进度:%.1f",size* 100];
    return  progressStr = [progressStr stringByAppendingString:@"%"];
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
