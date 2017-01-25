//
//  ThirdViewController.m
//  ZBKit
//
//  Created by NQ UEC on 17/1/23.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ThirdViewController.h"
#import "ZBDataBaseManager.h"
@interface ThirdViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.


    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    NSString *str = [format stringFromDate:[NSDate date]];
    NSLog(@"str:%@",str);

    
    [[ZBDataBaseManager sharedManager]createTable:@"collection"];
    NSString *wid=@"1";
    
    NSDictionary *user = @{@"id":wid, @"name": @"小明", @"age": @"10"};
    
    [[ZBDataBaseManager sharedManager]table:@"collection" insertDataWithObj:user ItemId:wid];
    
    UIButton * button =  [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(100, 70, 100, 30);
    [button setTitle:@"查询" forState:UIControlStateNormal];;
    button.backgroundColor=[UIColor brownColor];

    [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:button];

    [self.view addSubview:self.tableView];

  //  [[ZBDataBaseManager sharedManager]table:self.createTable.text updateDataWithObj:user itemId:];
    
    
    
  //  [[ZBDataBaseManager sharedManager]table:self.createTable.text deleteDataWithItemId:self.keyId.text];
    
    

  
}
- (void)btnClicked:(UIButton *)sender{
    
    self.dataArray= [[ZBDataBaseManager sharedManager]getAllDataWithTable:@"collection"];
    [self.tableView reloadData];
    /*
     [[ZBDataBaseManager sharedManager]getAllDataWithTable:self.createTable.text itemId:self.keyId
     .text data:^(NSArray *dataArray,BOOL isExist){
     
     if (isExist) {
     
     self.dataArray=[[NSArray alloc] initWithArray:dataArray];
     [self.tableView reloadData];
     NSLog(@"存在");
     NSLog(@"dataArray:%@",self.dataArray);
     }else{
     NSLog(@"不存在");
     }
     }];
     */

}

//懒加载
- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 264, self.view.frame.size.width, self.view.frame.size.height-264) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        
    }
    
    return _tableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden=@"iden";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:iden];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }

    cell.textLabel.text=[[self.dataArray objectAtIndex:indexPath.row]objectForKey:@"name"];
    
    
    return cell;
}
/*
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
*/



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
