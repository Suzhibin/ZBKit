//
//  DetailsViewController.m
//  ZBKit
//
//  Created by NQ UEC on 17/1/23.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "DetailsViewController.h"
#import "ZBKit.h"
#import <WebKit/WebKit.h>
#import "DBViewController.h"
#import "ZBDataBaseManager.h"
@interface DetailsViewController ()<WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIView *loadingView;
@end

@implementation DetailsViewController
- (void)dealloc{
    [self removeWKwebViewCache];
    ZBKLog(@"释放%s",__func__);
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self createWebView];
    
    self.loadingView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.loadingView.center= self.view.center;
    [self.loadingView zb_animationloadingView];
    [self.view addSubview:self.loadingView];
    if (_functionType==Details) {
        [self itemWithTitle:@"收藏页面" selector:@selector(btnDBClick) location:NO];
    }
    if (_functionType== tabbarAdvertise){
        [self itemWithTitle:@"返回" selector:@selector(back) location:YES];
    }
    UIButton*rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (@available(iOS 13.0, *)) {
        UIImage *image=[UIImage systemImageNamed:@"heart"];
         UIImage *selectedImage=[UIImage systemImageNamed:@"heart.fill"];
        [rightButton setImage:image forState:UIControlStateNormal];
        [rightButton setImage:selectedImage forState:UIControlStateSelected];
        rightButton.tintColor=[UIColor redColor];
        
        CGFloat size = 5;
        UIImageSymbolScale scale = 45;
        UIImageSymbolWeight weight = 45;
        UIImageSymbolConfiguration *cfg = [UIImageSymbolConfiguration configurationWithPointSize:size weight:weight scale:scale];
        [rightButton setPreferredSymbolConfiguration:cfg forImageInState:UIControlStateNormal];
    }else{
        [rightButton setTitle:@"收藏" forState:UIControlStateNormal];
        [rightButton setTitle:@"已收藏" forState:UIControlStateSelected];
    }
    if ([[ZBDataBaseManager sharedInstance]table:@"collection" isExistsWithItemId:self.model.wid]) {
           rightButton.selected=YES;
           rightButton.titleLabel.alpha = 0.5;
       }else{
           rightButton.selected=NO;
           rightButton.titleLabel.alpha = 1;
       }
    [rightButton addTarget:self action:@selector(rightNavItemButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
}
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createWebView{

    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = [[WKUserContentController alloc] init];
    
    // 支持内嵌视频播放
    config.allowsInlineMediaPlayback = YES;
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ZB_SCREEN_WIDTH, ZB_SCREEN_HEIGHT) configuration:config];
    
    [self.view addSubview:self.webView];
    self.webView.scrollView.delegate = self;
    
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    // 开始右滑返回手势
    self.webView.allowsBackForwardNavigationGestures = YES;
     ZBKLog(@"functionType:%zd",self.functionType);
     [[ZBDataBaseManager sharedInstance]createTable:@"collection"];
    if (self.functionType==Details) {

       [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.model.weburl]]];

         //[self createToobar];
        
    }else if(self.functionType==Advertise){
        ZBKLog(@"self.url:%@",self.url);
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }
}

- (void)rightNavItemButtonAction:(UIButton *)sender{
    sender.selected=!sender.selected;
    if (sender.selected==YES) {
        //收藏数据
        NSLog(@"收藏数据");
        [[ZBDataBaseManager sharedInstance] table:@"collection" insertObj:self.model ItemId:self.model.wid isSuccess:^(BOOL isSuccess) {
            if (isSuccess==YES) {
                 [ZBToast showCenterWithText:@"收藏成功"];
            }
        }];
        //为了区分按钮的状态
        sender.titleLabel.alpha = 0.5;
    }else{
        [[ZBDataBaseManager sharedInstance]table:@"collection" deleteObjectItemId:self.model.wid isSuccess:^(BOOL isSuccess) {
            if (isSuccess==YES) {
                [ZBToast showCenterWithText:@"删除成功"];
            }
        }];
        //为了区分按钮的状态
        sender.titleLabel.alpha = 1;
    }
}
// 开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    //NSLog(@"didStartProvisionalNavigation   ====    %@", navigation);
  
}
// 页面加载完调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
   // NSLog(@"didFinishNavigation   ====    %@", navigation);
    [UIView animateWithDuration:0.50 animations:^{
        self.loadingView.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        [self.loadingView removeFromSuperview];
    }];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
   // NSLog(@"didFailProvisionalNavigation   ====    %@\nerror   ====   %@", navigation, error);
}
// 内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
   // NSLog(@"didCommitNavigation   ====    %@", navigation);
  
}

- (void)removeWKwebViewCache{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        
         NSSet *websiteDataTypes= [NSSet setWithArray:@[
         WKWebsiteDataTypeDiskCache,
         WKWebsiteDataTypeOfflineWebApplicationCache,
         WKWebsiteDataTypeMemoryCache,
         WKWebsiteDataTypeLocalStorage,
        // WKWebsiteDataTypeCookies,
         WKWebsiteDataTypeSessionStorage,
         WKWebsiteDataTypeIndexedDBDatabases,
         WKWebsiteDataTypeWebSQLDatabases
         ]];
        
       // NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        }];
    }else{
        NSString *cachePath= [[ZBCacheManager sharedInstance]cachesPath];
        NSString *appID=[[ZBGlobalSettingsTool sharedInstance]appBundleID];
        NSString *WebKit=@"WebKit";
        NSString *path=[NSString stringWithFormat:@"%@/%@/%@",cachePath,appID,WebKit];
        [[ZBCacheManager sharedInstance]clearDiskWithpath:path];
    }
}
- (void)btnDBClick{
    DBViewController *dbVC=[[DBViewController alloc]init];

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
