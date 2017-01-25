//
//  DetailsViewController.m
//  ZBKit
//
//  Created by NQ UEC on 17/1/23.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "DetailsViewController.h"
#import "ZBDataBaseManager.h"
@interface DetailsViewController ()
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.backgroundColor = [UIColor whiteColor];
    if (!self.url) {
        self.url = @"https://github.com/Suzhibin";
    }
    NSLog(@"self.url:%@",self.url);
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
    if (_functionType==Details) {
        [self createToobar];
    }

    

}
- (void)createToobar{
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49);
        [btn setTitle:@"收藏" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.backgroundColor=[UIColor whiteColor];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            //看该条数据是否被收藏过
            
       // if ([[ZBDataBaseManager sharedManager] isCollectedWithTable:@"collection" itemId:self.model.wid]) {
                
                btn.selected=YES;
                //  [btn setTitleColor:[UIColor brownColor] forState:UIControlStateSelected];
                btn.titleLabel.alpha = 0.5;
       //
    [self.view addSubview:btn];
}
- (void)btnClicked:(UIButton *)sender
{
   
    if (sender.selected==NO) {
        sender.selected = YES;
        
        //收藏数据
        //储存的model 对象必须准守Codeing协议  这里用了MJExtension 的宏定义
      //  [[ZBDataBaseManager sharedManager]table:@"collection" insertDataWithObj:self.model ItemId:self.model.wid];
        sender.enabled = NO;
        //为了区分按钮的状态
        sender.titleLabel.alpha = 0.5;
    }else{
        sender.selected =NO;
        //删除数据
      //   [[ZBDataBaseManager sharedManager]table:@"collection"deleteDataWithItemId:self.model.title];
        sender.enabled = YES;
        //为了区分按钮的状态
        sender.titleLabel.alpha = 1;
        
    }
    
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
