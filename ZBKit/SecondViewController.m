//
//  SecondViewController.m
//  ZBKit
//
//  Created by NQ UEC on 17/1/22.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *button;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *imageArray = @[@"http://img04.tooopen.com/images/20130701/tooopen_10055061.jpg",@"http://img06.tooopen.com/images/20161214/tooopen_sy_190570171299.jpg"];
    NSString *imageUrl = imageArray[arc4random() % imageArray.count];
    
    self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 350)];
    self.imageView.userInteractionEnabled = YES;
    //下载图片  此图片缓存没有计算在设置页面显示大小和清除操作
    [ZBImageDownloader downloadImageUrl:imageUrl completion:^(UIImage *image){
        self.imageView.image=image;
    }];
    
    [self.view addSubview: self.imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.imageView addGestureRecognizer:tap];
    
    NSArray *titleArray=[NSArray arrayWithObjects:@"垂直翻转",@"水平翻转",@"灰度图",@"截取图上半部",@"向左",@"向右",@"向下",@"平铺图片",@"给view截图",@"加水印",@"清除图片缓存",@"设置圆形",nil];
    CGFloat wSpace = (SCREEN_WIDTH-57*4)/5;
    CGFloat hSpace = (SCREEN_HEIGHT-64-4*100)/5;
    for (int i = 0; i<titleArray.count; i++) {
        self.button =  [UIButton buttonWithType:UIButtonTypeCustom];
        //  [btn setTitle:array[i]  forState:UIControlStateNormal];
        [self.button setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
        self.button.tag = 100+i;
        self.button.backgroundColor=[UIColor brownColor];
        //[btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.button.titleLabel.textAlignment=NSTextAlignmentCenter;
        self.button.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        //九宫格界面布局的小算法: 横向:控件的下标%横向的最大数目;纵向:控件的下标/纵向的最大数目
        [self.button setFrame:CGRectMake(wSpace+(i%4)*(wSpace+50),380+ hSpace+(i/4)*(hSpace), 80, 30)];
        [self.view addSubview:self.button];
    }
    
}

- (void)handleTap:(UITapGestureRecognizer *)tap{
    
    CGPoint point = [tap locationInView:tap.view];
    
    CGPoint pointInImage = CGPointMake(point.x * self.imageView.image.size.width / self.imageView.frame.size.width, point.y * self.imageView.image.size.height / self.imageView.frame.size.height);
    
    self.view.backgroundColor = [self.imageView.image editColorAtPixel:pointInImage];//把图片像素颜色给view
}

- (void)btnClicked:(UIButton *)sender{
    
    switch (sender.tag) {
        case 100:
            self.imageView.image = [self.imageView.image editFlipVertical];//垂直翻转
            break;
        case 101:
            self.imageView.image = [self.imageView.image editFlipHorizontal];//水平翻转
            break;
        case 102:
            self.imageView.image = [self.imageView.image editGrayImage];//灰度图
            break;
        case 103:
            self.imageView.image = [self.imageView.image editSubImageWithRect:CGRectMake(0, 0,self.imageView.image.size.width, self.imageView.image.size.height / 2)];//截图
            break;
        case 104:
            self.imageView.image = [self.imageView.image editRotate:UIImageOrientationLeft];
            break;
        case 105:
            self.imageView.image = [self.imageView.image editRotate:UIImageOrientationRight];
            break;
        case 106:
            self.imageView.image = [self.imageView.image editRotate:UIImageOrientationDown];
            break;
        case 107:
            self.imageView.image = [self.imageView.image editTiledImageWithSize:CGSizeMake(self.imageView.image.size.width * 4, self.imageView.image.size.width * 4)];//平铺
            break;
        case 108:
            self.imageView.image = [self.imageView.image editViewConversionImage:self.view];//截屏幕
            break;
        case 109:
            self.imageView.image = [self.imageView.image editImageWithTitle:@"https://github.com/Suzhibin/ZBKit" fontSize:30];//加水印
            break;
        case 110:
            [ZBImageDownloader clearImageFile];//此图片缓存没有在设置页面显示大小和清除操作
            break;
            
        case 111:
             self.imageView.image =  [self.imageView.image circleImage];;//
          
            break;
            
        default:
            break;
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
