
//
//  DBViewController.m
//  ZBKit
//
//  Created by NQ UEC on 17/2/6.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "DBViewController.h"
#import "ZBKit.h"
#import "ListModel.h"
#import <UIImageView+WebCache.h>
#import "DetailsViewController.h"
@interface DBViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation DBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    if (_functionType==collectionTable) {
        self.dataArray = [[ZBDataBaseManager sharedInstance]getAllDataWithTable:@"collection"];
        self.title=@"收藏表";
    }else{
        self.dataArray=[[ZBDataBaseManager sharedInstance]getAllDataWithTable:@"user"];
        self.title=@"user表";
    }
    
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    NSLog(@"收藏新闻:%@",self.dataArray);
    NSLog(@"收藏新闻个数:%ld",self.dataArray.count );
    
    [self addItemWithTitle:@"编辑" selector:@selector(editItemClick:) location:NO];
}
- (void)editItemClick:(UIBarButtonItem *)item
{
    // 判断_tableView是否处于编辑状态!
    if (self.tableView.isEditing) {
        // 将_tableView 转为非编辑状态
        // _tableView.editing = NO;
        [self.tableView setEditing:NO animated:YES];
    } else {
        [self.tableView setEditing:YES animated:YES];
    }
}
#pragma mark tableView
// 返回indexPath对应的cell是什么编辑状态! (默认是删除)
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //返回删除
    return UITableViewCellEditingStyleDelete;
    
}
// 点击cell的编辑按钮时候调用!!
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListModel *model=[_dataArray objectAtIndex:indexPath.row];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 如果类型是删除
        NSMutableArray *array = (NSMutableArray *)self.dataArray;
        [array removeObjectAtIndex:indexPath.row];
        
        [[ZBDataBaseManager sharedInstance]table:@"collection" deleteDataWithItemId:model.wid isSuccess:^(BOOL isSuccess){
            if (isSuccess) {
                NSLog(@"删除成功");
            }else{
                NSLog(@"删除失败");
            }
        }];//删除对应文章id
    
        // 用_tableView 删除行刷新方法刷新显示
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
        
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *channelCell=@"channelCell";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:channelCell];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:channelCell];
    }
    ListModel *model=self.dataArray[indexPath.row];
    NSLog(@"title:%@",model.title);
    cell.textLabel.text=model.title;
    
    cell.detailTextLabel.text=[NSString stringWithFormat:@"发布时间:%@",model.date];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ListModel *model=[self.dataArray objectAtIndex:indexPath.row];
    DetailsViewController *detailsVC=[[DetailsViewController alloc]init];
    // detailsVC.urlString=model.link; //detailsVC.html=model.html;
    detailsVC.model=model;
    [self.navigationController pushViewController:detailsVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

//懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        
        _tableView.tableFooterView=[[UIView alloc]init];
    }
    return _tableView;
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
