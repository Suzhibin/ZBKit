//
//  ThirdViewController.m
//  ZBKit
//
//  Created by NQ UEC on 17/1/23.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ThirdViewController.h"
#import "ZBKit.h"
#import "DBViewController.h"
#import "ListModel.h"
NSString *const user=@"user";
@interface ThirdViewController ()
@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UILabel *sizelabel;
@property (nonatomic,strong)UILabel *countlabel;
@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];

  //  self.title=@"数据库操作";
    
    __weak typeof(self) weakSelf = self;
    
    self.label=[ZBControlTool createLabelWithFrame:CGRectMake(150, 130, 150, 40) text:@"" tag:0];
    
    [self.view addSubview: self.label];
    
    [[ZBDataBaseManager sharedInstance]createTable:user isSuccess:^(BOOL isSuccess) {
        if (isSuccess) {
            NSString *str=[NSString stringWithFormat:@"创建%@表成功",user];
            weakSelf.label.text=str;
        }else{
            NSString *str=[NSString stringWithFormat:@"创建%@表失败",user];
            weakSelf.label.text=str;
        }
    }];
    
    NSArray *array=[NSArray arrayWithObjects:@"添加数据",@"更新数据",@"删除数据", nil];
    
    for (int i=0; i<array.count; i++) {

        UIButton *button=[ZBControlTool createButtonWithFrame:CGRectMake(20, 100+40*i, 100, 40) title:[array objectAtIndex:i] target:self action:@selector(btnClicked:) tag:1000+i];
        
        [self.view addSubview:button];
    }
    
    
    NSArray *array1=[NSArray arrayWithObjects:@"collection",user, nil];
    
    for (int i=0; i<array1.count; i++) {
        float count=[[ZBDataBaseManager sharedInstance]getDBCountWithTable:[array1 objectAtIndex:i]];
        NSString *countString= [NSString stringWithFormat:@"%@表数据个数:%.f",[array1 objectAtIndex:i],count];
        self.countlabel=[ZBControlTool createLabelWithFrame:CGRectMake(30, 240+40*i, 200, 40) text:countString tag:100+i];
        [self.view addSubview:self.countlabel];
    }
    
    for (int i=0; i<array1.count; i++) {
        
        UIButton *button1=[ZBControlTool createButtonWithFrame:CGRectMake(250, 240+40*i, 100, 30) title:[array1 objectAtIndex:i] target:self action:@selector(button1Clicked:) tag:2000+i];
        button1.backgroundColor=[UIColor redColor];
        
        [self.view addSubview:button1];
    }
    
    float size=[[ZBDataBaseManager sharedInstance]getDBSize];
    size=size/1000.0/1000.0;
    NSString *sizeString= [NSString stringWithFormat:@"数据库大小:%.2fM",size];
    self.sizelabel=[ZBControlTool createLabelWithFrame:CGRectMake(30, 320, 150, 40) text:sizeString tag:0];
    [self.view addSubview:self.sizelabel];
    
    UIButton *button2=[ZBControlTool createButtonWithFrame:CGRectMake(30, 380, 150, 30) title:@"清除user表所有数据" target:self action:@selector(button2Clicked:) tag:0];
    button2.backgroundColor=[UIColor redColor];
        
    [self.view addSubview:button2];
    
   

}

- (void)button2Clicked:(UIButton *)sender{

    [[ZBDataBaseManager sharedInstance]cleanDBWithTable:user];
    float count=[[ZBDataBaseManager sharedInstance]getDBCountWithTable:user];
    NSString *countString= [NSString stringWithFormat:@"%@表数据个数:%.f",user,count];
    self.countlabel = (UILabel *)[self.view viewWithTag:101];
    self.countlabel.text=countString;

}

- (void)button1Clicked:(UIButton *)sender{
    if (sender.tag==2000) {
        DBViewController *dbVC=[[DBViewController alloc]init];
        dbVC.functionType=collectionTable;
        [self.navigationController pushViewController:dbVC animated:YES];
    }else if(sender.tag==2001){
        DBViewController *dbVC1=[[DBViewController alloc]init];
        dbVC1.functionType=userTable;
        [self.navigationController pushViewController:dbVC1 animated:YES];
    }
}

- (void)btnClicked:(UIButton *)sender{
    
     __weak typeof(self) weakSelf = self;
    
    ListModel *model=[[ListModel alloc]init];
    model.title=@"xiaoming";
    model.wid=@"1";
    model.date=@"2016";
   
    if (sender.tag==1000) {
        if ([[ZBDataBaseManager sharedInstance]isCollectedWithTable:user itemId:model.wid]) {
             weakSelf.label.text=@"数据已存在";
        }else{
            [[ZBDataBaseManager sharedInstance]table:user insertDataWithObj:model ItemId:model.wid isSuccess:^(BOOL isSuccess) {
                if (isSuccess) {

                    weakSelf.label.text=@"保存成功";
                }else{
                    weakSelf.label.text=@"保存失败";
                }
            }];
            float count=[[ZBDataBaseManager sharedInstance]getDBCountWithTable:user];
            NSString *countString= [NSString stringWithFormat:@"%@表数据个数:%.f",user,count];
            self.countlabel = (UILabel *)[self.view viewWithTag:101];
            self.countlabel.text=countString;
        }

    }else if(sender.tag==1001){
        model.title=@"honghong";
        model.wid=@"1";
        model.date=@"2017";
        
        [[ZBDataBaseManager sharedInstance]table:user updateDataWithObj:model itemId:model.wid isSuccess:^(BOOL isSuccess) {
            if (isSuccess) {
                weakSelf.label.text=@"更新成功";
            }else{
                weakSelf.label.text=@"更新失败";
            }
        }];

    
    }else if(sender.tag==1002){
        [[ZBDataBaseManager sharedInstance]table:user deleteDataWithItemId:@"1" isSuccess:^(BOOL isSuccess) {
            if (isSuccess) {
                weakSelf.label.text=@"删除成功";
            }else{
                weakSelf.label.text=@"删除失败";
            }
        }];
        
        float count=[[ZBDataBaseManager sharedInstance]getDBCountWithTable:user];
        NSString *countString= [NSString stringWithFormat:@"%@表数据个数:%.f",user,count];
        self.countlabel = (UILabel *)[self.view viewWithTag:101];
        self.countlabel.text=countString;
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
