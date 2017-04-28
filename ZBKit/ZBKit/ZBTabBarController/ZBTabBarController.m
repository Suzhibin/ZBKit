//
//  ZBTabBarController.m
//  ZBKit
//
//  Created by NQ UEC on 2017/4/20.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ZBTabBarController.h"
#import "ZBNavigationController.h"
#import "HomeViewController.h"
#import "FirstViewController.h"
#import "FiveViewController.h"
#import "SettingViewController.h"

#import "NSBundle+ZBKit.h"
#import "ZBConstants.h"
#import "ZBTabBar.h"
#import "ZBTabBarItem.h"
#import "ViewController.h"
#import "DetailsViewController.h"
#import "ZBCityViewController.h"
#import "ZBNetworking.h"
#import "ZBWeatherView.h"
#import "ZBLocationManager.h"
@interface ZBTabBarController ()<UITabBarControllerDelegate>
@property (nonatomic,weak) UIViewController *lastViewController;
@property (nonatomic,strong) UIButton *middleButton;
@property (nonatomic,strong)ZBTabBarItem *tabBarItem;

@end

@implementation ZBTabBarController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tabbarPushToAd" object:nil];
}
+ (void)initialize
{
    UITabBarItem *appearance = [UITabBarItem appearance];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    [appearance setTitleTextAttributes:attrs forState:UIControlStateSelected];
    
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    //__weak typeof(self) weakSelf = self;
    [self createTabBar];
    
    ZBTabBar*tabbar=  [[ZBTabBar alloc] init];
    [tabbar.publishButton addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];//中间按钮点击事件
    /**
     *  利用 KVC 把系统的 tabBar 类型改为自定义类型。
     */
    [self setValue:tabbar forKeyPath:@"tabBar"];
    
    // 设置代理 监听tabBar上按钮点击
    self.delegate = self;
    _lastViewController = self.childViewControllers.firstObject;
    
    //点击广告链接 事件
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabbarPushToAd:) name:@"tabbarPushToAd" object:nil];
}

