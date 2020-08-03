//
//  MeViewController.m
//  ZBNews
//
//  Created by NQ UEC on 16/11/18.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "MeViewController.h"
#import "ZBNetworking.h"
#import "SDImageCache.h"
#import "DBViewController.h"
#import "LanguageViewController.h"
#import "StorageSpaceViewController.h"
#import "DWaveView.h"
@interface MeViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UIImagePickerController *_thePicker;
}
@property (nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIImageView *backgroundImgV;
@property(nonatomic,assign)float backImgHeight;
@property(nonatomic,assign)float backImgWidth;
@property(nonatomic,strong) UIImageView* headerImg;
@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)UILabel *headerlabel;
@property (nonatomic,strong)NSMutableArray *imageArray;
@property (strong, nonatomic) DWaveView *waveView;
@property (strong, nonatomic)UIView *borderZoomView;
@end

@implementation MeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /*
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
     [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
     */
    self.view.backgroundColor=[UIColor whiteColor];
    [self backImageView];
    [self.view addSubview:self.tableView];
    
  
             
    __weak typeof(self) weakSelf = self;
    self.waveView.waveBlock = ^(CGFloat currentY){
        CGRect iconFrame = [weakSelf.headerImg frame];
        iconFrame.origin.y = CGRectGetHeight(weakSelf.headerImg.frame)+currentY;
        weakSelf.headerImg.frame  =iconFrame;
    };
    //[self zoomView];
}
// 核心代码
- (void)zoomView {
    // 具体缩放大小 效果根据需要自己调整
    // 边框放大
    [UIView animateWithDuration:0.5+0.1 animations:^{
        self.borderZoomView.transform = CGAffineTransformMakeScale(1.15, 1.15); // 边框放大
        self.borderZoomView.alpha = 0.08; // 透明度渐变
    } completion:^(BOOL finished) {
       // 恢复默认
        self.borderZoomView.transform = CGAffineTransformMakeScale(1, 1);
        self.borderZoomView.alpha = 1;
    }];
    
    // imageView先缩小 再恢复
    [UIView animateWithDuration:0.5 animations:^{
       // self.headerImg.transform = CGAffineTransformMakeScale(0.88, 0.88); // 缩小
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            // self.headerImg.transform = CGAffineTransformMakeScale(1, 1); // 放大
        } completion:^(BOOL finished) {
            // 重新调用
            [self zoomView];
        }];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIde=@"cellIde";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIde];
    }
    if (indexPath.row==0) {
         cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text=ZBLocalized(@"collection",nil);
        
    }

    if (indexPath.row==1) {
        cell.textLabel.text=ZBLocalized(@"languages",nil);
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    

    }
    if (indexPath.row==2) {
        cell.textLabel.text=ZBLocalized(@"clearcache",nil);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   

    if (indexPath.row==0) {
        DBViewController *databaseVC=[[DBViewController alloc]init];
        [self.navigationController pushViewController:databaseVC animated:YES];
        
    }
    if (indexPath.row==1) {
        LanguageViewController *languageVC=[[LanguageViewController alloc]init];
        [self.navigationController pushViewController:languageVC animated:YES];
        
    }
    if (indexPath.row==2) {
        StorageSpaceViewController *storageVC=[[StorageSpaceViewController alloc]init];
        [self.navigationController pushViewController:storageVC animated:YES];
        /*
        [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
            
            [[ZBCacheManager sharedInstance]clearCache];
            
            [[SDImageCache sharedImageCache] clearMemory];
            //清除系统内存文件
            [[NSURLCache sharedURLCache]removeAllCachedResponses];
            
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:3 inSection:0],nil] withRowAnimation:UITableViewRowAnimationFade];
            
        }];
         */
    }
    
}

//懒加载
- (UITableView *)tableView
{
    
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, ZB_SafeAreaTopHeight+44, ZB_SCREEN_WIDTH, ZB_SCREEN_HEIGHT-(ZB_SafeAreaTopHeight+44)) style:UITableViewStylePlain];
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.tableHeaderView=[self headImageView];
        _tableView.tableFooterView=[[UIView alloc]init];
    }
    return _tableView;
}

