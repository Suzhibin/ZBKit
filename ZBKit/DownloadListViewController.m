//
//  DownloadListViewController.m
//  ZBKit
//
//  Created by Suzhibin on 2020/8/12.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import "DownloadListViewController.h"
#import "ZBMacros.h"
#import "ZBKit.h"
#import "ZBDataBaseManager.h"
@interface DownloadListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *listTableView;

@property (nonatomic,strong)NSMutableArray *listArray;
@end

@implementation DownloadListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
     [[ZBDataBaseManager sharedInstance]createTable:@"DownloadList"];
    
    [self.view addSubview:self.listTableView];
    [self.listArray addObject:@"https://fcvideo.cdn.bcebos.com/smart/f103c4fc97d2b2e63b15d2d5999d6477.mp4"];
    
    [self.listArray addObject:@"http://1252463788.vod2.myqcloud.com/95576ef5vodtransgzp1252463788/28742df34564972819219071568/master_playlist.m3u8"];
    [self.listArray addObject:@"https://qd.myapp.com/myapp/qqteam/pcqq/PCQQ2020.exe"];
    [self.listArray addObject:@"http://cdn2.ime.sogou.com/8829b78d77d7b66f1af17f9bd5f54139/5e240479/dl/index/1574950329/sogou_mac_56b.zip"];
    
    [self.listTableView reloadData];
}
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *listID=@"list";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:listID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listID];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text=[self.listArray objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *url=[self.listArray objectAtIndex:indexPath.row];
    if ([[ZBDataBaseManager sharedInstance]table:@"DownloadList" isExistsWithItemId:url]) {
        [ZBToast showCenterWithText:@"已经添加"];
    }else{
        [[ZBDataBaseManager sharedInstance] table:@"DownloadList" insertObj:url ItemId:url isSuccess:^(BOOL isSuccess) {
            if (isSuccess==YES) {
                [ZBToast showCenterWithText:@"添加成功"];
            }
        }];
    }
    
}
//懒加载
- (UITableView *)listTableView{
    
    if (!_listTableView) {
        _listTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0,ZB_SCREEN_WIDTH, ZB_SCREEN_HEIGHT-(ZB_SafeAreaTopHeight+44+ZB_TABBAR_HEIGHT)) style:UITableViewStylePlain];
        _listTableView.delegate=self;
        _listTableView.dataSource=self;
        _listTableView.tableFooterView=[[UIView alloc]init];
    }
    return _listTableView;
}
- (NSMutableArray *)listArray {
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc] init];
    }
    return _listArray;
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
