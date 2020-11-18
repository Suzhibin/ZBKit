//
//  DownloadManagerViewController.m
//  ZBKit
//
//  Created by Suzhibin on 2020/8/12.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import "DownloadManagerViewController.h"
#import "ZBDataBaseManager.h"
#import "ZBMacros.h"
#import "ZBNetworking.h"
#import "DownloadInfoCell.h"
@interface DownloadManagerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,assign)NSUInteger identifier;
@property (nonatomic,strong)NSURLSessionDownloadTask *downloadTask;
@property (nonatomic,copy)NSString * url;
@end

@implementation DownloadManagerViewController
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSArray *arr = [[ZBDataBaseManager sharedInstance]getAllDataWithTable:@"DownloadList"];
    NSLog(@"arr:%@",arr);
    [self.dataArray removeAllObjects];
    [arr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.dataArray addObject:[obj objectForKey:@"redactedDescription"]];
    }];
         
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

- (void)editItemClick:(UIButton *)sender{
    sender.selected=!sender.selected;
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
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    //返回删除
    return UITableViewCellEditingStyleDelete;
}
// 点击cell的编辑按钮时候调用!!
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *url=[self.dataArray objectAtIndex:indexPath.row];
        
    if (editingStyle == UITableViewCellEditingStyleDelete) {
            // 如果类型是删除
    NSMutableArray *array = (NSMutableArray *)self.dataArray;
    [array removeObjectAtIndex:indexPath.row];

    [[ZBDataBaseManager sharedInstance]table:@"DownloadList" deleteObjectItemId:url isSuccess:^(BOOL isSuccess){
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
    DownloadInfoCell*cell=[tableView dequeueReusableCellWithIdentifier:channelCell];
    if (cell==nil) {
        cell=[[DownloadInfoCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:channelCell];
    }
    NSString *url=self.dataArray[indexPath.row];
    cell.url=url;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    self.url=self.dataArray[indexPath.row];
//    [self downLoadRequest:self.url];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]init];
    view.backgroundColor=[UIColor yellowColor];
    UIButton*rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame=CGRectMake(10, 10, 40, 40);
    if (@available(iOS 13.0, *)) {
        UIImage *image=[[UIImage systemImageNamed:@"trash"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
              
        UIImage *selectedImage=[[UIImage systemImageNamed:@"trash.fill"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
              
        [rightButton setImage:image forState:UIControlStateNormal];
        [rightButton setImage:selectedImage forState:UIControlStateSelected];
    }else{
        [rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    }
    [rightButton addTarget:self action:@selector(editItemClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:rightButton];
    
    UIButton*suspButton = [UIButton buttonWithType:UIButtonTypeCustom];
    suspButton.frame=CGRectMake(100, 10, 40, 40);
    if (@available(iOS 13.0, *)) {
        UIImage *image=[[UIImage systemImageNamed:@"pause"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
              
        UIImage *selectedImage=[[UIImage systemImageNamed:@"pause.fill"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
              
        [suspButton setImage:image forState:UIControlStateNormal];
        [suspButton setImage:selectedImage forState:UIControlStateSelected];
    }else{
        [suspButton setTitle:@"暂停" forState:UIControlStateNormal];
    }
    [suspButton addTarget:self action:@selector(suspButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:suspButton];
    
    UIButton*startButton = [UIButton buttonWithType:UIButtonTypeCustom];
       startButton.frame=CGRectMake(200, 10, 40, 40);
       if (@available(iOS 13.0, *)) {
           UIImage *image=[[UIImage systemImageNamed:@"play"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                 
           UIImage *selectedImage=[[UIImage systemImageNamed:@"play.fill"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                 
           [startButton setImage:image forState:UIControlStateNormal];
           [startButton setImage:selectedImage forState:UIControlStateSelected];
       }else{
           [startButton setTitle:@"开始" forState:UIControlStateNormal];
       }
       [startButton addTarget:self action:@selector(startButtonClick) forControlEvents:UIControlEventTouchUpInside];
       [view addSubview:startButton];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
 */
//懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ZB_SCREEN_WIDTH, ZB_SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
            
        _tableView.tableFooterView=[[UIView alloc]init];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
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
