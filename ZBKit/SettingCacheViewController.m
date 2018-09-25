//
//  SettingCacheViewController.m
//  ZBKit
//
//  Created by NQ UEC on 17/1/24.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "SettingCacheViewController.h"
#import "ZBKit.h"
#import "offlineViewController.h"
#import "APIConstants.h"
#import "ListModel.h"
#import <SDImageCache.h>
#import <SDWebImageManager.h>
#import "UIViewController+XPModal.h"
static const NSInteger cacheTime = 30;
@interface SettingCacheViewController ()<UITableViewDelegate,UITableViewDataSource,offlineDelegate>
@property (nonatomic,copy)NSString *imagePath;
@property (nonatomic,strong)NSMutableArray *imageArray;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)ZBBatchRequest *batchRequest;
@end

@implementation SettingCacheViewController
- (void)dealloc{
    NSLog(@"释放%s",__func__);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    NSString *cachePath= [[ZBCacheManager sharedInstance]cachesPath];
    //得到沙盒cache文件夹下的 SDWebimage 存储路径
    NSString *sdImage=@"default/com.hackemist.SDWebImageCache.default";
    self.imagePath=[NSString stringWithFormat:@"%@/%@",cachePath,sdImage];
    
    [self.view addSubview:self.tableView];
    
    [self addItemWithTitle:@"取消离线(批量)下载" selector:@selector(cancelClick) location:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 17;
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
        CGFloat AppCacheSize=cacheSize+sdimageSize+zbimage;
        AppCacheSize=AppCacheSize/1000.0/1000.0;

        cell.detailTextLabel.text=[NSString stringWithFormat:@"%.2fM",AppCacheSize];
    }
    if (indexPath.row==1) {
        cell.textLabel.text=@"全部缓存数量";
        cell.userInteractionEnabled = NO;
        
        CGFloat cacheCount=[[ZBCacheManager sharedInstance]getCacheCount];//json缓存文件个数
        CGFloat imageCount=[[SDImageCache sharedImageCache]getDiskCount];//图片缓存个数
        CGFloat zbimageCount=[[ZBWebImageManager sharedInstance] imageFileCount];

        CGFloat AppCacheCount=cacheCount+imageCount+zbimageCount;
        
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

        cell.textLabel.text=@"清除自定义路径缓存";
        
        CGFloat cacheSize=[[ZBCacheManager sharedInstance]getFileSizeWithpath:self.imagePath];
        
        cacheSize=cacheSize/1000.0/1000.0;
        
        CGFloat size=[[ZBCacheManager sharedInstance]getFileSizeWithpath:self.imagePath];
        
        //fileUnitWithSize 转换单位方法
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%.2fM(%@)",cacheSize,[[ZBCacheManager sharedInstance] fileUnitWithSize:size]];
        ;
    }
    if (indexPath.row==9) {
     
        cell.textLabel.text=@"系统缓存路径下所有文件数量";
        cell.userInteractionEnabled = NO;
        
        CGFloat count=[[ZBCacheManager sharedInstance]getFileCountWithpath:self.imagePath];
        
        cell.detailTextLabel.text= [NSString stringWithFormat:@"%.f",count];
    }
    if (indexPath.row==10) {
        cell.textLabel.text=@"清除单个json缓存文件(例:删除menu)";
    }
    if (indexPath.row==11) {
        cell.textLabel.text=@"清除单个图片缓存文件(手动添加url)";
    }
    
    if (indexPath.row==12) {
        cell.textLabel.text=@"按时间清除“单个”json缓存(例:删除menu,例:超过30秒)";
        cell.textLabel.font=[UIFont systemFontOfSize:14];
    }
    if (indexPath.row==13) {
        cell.textLabel.text=@"按时间清除“单个”图片缓存(手动添加url,例:超过30秒)";
        cell.textLabel.font=[UIFont systemFontOfSize:14];
    }
 
    if (indexPath.row==14) {//清除路径下的全部过期缓存文件
        cell.textLabel.text=@"按时间清除全部过期json缓存(例:超过30秒)";
    }
    
    if (indexPath.row==15) {//清除路径下的全部过期缓存文件
        cell.textLabel.text=@"按时间清除全部过期图片缓存(例:超过30秒)";
    }
    
    if (indexPath.row==16) {
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
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
            [[SDImageCache sharedImageCache] clearMemory];
            //清除ZBImage缓存
            [[ZBWebImageManager sharedInstance] clearImageFile];
            
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
        
        // [[ZBCacheManager sharedManager]clearDiskWithpath:self.imagePath];
        [[ZBCacheManager sharedInstance]clearDiskWithpath:self.imagePath completion:^{
            
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
        
        //清除单个图片缓存文件
        //url 过期 去log里找新的
        [[ZBCacheManager sharedInstance]clearCacheForkey:@"https://r1.ykimg.com/054101015918B62E8B3255666622E929" path:self.imagePath  completion:^{
            
            [self.tableView reloadData];
        }];
    }
    
    if (indexPath.row==12) {

        //[[ZBCacheManager sharedInstance]clearCacheForkey:menu_URL time:-cacheTime]
        [[ZBCacheManager sharedInstance]clearCacheForkey:menu_URL time:cacheTime completion:^{
            [self.tableView reloadData];
        }];
        
    }
    if (indexPath.row==13) {

        //url 过期 去log里找新的
        [[ZBCacheManager sharedInstance]clearCacheForkey:@"https://r1.ykimg.com/054101015918B62E8B3255666622E929" time:cacheTime path:self.imagePath completion:^{
            [self.tableView reloadData];
        }];
    }
    
    if (indexPath.row==14) {

        [[ZBCacheManager sharedInstance]clearCacheWithTime:cacheTime completion:^{
             [self.tableView reloadData];
        }];
    }
    
    if (indexPath.row==15) {
        //时间前要加 “-” 减号 ， 路径要准确
        [[ZBCacheManager sharedInstance]clearCacheWithTime:cacheTime path:self.imagePath completion:^{
            
            [[ZBCacheManager sharedInstance]clearCacheWithTime:cacheTime path:[[ZBWebImageManager sharedInstance] imageFilePath] completion:nil];
            
            [self.tableView reloadData];
        }];
    }
    
    if (indexPath.row==16) {
        
//        XPModalConfiguration *configuration = [XPModalConfiguration defaultConfiguration];
//        CGSize contentSize;
//        configuration.direction = XPModalDirectionBottom;
//        //   configuration.enableInteractiveTransitioning = NO;
//        //configuration.enableBackgroundAnimation = YES;
//       // configuration.backgroundColor = [UIColor blueColor];
//        contentSize = CGSizeMake(CGFLOAT_MAX, 300.0);
//        configuration.backgroundOpacity=0.0;
//        // configuration.enableShadow=NO;
        offlineViewController *offlineVC=[[offlineViewController alloc]init];
        offlineVC.delegate=self;
//        [self presentModalWithViewController:offlineVC contentSize:contentSize configuration:configuration completion:nil];
//
        [self.navigationController pushViewController:offlineVC animated:YES];
    }
}
#pragma mark offlineDelegate
- (void)downloadWithArray:(NSMutableArray *)offlineArray{
    
    [self requestOffline:offlineArray];
}

- (void)reloadJsonNumber{
    //离线页面的频道列表也会缓存的 如果之前清除了缓存，就刷新显示出来+1个缓存数量
    [self.tableView reloadData];
}

#pragma mark - AFNetworking
- (void)requestOffline:(NSMutableArray *)offlineArray{
    
    self.batchRequest =[ZBRequestManager sendBatchRequest:^(ZBBatchRequest *  batchRequest){
        
        for (NSString *urlString in offlineArray) {
            ZBURLRequest *request=[[ZBURLRequest alloc]init];
            request.URLString=urlString;
            request.responseSerializer=ZBHTTPResponseSerializer;
            [batchRequest.urlArray addObject:request];
        }
    }  success:^(id responseObj,apiType type,BOOL isCache){
   
        NSLog(@"添加了几个url请求  就会走几遍");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        NSArray *array=[dict objectForKey:@"videos"];
        for (NSDictionary *dic in array) {
            ListModel *model=[[ListModel alloc]init];
            model.thumb=[dic objectForKey:@"thumb"]; //找到图片的key
            [self.imageArray addObject:model];
            
            //使用SDWebImage 下载图片
            [[SDImageCache sharedImageCache]diskImageExistsWithKey:model.thumb completion:^(BOOL isInCache) {
                if (isInCache) {
                    NSLog(@"已经下载了");
                } else{
                    
                    [[SDWebImageManager sharedManager]loadImageWithURL:[NSURL URLWithString:model.thumb] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                        NSLog(@"%@",[self progressStrWithSize:(double)receivedSize/expectedSize]);
                        
                     
                    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                        NSLog(@"单个图片下载完成");
            
                        [self.tableView reloadData];
                        //让 下载的url与模型的最后一个比较，如果相同证明下载完毕。
                        NSString *imageURLStr = [imageURL absoluteString];
                        NSString *lastImage=[NSString stringWithFormat:@"%@",((ListModel *)[self.imageArray lastObject]).thumb];
                        if ([imageURLStr isEqualToString:lastImage]) {
                            NSLog(@"下载完成");
                            
                            [self alertTitle:@"下载完成"andMessage:@""];
                        }
                        
                        if (error) {
                            NSLog(@"下载失败");
                        }
                    }];
                }
                
            }];
        }
        
    } failure:^(NSError *error){
        if (error.code==NSURLErrorCancelled)return;
        if (error.code==NSURLErrorTimedOut){
            NSLog(@"请求超时");
        }else{
            NSLog(@"请求失败");
        }
    }];
    
}

- (void)cancelClick{
    
    [self.batchRequest cancelbatchRequestWithCompletion:^(BOOL results, NSString *urlString) {
        if (results==YES) {
            NSLog(@"取消下载请求:%d URL:%@",results,urlString);
        }else{
            NSLog(@"已经请求完毕无法取消");
        }
    }];//取消所有网络请求
    
    [[SDWebImageManager sharedManager] cancelAll];//取消图片下载

    NSLog(@"取消下载");
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