-(void)backImageView{
    UIImage *image=[UIImage imageNamed:@"back.png"];
    
    _backgroundImgV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ZB_SCREEN_WIDTH, image.size.height*0.8)];
    _backgroundImgV.backgroundColor=[UIColor redColor];
    _backgroundImgV.image=image;
    _backgroundImgV.userInteractionEnabled=YES;
    [self.view addSubview:_backgroundImgV];
    _backImgHeight=_backgroundImgV.frame.size.height;
    _backImgWidth=_backgroundImgV.frame.size.width;
  

}

-(UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView=[[UIImageView alloc]init];
        _headImageView.frame=CGRectMake(0, 0, ZB_SCREEN_WIDTH, 240);
        _headImageView.backgroundColor=[UIColor clearColor];
        _headImageView.userInteractionEnabled = YES;
        
        _headerImg=[[UIImageView alloc]initWithFrame:CGRectMake(ZB_SCREEN_WIDTH/2-35, 120, 70, 70)];
        _headerImg.center=CGPointMake(ZB_SCREEN_WIDTH/2, 120);
        
        [_headerImg setImage:[UIImage imageNamed:@"Andi"]];
        _headerImg.layer.cornerRadius=35;
        _headerImg.layer.masksToBounds=YES;
        _headerImg.backgroundColor=[UIColor whiteColor];
        _headerImg.userInteractionEnabled=YES;
        [_headImageView addSubview:_headerImg];
        
        _headerlabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 170,ZB_SCREEN_WIDTH-20, 20)];
        _headerlabel.text=@"https://github.com/Suzhibin/ZBNews";
        _headerlabel.textColor=[UIColor whiteColor];
        _headerlabel.textAlignment=NSTextAlignmentCenter;
        [_headImageView addSubview:_headerlabel];
        
        _waveView = [[DWaveView alloc] init];
        _waveView.frame=CGRectMake(0, _headImageView.frame.size.height-20,self.view.frame.size.width, 50);
        _waveView.realWaveColor = [UIColor whiteColor];
           // _waveView.maskWaveColor = [UIColor redColor];
        [_waveView startWaveAnimation];
        [_headImageView addSubview:_waveView];
       /*
        // 固定边框
        UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(ZB_SCREEN_WIDTH/2-35, 120, 70, 70)];
        borderView.layer.cornerRadius = 25;
        borderView.layer.borderColor = [UIColor greenColor].CGColor;
        borderView.layer.borderWidth = 1;
        [_headImageView addSubview:borderView];
      
        // 缩放边框
        _borderZoomView = [[UIView alloc] initWithFrame:CGRectMake(ZB_SCREEN_WIDTH/2-35, 120, 70, 70)];
        _borderZoomView.layer.cornerRadius = 25;
        _borderZoomView.layer.borderColor = [UIColor greenColor].CGColor;
        _borderZoomView.layer.borderWidth = 1;
        [_headImageView addSubview:_borderZoomView];
       */
    }
    return _headImageView;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int contentOffsety = scrollView.contentOffset.y;
    
    if (contentOffsety<0) {
        CGRect rect = _backgroundImgV.frame;
        rect.size.height = _backImgHeight-contentOffsety;
        rect.size.width = _backImgWidth* (_backImgHeight-contentOffsety)/_backImgHeight;
        rect.origin.x =  -(rect.size.width-_backImgWidth)/2;
        rect.origin.y = 0;
        _backgroundImgV.frame = rect;
    }else{
        CGRect rect = _backgroundImgV.frame;
        rect.size.height = _backImgHeight;
        rect.size.width = _backImgWidth;
        rect.origin.x = 0;
        rect.origin.y = -contentOffsety;
        _backgroundImgV.frame = rect;
        
    }
}
- (NSString *)progressStrWithSize:(double)size{
    NSString *progressStr = [NSString stringWithFormat:@"图片:%.1f",size* 100];
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
