//
//  ZBDebugNetWorkDetailViewController.m
//  ZBKit
//
//  Created by NQ UEC on 2018/4/25.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "ZBDebugNetWorkDetailViewController.h"
#import "ZBNetworking.h"
#import "ListModel.h"
#import "ZBMacros.h"
@interface ZBDebugNetWorkDetailViewController ()
@property (strong, nonatomic) UITextView *contentTextView;
@property (strong, nonatomic) UILabel *urlLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *codeLabel;
@end

@implementation ZBDebugNetWorkDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.view.backgroundColor=[UIColor blackColor];
    [self createUI];

    self.urlLabel.text=self.URLString;
        TICK
    [ZBRequestManager requestWithConfig:^(ZBURLRequest *request) {
        request.url=self.URLString;
        request.apiType=ZBRequestTypeRefresh;
    } success:^(id responseObject,ZBURLRequest *request) {
        self.timeLabel.text=[NSString stringWithFormat:@"请求时间:%.2f 秒", CFAbsoluteTimeGetCurrent() - start];

        self.contentTextView.text=[NSString stringWithFormat:@"%@",responseObject];
        self.codeLabel.text=@"请求成功";
        self.timeLabel.textColor=[UIColor greenColor];
        self.codeLabel.textColor=[UIColor greenColor];
    } failure:^(NSError *error) {
        if (error.code==NSURLErrorCancelled)return;
        if (error.code==NSURLErrorTimedOut) {
    
            self.timeLabel.text=@"code:-1001";
            self.codeLabel.text=@"请求超时";
        }else{
            self.timeLabel.text=[NSString stringWithFormat:@"code:%ld",error.code];
            self.codeLabel.text=@"请求失败";
        }
        self.codeLabel.textColor=[UIColor redColor];
        self.timeLabel.textColor=[UIColor redColor];
    }];
    
}
- (void)createUI{
    
    NSDate *date = [NSDate date]; // 获得时间对象

    NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
    [forMatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [forMatter stringFromDate:date];
  
    UILabel *dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, ZB_SCREEN_WIDTH-105, 20)];
    dateLabel.text=dateStr;
    dateLabel.textColor=[UIColor greenColor];
    dateLabel.backgroundColor=[UIColor blackColor];
    dateLabel.numberOfLines=0;
    dateLabel.font=[UIFont systemFontOfSize:12];
    [self.view addSubview:dateLabel];
    
    UILabel *urlLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 20, ZB_SCREEN_WIDTH-105, 80)];
    urlLabel.textColor=[UIColor whiteColor];
    urlLabel.backgroundColor=[UIColor blackColor];
    urlLabel.numberOfLines=0;
    urlLabel.font=[UIFont systemFontOfSize:12];
    [self.view addSubview:urlLabel];
    self.urlLabel=urlLabel;
    
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(ZB_SCREEN_WIDTH-100, 0, 100, 50)];
    timeLabel.backgroundColor=[UIColor colorWithRed:31/255.0 green:33/255.0 blue:36/255.0 alpha:1.0];
    timeLabel.numberOfLines=0;
    timeLabel.textAlignment=NSTextAlignmentCenter;
    timeLabel.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:timeLabel];
    self.timeLabel=timeLabel;
    
    UILabel *codeLabel=[[UILabel alloc]initWithFrame:CGRectMake(ZB_SCREEN_WIDTH-100, 51, 100, 49)];
    codeLabel.backgroundColor=[UIColor colorWithRed:31/255.0 green:33/255.0 blue:36/255.0 alpha:1.0];
    codeLabel.numberOfLines=0;
    codeLabel.textAlignment=NSTextAlignmentCenter;
    codeLabel.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:codeLabel];
    self.codeLabel=codeLabel;
    self.automaticallyAdjustsScrollViewInsets = NO;
    UITextView *contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 100, ZB_SCREEN_WIDTH, ZB_SCREEN_HEIGHT-(ZB_SafeAreaTopHeight+ZB_TABBAR_HEIGHT+100+44))];
    //contentTextView.editable = NO;
    contentTextView.alwaysBounceVertical = YES;
    contentTextView.textColor=[UIColor whiteColor];
    contentTextView.textAlignment = NSTextAlignmentLeft;
    contentTextView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:contentTextView];
    self.contentTextView=contentTextView;
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
