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
@interface DetailsViewController ()<WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate>{
 
}
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIView *loadingView;
@end

@implementation DetailsViewController
- (void)dealloc{
    [self removeWKwebViewCache];
    ZBKLog(@"释放%s",__func__);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //美思瑞 Mosonry
  
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
}
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createWebView{

    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = [[WKUserContentController alloc] init];
    
    // 支持内嵌视频播放
    config.allowsInlineMediaPlayback = YES;
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ZB_SCREEN_WIDTH, ZB_SCREEN_HEIGHT-ZB_TABBAR_HEIGHT) configuration:config];
    
    [self.view addSubview:self.webView];
    self.webView.scrollView.delegate = self;
    
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    // 开始右滑返回手势
    self.webView.allowsBackForwardNavigationGestures = YES;
     ZBKLog(@"functionType:%zd",self.functionType);
    if (self.functionType==Details) {
       // NSString *HTMLData = @"<hn>Hello World</hn>";
        
       // [self.webView loadHTMLString:HTMLData baseURL:nil];
        
        
        NSURL *url = [NSURL URLWithString:self.model.weburl];
        NSError *error = nil;
        NSString *htmlUrl = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
        NSString * colorString = [NSString stringWithFormat:@"<head><style >body {background:black;}</style>"];
        NSArray *jsArray = [htmlUrl componentsSeparatedByString:@"<head>"];
        NSString* jsSource = [jsArray componentsJoinedByString: colorString];
        NSLog(@"jsSource:%@",jsSource);
        //  [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
        NSString *path = [[NSBundle mainBundle] bundlePath];  // 获取当前应用的根目录
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        
        [self.webView loadHTMLString:jsSource baseURL:baseURL];
      // [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.model.weburl]]];

         [self createToobar];
        
    }else if(self.functionType==Advertise){
        ZBKLog(@"self.url:%@",self.url);
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }
}

- (NSString *)keyedArchivePath{
    return [[[ZBCacheManager sharedInstance]ZBKitPath]stringByAppendingPathComponent:@"keyedArchive"];
}
- (void)createToobar{
    
   // [[ZBDataBaseManager sharedInstance]createTable:@"collection"];
    [[ZBCacheManager sharedInstance]createDirectoryAtPath:[self keyedArchivePath]];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setFrame:CGRectMake(0, ZB_SCREEN_HEIGHT - ZB_TABBAR_HEIGHT, ZB_SCREEN_WIDTH, ZB_TABBAR_HEIGHT)];

    [btn setTitle:@"收藏(添加/删除)" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor blackColor];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //看该条数据是否被收藏过
    //NSLog(@"%@",self.model.wid);
    if ([[ZBCacheManager sharedInstance]diskCacheExistsWithKey:self.model.wid path:[self keyedArchivePath]]) {
        btn.selected=YES;
        btn.titleLabel.alpha = 0.5;
    }
    [self.view addSubview:btn];
}
- (void)btnClicked:(UIButton *)sender{
    if (sender.selected==NO) {
        sender.selected = YES;
        //收藏数据
        NSLog(@"收藏数据");
  
        [[ZBCacheManager sharedInstance]storeContent:self.model forKey:self.model.wid path:[self keyedArchivePath] isSuccess:^(BOOL isSuccess) {
            if (isSuccess) {
                NSLog(@"添加成功");
            }else{
                NSLog(@"添加失败");
            }
        }];
        //为了区分按钮的状态
        sender.titleLabel.alpha = 0.5;
    }else{
        sender.selected =NO;
      
        [[ZBCacheManager sharedInstance]clearCacheForkey:self.model.wid path:[self keyedArchivePath] completion:^{
                NSLog(@"删除数据");
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
