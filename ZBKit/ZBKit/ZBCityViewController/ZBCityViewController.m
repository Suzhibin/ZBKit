//
//  ZBCityViewController.m
//  ZBKit
//
//  Created by NQ UEC on 2017/4/26.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ZBCityViewController.h"
#import "UIViewController+ZBKit.h"
//屏幕宽
#define SCREEN_WIDTH                ([UIScreen mainScreen].bounds.size.width)
//屏幕高
#define SCREEN_HEIGHT               ([UIScreen mainScreen].bounds.size.height)
@implementation ZBCityGroup

@end

@interface ZBCityViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) UITableView *cityTableView;

@end

@implementation ZBCityViewController
- (void)dealloc{
    self.cityArray=nil;
    self.cityTableView=nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=[NSString stringWithFormat:@"当前城市-%@" ,self.currentCity];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"cityGroups.plist" ofType:nil];
    NSArray *cityGroupArray = [NSArray arrayWithContentsOfFile:plistPath];

    for (NSDictionary *dic in cityGroupArray) {
        //声明一个空的CityGroup对象
        ZBCityGroup *cityGroup = [[ZBCityGroup alloc]init];
        //KVC绑定模型对象属性和字典key的关系
        [cityGroup setValuesForKeysWithDictionary:dic];
        [ self.cityArray addObject:cityGroup];
    }
    [self.view addSubview:self.cityTableView];

    [self itemWithTitle:@"返回" selector:@selector(dismiss) location:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   // 控制器使用的时候，就是点击了搜索框的时候
    return self.cityArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ZBCityGroup *cityGroup = self.cityArray[section];
    return cityGroup.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    ZBCityGroup *cityGroup =  self.cityArray[indexPath.section];
    cell.textLabel.text = cityGroup.cities[indexPath.row];
        
    return cell;

}
//返回section的头部文本
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    ZBCityGroup *cityGroup =  self.cityArray[section];
    return cityGroup.title;
}

//返回tableViewIndex数组
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {

    return [self.cityArray valueForKeyPath:@"title"];
    
}

//选中那一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZBCityGroup *cityGroup = self.cityArray[indexPath.section];
    NSString *cityName = cityGroup.cities[indexPath.row];
       //发送通知，包含参数
    if (self.cityBlock) {
        
       self.cityBlock(cityName);
    }
    if ([self.delegate respondsToSelector:@selector(cityName:)]) {
        [self.delegate cityName:cityName];
    }
    [self dismiss];
}

- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//懒加载
- (UITableView *)cityTableView{
    
    if (!_cityTableView) {
        _cityTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64,SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _cityTableView.delegate=self;
        _cityTableView.dataSource=self;
        _cityTableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _cityTableView.tableFooterView=[[UIView alloc]init];
    }
    return _cityTableView;
}

- (NSMutableArray *)cityArray {
    if (!_cityArray) {
        _cityArray = [[NSMutableArray alloc] init];
    }
    return _cityArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (self.isViewLoaded && !self.view.window) {
        self.view=nil;
        [self.cityArray removeAllObjects];
        self.cityArray=nil;
    }
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
