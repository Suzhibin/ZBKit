//
//  FiveViewController.m
//  ZBKit
//
//  Created by NQ UEC on 17/3/31.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "FiveViewController.h"
#import "ZBKit.h"
@interface FiveViewController ()<ZBCarouselViewDelegate>
@property (nonatomic,strong)ZBCarouselView *carouselView;
@property (nonatomic,strong)ZBCarouselView *carouselView1;
@property (nonatomic,strong)ZBCarouselView *carouselView2;
@property (nonatomic,strong)UIView *loadingView;

@end

@implementation FiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"轮播";
    
     NSArray *arr = @[IMAGE1,IMAGE2,IMAGE3,];
     
     NSArray *describeArray = @[@"图片1", @"图片2",@"动态图"];
     
     self.carouselView = [[ZBCarouselView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 180)];
     //设置占位图片,须在设置图片数组之前设置,不设置则为默认占位图
     _carouselView.placeholderImage = [UIImage imageNamed:[NSBundle placeholderIcon]];
     //设置图片数组及图片描述文字
     _carouselView.imageArray = arr;
     _carouselView.describeArray = describeArray;
     //设置每张图片的停留时间，默认值为5s，最少为2s
     _carouselView.time = 2;
     //Block 优先级高于代理
    // __weak typeof(self) weakSelf = self;
     _carouselView.imageClickBlock = ^(NSInteger index){
     NSLog(@"Block点击了第%ld张图片", index);
        
     };
     //设置分页控件的图片,不设置则为系统默认
     //  [_carouselView setPageImage:[UIImage imageNamed:@"other"] andCurrentPageImage:[UIImage imageNamed:@"current"]];
     //设置分页控件的位置，默认为PositionBottomCenter
     _carouselView.pagePosition = PositionBottomRight;
     //设置图片切换的方式
     _carouselView.changeMode = ChangeModeFade;
     
     /**
     *  修改图片描述控件的外观，不需要修改的传nil
     *
     *  参数一 字体颜色，默认为白色
     *  参数二 字体，默认为13号字体
     *  参数三 背景颜色，默认为黑色半透明
     */
    
     UIColor *bgColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
     UIFont *font = [UIFont systemFontOfSize:15];
     UIColor *textColor = [UIColor greenColor];
     
     [_carouselView setDescribeTextColor:textColor font:font bgColor:bgColor];
     [self.view addSubview:_carouselView];
     
    
    
    
     self.carouselView1 = [[ZBCarouselView alloc] initWithFrame:CGRectMake(0, 300, SCREEN_WIDTH, 180)];
     //设置占位图片,须在设置图片数组之前设置,不设置则为默认占位图
     _carouselView1.placeholderImage = [UIImage imageNamed:@"zhanweitu.png"];
     
     //设置图片数组及图片描述文字
     _carouselView1.imageArray = arr;
     _carouselView1.titleArray = describeArray;
     //  _carouselView1.describeArray = describeArray;
     //设置分页控件的位置，默认为PositionBottomCenter
     _carouselView1.pagePosition = PositionBottomCenter;
     _carouselView1.time = 2;
     //用代理处理图片点击
     _carouselView1.delegate = self;
     //设置图片切换的方式
     _carouselView1.changeMode = ChangeModeDefault;
     [self.view addSubview:_carouselView1];
     
     
     self.loadingView=[[UIView alloc]initWithFrame:CGRectMake(100, 500, 200, 180)];
     [self.loadingView zb_animationloadingView];
     [self.view addSubview:self.loadingView];
    

}

 #pragma mark XRCarouselViewDelegate
- (void)carouselView:(ZBCarouselView *)carouselView clickImageAtIndex:(NSInteger)index {
 
    NSLog(@"Delegate点击了第%ld张图片", index);
 
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
