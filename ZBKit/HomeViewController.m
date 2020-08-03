//
//  HomeViewController.m
//  ZBKit
//
//  Created by NQ UEC on 17/2/14.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "HomeViewController.h"
#import "DetailsViewController.h"
#import "SecondViewController.h"
#import "FirstViewController.h"
#import "FourViewController.h"
#import "FiveViewController.h"
#import "SixViewController.h"
#import "SevenViewController.h"
#import "EightViewController.h"
#import "YYFPSLabel.h"
#import "ZBDebug.h"
#import "VTMagic.h"
#import "UIViewController+XPModal.h"
#import "MenuViewController.h"
@interface HomeViewController ()<VTMagicViewDataSource, VTMagicViewDelegate,MenuViewControllerDelegate>

@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, strong) NSArray *menuList;
//@property (nonatomic,strong)UITableView *tableView;
//@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation HomeViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushtoad" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
//    self.dataArray=[[NSMutableArray alloc]initWithObjects:@"网络请求",@"图片操作/动画",@"嵌套",@"模型",@"常用工厂方法",@"放大镜",@"练习", nil];
//    [self.view addSubview:self.tableView];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    [self addChildViewController:self.magicController];
    [self.view addSubview:_magicController.view];
    [self integrateComponents];
    [self generateTestData];
     [_magicController.magicView reloadData];
    //点击广告链接 事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToAd:) name:@"pushtoad" object:nil];


    [[ZBDebug sharedInstance]enable];

}
#pragma mark - functional methods
- (void)integrateComponents {
     UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [rightButton addTarget:self action:@selector(subscribeAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitleColor:RGBACOLOR(169, 37, 37, 0.6) forState:UIControlStateSelected];
    [rightButton setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateNormal];
    [rightButton setTitle:@"+" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:28];
    rightButton.center = self.view.center;
    self.magicController.magicView.rightNavigatoinItem=rightButton;
}

#pragma mark - actions
- (void)subscribeAction:(UIButton *)sender {
    NSLog(@"searchAction");
    MenuViewController *vc=[[MenuViewController alloc]init];
    vc.dataArray=_menuList;
    vc.delegate=self;
    [self presentModalWithController:vc configBlock:^(XPModalConfiguration * _Nonnull config) {
        config.enableBackgroundAnimation=YES;
    } completion:nil];
}
- (void)didSelectItemAtIndex:(NSInteger)index{
    [self.magicController.magicView switchToPage:index animated:YES];
}
- (void)generateTestData {
    _menuList = @[@"推荐", @"热点", @"视频", @"论坛"];
}
#pragma mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    return _menuList;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
        [menuItem setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.f];
    }
    return menuItem;
}
- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    static NSString *pageId = @"page.identifier";
    UIViewController *webviewController = [magicView dequeueReusablePageWithIdentifier:pageId];
    if (!webviewController) {
        webviewController = [[UIViewController alloc] init];
    }
    return webviewController;
}
- (VTMagicController *)magicController {
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.view.translatesAutoresizingMaskIntoConstraints = NO;
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.sliderColor = RGBCOLOR(169, 37, 37);
        _magicController.magicView.switchStyle = VTSwitchStyleDefault;
       // _magicController.magicView.layoutStyle = VTLayoutStyleCenter;
        _magicController.magicView.headerHidden=NO;
        _magicController.magicView.headerHeight=STATUS_HEIGHT;
        _magicController.magicView.navigationHeight = 44.f;
        _magicController.magicView.againstStatusBar = YES;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
    }
    return _magicController;
}

- (void)pushToAd:(NSNotification *)noti{
 
     DetailsViewController* detailsVC=[[DetailsViewController alloc]init];
     detailsVC.url=[noti.userInfo objectForKey:@"link"];
     detailsVC.functionType=Advertise;
     [self.navigationController pushViewController:detailsVC animated:YES];
}
/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    static NSString *menuID=@"menu";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:menuID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:menuID];
            //设置点击cell不变色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text=self.dataArray [indexPath.row];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        FirstViewController *firstVC=[[FirstViewController alloc]init];
        [self.navigationController pushViewController:firstVC animated:YES];
    }
    if (indexPath.row==1) {
         SecondViewController*secondVC = [[SecondViewController alloc] init];
        [self.navigationController pushViewController:secondVC animated:YES];
    }
    if (indexPath.row==2) {
        ThirdViewController*ThirdVC = [[ThirdViewController alloc] init];
        [self.navigationController pushViewController:ThirdVC animated:YES];
    }
    if (indexPath.row==3) {
        FiveViewController*toolVC = [[FiveViewController alloc] init];

        [self.navigationController pushViewController:toolVC animated:YES];
    }
    if (indexPath.row==4) {
        SixViewController *sixVC=[[SixViewController alloc]init];
        [self.navigationController pushViewController:sixVC animated:YES];
    }
    if (indexPath.row==5) {
        EightViewController *eVC=[[EightViewController alloc]init];
        [self.navigationController pushViewController:eVC animated:YES];
    }
    if (indexPath.row==6) {
        SevenViewController*itemVC = [[SevenViewController alloc] init];
            
        [self.navigationController pushViewController:itemVC animated:YES];
    }
}
//懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, ZB_SafeAreaTopHeight+44,ZB_SCREEN_WIDTH-100, ZB_SCREEN_HEIGHT-(ZB_SafeAreaTopHeight+44+ZB_TABBAR_HEIGHT)) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.tableFooterView=[[UIView alloc]init];
    }
    return _tableView;
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