//弹出 中间ZBTabBarItem视图
-(void)publishClick{
    
    ZBTabBarItem *tabBarItem=[[ZBTabBarItem alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    // __weak typeof(self) weakSelf = self;
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *city = [userDefaultes objectForKey:@"city"];
    
    [tabBarItem.cityBtn setTitle:city forState:UIControlStateNormal];
    
    [self requestWeather:city];//请求天气
  
    self.tabBarItem=tabBarItem;
    
    /**
     点击城市列表按钮
     */
    [tabBarItem.cityBtn addTarget:self action:@selector(cityBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [tabBarItem.locationButton addTarget:self action:@selector(cityBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    //====================================================================
    [tabBarItem addItemWithTitle:@"文字" andIcon:[UIImage imageNamed:@"tabbar_compose_idea"] andSelectedBlock:^{
        
        ViewController *textVC = [[ViewController alloc] init];
        ZBNavigationController *nav = [[ZBNavigationController alloc] initWithRootViewController:textVC];
        ZBTabBarController * rootView = (ZBTabBarController *)[[UIApplication sharedApplication].delegate window].rootViewController;
        [rootView presentViewController:nav animated:YES completion:nil];
        
    }];
    
    [tabBarItem addItemWithTitle:@"相册" andIcon:[UIImage imageNamed:@"tabbar_compose_photo"] andSelectedBlock:^{
        
        NSLog(@"相册");
    }];
    [tabBarItem addItemWithTitle:@"拍摄" andIcon:[UIImage imageNamed:@"tabbar_compose_camera"] andSelectedBlock:^{
        NSLog(@"拍摄");
        
    }];
    [tabBarItem addItemWithTitle:@"签到" andIcon:[UIImage imageNamed:@"tabbar_compose_lbs"] andSelectedBlock:^{
        NSLog(@"签到");
        
    }];
    [tabBarItem addItemWithTitle:@"点评" andIcon:[UIImage imageNamed:@"tabbar_compose_review"] andSelectedBlock:^{
        NSLog(@"点评");
        
    }];
    [tabBarItem addItemWithTitle:@"更多" andIcon:[UIImage imageNamed:@"tabbar_compose_more"] andSelectedBlock:^{
        NSLog(@"更多");
        
    }];
    
    [tabBarItem show];
}

//点击 城市列表 事件
- (void)cityBtnTapped:(UIButton*)sender{
    ZBCityViewController *cityVC = [[ZBCityViewController alloc] init];
    cityVC.currentCity=sender.titleLabel.text;
    ZBNavigationController *nav = [[ZBNavigationController alloc] initWithRootViewController:cityVC];
    ZBTabBarController * rootView = (ZBTabBarController *)[[UIApplication sharedApplication].delegate window].rootViewController;
    [rootView presentViewController:nav animated:YES completion:nil];
     __weak typeof(self) weakSelf = self;
    cityVC.cityBlock=^(NSString *cityName){
        
        if ([cityName isEqualToString:weakSelf.tabBarItem.cityBtn.titleLabel.text]) {
            NSLog(@"城市没有变");
        }else{
            //重新赋值 并请求天气
            [weakSelf.tabBarItem.cityBtn setTitle:cityName forState:UIControlStateNormal];
            [weakSelf requestWeather:cityName];
        }
    };
}
//请求城市天气
- (void)requestWeather:(NSString *)cityName{
     __weak typeof(self) weakSelf = self;
    [[ZBURLSessionManager sharedInstance]requestWithConfig:^(ZBURLRequest *request) {
        request.urlString=[NSString stringWithFormat:@"https://api.thinkpage.cn/v3/weather/daily.json?key=osoydf7ademn8ybv&location=%@&language=zh-Hans&start=0&days=3",cityName];
        request.apiType=ZBRequestTypeRefresh;
    } success:^(id responseObj, apiType type) {
        if (type==ZBRequestTypeRefresh) {
            NSDictionary  *Obj = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
            NSArray *resultsArray = Obj[@"results"];
            for (NSDictionary *dic in resultsArray) {
//                NSString *cityName = dic[@"location"][@"name"];
                NSDictionary *todayDic =[dic[@"daily"] objectAtIndex:0];
//                NSString *tomorrowDic = (NSDictionary *)[dic[@"daily"] objectAtIndex:1];
//                NSString *afterTomorrowDic = (NSDictionary *)[dic[@"daily"] objectAtIndex:2];
                //根据请求下来的数据 改变UI
                [weakSelf.tabBarItem.weatherView addAnimationWithType:[dic[@"daily"] objectAtIndex:0][@"code_day"]];
                weakSelf.tabBarItem.weatherLabel.text= [NSString stringWithFormat:@"%@ %@℃ / %@℃",[todayDic objectForKey:@"text_day"],[todayDic objectForKey:@"high"],[todayDic objectForKey:@"low"]];;
            }
        }
    } failed:^(NSError *error) {
        ZBKLog(@"天气error:%@",error);
    }];
}

- (void)createTabBar{
    
    HomeViewController *home=[[HomeViewController alloc]init];
    [self setupChildViewController:home title:@"Home" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];
    
    FirstViewController *first=[[FirstViewController alloc]init];
    [self setupChildViewController:first title:@"ZBNetworking" image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon"];
    
    FiveViewController *five=[[FiveViewController alloc]init];
    [self setupChildViewController:five title:@"ZBCarouselView" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];
    
    SettingViewController *setting=[[SettingViewController alloc]
                                    init];
    [self setupChildViewController:setting title:@"ZBTableView" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];
    
}

- (void)setupChildViewController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    vc.title = title;
    vc.tabBarItem.image=[[UIImage imageNamed:image]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage=[[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // vc.tabBarItem.badgeValue =@"";//角标
    // vc.tabBarItem.imageInsets = UIEdgeInsetsMake(8, 0, -8, 0);//设置按钮上下
    [self addChildViewController:[[ZBNavigationController alloc] initWithRootViewController:vc]];
}
// tabBarItem是否可以选中
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
    if (_lastViewController == viewController) {
        //重复点击
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil userInfo:nil];
    }
       _lastViewController = viewController;
}

/*
 //点击tiem动画
 -(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
 {
 NSInteger index = [self.tabBar.items indexOfObject:item];
 [self animationWithIndex:index];
 }
 - (void)animationWithIndex:(NSInteger) index {
 NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
 for (UIView *tabBarButton in self.tabBar.subviews) {
 if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
 [tabbarbuttonArray addObject:tabBarButton];
 }
 }
 CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
 pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
 pulse.duration = 0.08;
 pulse.repeatCount= 1;
 pulse.autoreverses= YES;
 pulse.fromValue= [NSNumber numberWithFloat:0.7];
 pulse.toValue= [NSNumber numberWithFloat:1.3];
 [[tabbarbuttonArray[index] layer]
 addAnimation:pulse forKey:nil];
 }
 */

/*
 - (void)tabbarPushToAd:(NSNotification *)noti{
 
 DetailsViewController* detailsVC=[[DetailsViewController alloc]init];
 detailsVC.url=[noti.userInfo objectForKey:@"link"];
 detailsVC.functionType=tabbarAdvertise;
 ZBNavigationController *nav = [[ZBNavigationController alloc] initWithRootViewController:detailsVC];
 ZBTabBarController * rootView = (ZBTabBarController *)[[UIApplication sharedApplication].delegate window].rootViewController;
 [rootView presentViewController:nav animated:YES completion:nil];
 
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