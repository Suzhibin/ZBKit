//
//  EightViewController.m
//  ZBKit
//
//  Created by NQ UEC on 2018/9/20.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "EightViewController.h"

@interface EightViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UIScrollView *mainScroll;
@property (strong, nonatomic) UIScrollView *subScroll;
@property (strong, nonatomic) UITableView *tableView1;
@property (strong, nonatomic) UITableView *tableView2;
@property (strong, nonatomic) UITableView *tableView3;
@end

@implementation EightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    [self createScroll];
}
- (void)createScroll{
    UIScrollView *mainScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, ZB_STATUS_HEIGHT+44, ZB_SCREEN_WIDTH, ZB_SCREEN_HEIGHT-(ZB_STATUS_HEIGHT+44))];
    mainScroll.backgroundColor=[UIColor redColor];
     mainScroll.contentSize = CGSizeMake(ZB_SCREEN_WIDTH , ZB_SCREEN_HEIGHT);
    [self.view addSubview:mainScroll];
    self.mainScroll=mainScroll;
    
    UIScrollView *subScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, ZB_STATUS_HEIGHT+44+200, ZB_SCREEN_WIDTH, ZB_SCREEN_HEIGHT-(ZB_STATUS_HEIGHT+44))];
    subScroll.contentSize = CGSizeMake(ZB_SCREEN_WIDTH * 3, ZB_SCREEN_HEIGHT);
    subScroll.backgroundColor=[UIColor orangeColor];
    subScroll.bounces=NO;
    subScroll.pagingEnabled = YES;
    [mainScroll addSubview:subScroll];
    self.subScroll =subScroll;

    _tableView1=[[UITableView alloc]initWithFrame:CGRectMake(0,0, ZB_SCREEN_WIDTH, ZB_SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView1.backgroundColor=[UIColor blueColor];
    _tableView1.delegate=self;
    _tableView1.dataSource=self;
    _tableView1.tableFooterView=[[UIView alloc]init];
    [subScroll addSubview:_tableView1];
    
    _tableView2=[[UITableView alloc]initWithFrame:CGRectMake(ZB_SCREEN_WIDTH,0, ZB_SCREEN_WIDTH, ZB_SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView2.backgroundColor=[UIColor orangeColor];
    _tableView2.delegate=self;
    _tableView2.dataSource=self;
    _tableView2.tableFooterView=[[UIView alloc]init];
        [subScroll addSubview:_tableView2];
    
    _tableView3=[[UITableView alloc]initWithFrame:CGRectMake(ZB_SCREEN_WIDTH*2,0, ZB_SCREEN_WIDTH, ZB_SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView3.backgroundColor=[UIColor yellowColor];
    _tableView3.delegate=self;
    _tableView3.dataSource=self;
    _tableView3.tableFooterView=[[UIView alloc]init];
      [subScroll addSubview:_tableView3];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_tableView1) {
        return 10;
    }else if(tableView==_tableView2){
        return 15;
    }else{
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_tableView1) {
        static NSString *menuID=@"menu";
        
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:menuID];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:menuID];
            //设置点击cell不变色
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text=@"_tableView1";
        
        return cell;
    }else if (tableView==_tableView2){
        static NSString *menuID=@"menu2";
        
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:menuID];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:menuID];
            //设置点击cell不变色
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text=@"_tableView2";
        return cell;
    }else{
        static NSString *menuID=@"menu3";
        
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:menuID];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:menuID];
            //设置点击cell不变色
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text=@"_tableView3";
        return cell;
    }
}
#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
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
