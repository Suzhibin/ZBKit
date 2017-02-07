//
//  DetailsViewController.m
//  ZBKit
//
//  Created by NQ UEC on 17/1/23.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "DetailsViewController.h"
#import "ZBKit.h"
@interface DetailsViewController ()
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
    _webView.backgroundColor = [UIColor whiteColor];

    if (_functionType==Details) {
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.model.weburl]];
        [_webView loadRequest:request];
        [self.view addSubview:_webView];
        [self createToobar];
    
    }else{
        if (!self.url) {
            self.url = @"https://github.com/Suzhibin";
        }
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
        [_webView loadRequest:request];
        [self.view addSubview:_webView];
    }
    
   
}

- (void)createToobar{
    
    [[ZBDataBaseManager sharedInstance]createTable:@"collection"];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49);
    [btn setTitle:@"收藏(添加/删除 数据库)" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor blackColor];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //看该条数据是否被收藏过
    NSLog(@"%@",self.model.wid);
    if ([[ZBDataBaseManager sharedInstance] isCollectedWithTable:@"collection" itemId:self.model.wid]) {
        
        btn.selected=YES;
        //  [btn setTitleColor:[UIColor brownColor] forState:UIControlStateSelected];
        btn.titleLabel.alpha = 0.5;
    }

    [self.view addSubview:btn];
}
- (void)btnClicked:(UIButton *)sender{
    if (sender.selected==NO) {
        sender.selected = YES;
        //收藏数据
        NSLog(@"收藏数据");
        //储存的model 对象必须准守Codeing协议  在listModel里 用了NSObject+ZBCoding 的宏定义
        [[ZBDataBaseManager sharedInstance]table:@"collection" insertDataWithObj:self.model ItemId:self.model.wid isSuccess:^(BOOL isSuccess){
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
        //删除数据
          NSLog(@"删除数据");
        [[ZBDataBaseManager sharedInstance]table:@"collection"deleteDataWithItemId:self.model.wid isSuccess:^(BOOL isSuccess){
            if (isSuccess) {
                NSLog(@"删除成功");
            }else{
                NSLog(@"删除失败");
            }
        }];
     
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
