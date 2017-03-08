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
@property (strong, nonatomic) UIImageView *imageView1;
@property (strong, nonatomic) UIButton *button;

@end

@implementation SecondViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title=@"图片操作";
    
    //下个runloop
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(-30,640, 200, 30)];
        
        label1.textAlignment=NSTextAlignmentLeft;
        label1.tag=4000;
        label1.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:label1];
        
        UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(130,680, 200, 30)];
        
        label2.textAlignment=NSTextAlignmentLeft;
        label2.tag=5000;
        label2.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:label2];
        
        NSArray *imageArray = @[IMAGE1,IMAGE2];
        NSString *imageUrl = imageArray[arc4random() % imageArray.count];
        
        self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 240)];
        self.imageView.userInteractionEnabled = YES;
        
        [self.imageView zb_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"zhanweitu"] completion:^(UIImage *image) {
            
            float imageSize=[[ZBImageDownloader sharedInstance] imageFileSize];
            label1.text=[NSString stringWithFormat:@"缓存图片大小:%@",[[ZBCacheManager sharedInstance] fileUnitWithSize:imageSize]];
            
            float count=[[ZBImageDownloader sharedInstance] imageFileCount];
            label2.text=[NSString stringWithFormat:@"缓存图片数量:%.f",count];
            
            [label1 zb_animatedViewMoveWithRightX:60];//右平移 -30-60=30；
            [label2 zb_animatedViewMoveWithLeftX:100];//左平移 130-100=30；

        }];
        
        /*
        //下载图片
        [[ZBImageDownloader sharedInstance]  downloadImageUrl:imageUrl completion:^(UIImage *image){
     
            self.imageView.image=image;
            
            float imageSize=[[ZBImageDownloader sharedInstance] imageFileSize];
            label1.text=[NSString stringWithFormat:@"缓存图片大小:%@",[[ZBCacheManager sharedInstance] fileUnitWithSize:imageSize]];
            
            float count=[[ZBImageDownloader sharedInstance] imageFileCount];
            label2.text=[NSString stringWithFormat:@"缓存图片数量:%.f",count];
            
            [label1 animatedViewMoveWithRightX:60];//右平移 -30-60=30；
            [label2 animatedViewMoveWithLeftX:100];//左平移 130-100=30；
            
        }];
         */
        [self.view addSubview:self.imageView];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.imageView addGestureRecognizer:tap];
        
        NSArray *titleArray=[NSArray arrayWithObjects:@"垂直翻转",@"水平翻转",@"灰度图",@"截取图上半部",@"向左",@"向右",@"向下",@"加水印",@"给view截图",@"平铺图片",@"圆形并浮动",@"小鸟Game over",@"透明度",@"压缩大小",nil];
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
            [self.button setFrame:CGRectMake(wSpace+(i%4)*(wSpace+50),260+ hSpace+(i/4)*(hSpace), 80, 30)];
            
            CGPoint center = self.button.center;
            CGPoint startCenter = self.button.center;
            startCenter.y += SCREEN_HEIGHT;
            self.button.center = startCenter;
            [self.button zb_circleView];//圆角
            [self.button zb_animatedDampingWithCenter:center];//弹簧效果
            [self.button zb_animationFloating];//浮动动画
            [self.view addSubview:self.button];
        }
        
        NSArray *array=[NSArray arrayWithObjects:@"清除所有图片缓存",@"清除某一个图片缓存",nil];
        
        for (int i = 0; i<array.count; i++) {
            
            UIButton *button1=[ZBControlTool createButtonWithFrame:CGRectMake(250, (SCREEN_HEIGHT+40)+40*i, 150, 30) title:[array objectAtIndex:i] target:self action:@selector(button1Clicked:) tag:2000+i];
            [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button1.backgroundColor=[UIColor brownColor];
            [button1 zb_animatedViewMoveWithUpY:130];//上升
            [self.view addSubview:button1];
        }
        
        self.imageView1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"DOVE 1"]];
        self.imageView1.frame=CGRectMake(100, 20, 50, 50);
        NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:18];
        for (int i=1; i<=18; i++) {
            NSString *imageName = [NSString stringWithFormat:@"DOVE %d",i];
            UIImage *image = [UIImage imageNamed:imageName];
            [images addObject:image];
        }
        [self.imageView1 zb_animatedViewMoveWithDownY:120];//下降
       
        self.imageView1.animationImages = images;
        // 设置imageView的动画时间为N秒 (N秒遍历显示全部图片)
        self.imageView1.animationDuration = images.count*0.1;
        // 设置imageView的动画重复次数，如果为0，则不限次数!!
        self.imageView1.animationRepeatCount = 0;
        [self.imageView1 startAnimating];//开始
        //[imageView1 stopAnimating];//暂停
        [self.view addSubview:self.imageView1];
    });
}

#pragma mark - UITouch方法
// 用户触碰时自动调用的方法
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // 获取到触碰的对象
    UITouch *touch = [touches anyObject];
    // 获取我们触碰的点得坐标
    CGPoint point = [touch locationInView:self.view];
    
    [self.imageView1 zb_animatedDampingWithCenter:point];//弹簧效果
}

- (void)button1Clicked:(UIButton *)sender{
    
    NSArray *imageArray = @[@"http://img04.tooopen.com/images/20130701/tooopen_10055061.jpg",@"http://img06.tooopen.com/images/20161214/tooopen_sy_190570171299.jpg"];
    NSString *imageUrl = imageArray[arc4random() % imageArray.count];
    
    if (sender.tag==2000) {
        //删除图片缓存 及完成操作
        [[ZBImageDownloader sharedInstance] clearImageFileCompletion:^{
            [self sizeAndCount];
        }];
        
    }else if (sender.tag==2001){
        //删除单个图片缓存 及完成操作
        [[ZBImageDownloader sharedInstance] clearImageForkey:imageUrl completion:^{
            [self sizeAndCount];
        }];
    }
}

- (void)sizeAndCount{
    UILabel* label1 = (UILabel *)[self.view viewWithTag:4000];
    UILabel* label2 = (UILabel *)[self.view viewWithTag:5000];
    [label1 zb_animatedTransitionWithoptions:UIViewAnimationOptionTransitionCrossDissolve];//过渡动画
    float imageSize=[[ZBImageDownloader sharedInstance] imageFileSize];//图片大小
    label1.text=[NSString stringWithFormat:@"缓存图片大小:%@",[[ZBCacheManager sharedInstance] fileUnitWithSize:imageSize]];
    
    [label2 zb_animatedTransitionWithoptions:UIViewAnimationOptionTransitionFlipFromTop];//过渡动画
    float count=[[ZBImageDownloader sharedInstance] imageFileCount];//个数
    label2.text=[NSString stringWithFormat:@"缓存图片数量:%.f",count];
}

- (void)handleTap:(UITapGestureRecognizer *)tap{
    
    CGPoint point = [tap locationInView:tap.view];
    
    CGPoint pointInImage = CGPointMake(point.x * self.imageView.image.size.width / self.imageView.frame.size.width, point.y * self.imageView.image.size.height / self.imageView.frame.size.height);
    
    self.view.backgroundColor = [self.imageView.image zb_ColorAtPixel:pointInImage];//把图片像素颜色给view
}

- (void)btnClicked:(UIButton *)sender{
  
    switch (sender.tag) {
        case 100:
            [self.imageView zb_animatedTransitionWithoptions:UIViewAnimationOptionTransitionFlipFromTop];//过渡动画
            self.imageView.image = [self.imageView.image zb_FlipVertical];//垂直翻转
            break;
        case 101:
            [self.imageView zb_animatedTransitionWithoptions:UIViewAnimationOptionTransitionFlipFromLeft];//过渡动画
            self.imageView.image = [self.imageView.image zb_FlipHorizontal];//水平翻转
            break;
        case 102:
            [self.imageView zb_animatedTransitionWithoptions:UIViewAnimationOptionTransitionCrossDissolve];//过渡动画
            self.imageView.image = [self.imageView.image zb_GrayImage];//灰度图
            break;
        case 103:
            [self.imageView zb_animatedTransitionWithoptions:UIViewAnimationOptionTransitionCurlDown];//过渡动画
            self.imageView.image = [self.imageView.image zb_SubImageWithRect:CGRectMake(0, 0,self.imageView.image.size.width, self.imageView.image.size.height / 2)];//截图
            break;
        case 104:
            self.imageView.image = [self.imageView.image zb_Rotate:UIImageOrientationLeft];
            break;
        case 105:
            self.imageView.image = [self.imageView.image zb_Rotate:UIImageOrientationRight];
            break;
        case 106:
            self.imageView.image = [self.imageView.image zb_Rotate:UIImageOrientationDown];
            break;
        case 107:
            self.imageView.image = [self.imageView.image zb_ImageWithTitle:@"https://github.com/Suzhibin/ZBKit" fontSize:30];//加水印
            break;
        case 108:
            self.imageView.image = [self.imageView.image zb_ViewConversionImage:self.view];//截屏幕
            break;
        case 109:
            [self.imageView zb_animatedTransitionWithoptions:UIViewAnimationOptionTransitionCurlUp];//过渡动画
            self.imageView.image = [self.imageView.image zb_TiledImageWithSize:CGSizeMake(self.imageView.image.size.width * 4, self.imageView.image.size.width * 4)];//平铺
            break;
        case 110:
            [self.imageView zb_animatedTransitionWithoptions:UIViewAnimationOptionTransitionCrossDissolve];//过渡动画
            self.imageView.image = [self.imageView.image zb_circleImage];;//圆形
            [self.imageView zb_animationFloating];//浮动动画
            
            [[ZBCacheManager sharedInstance]storeContent:[self.imageView.image zb_circleImage] forKey:@"qwerty" path:[[ZBCacheManager sharedInstance]tmpPath]];//存储变形后的图片 
            break;
        case 111:
          
            [self.imageView1 zb_animatedKeyframes];//关键帧动画
            [self.imageView1 stopAnimating];//暂停
         
            break;
        case 112:
            
            self.imageView.image =[self.imageView.image zb_imageWithAlpha:0.3];//透明度
            break;
        case 113:
            
            [self.imageView1 stopAnimating];//暂停
            self.imageView1.image=[self.imageView.image zb_imageWithScaleToSize:CGSizeMake(50, 50)];//压缩大小
      

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
#pragma mark - UITouch方法
// 用户触碰时自动调用的方法
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 获取到触碰的对象
    UITouch *touch = [touches anyObject];
    // 获取我们触碰的点得坐标
    CGPoint point = [touch locationInView:self.view];
    
    [self.imageView1 animatedDampingWithCenter:point];
    
    // NSLog(@"point = %@",NSStringFromCGPoint(point));

    //(CGRectMake(0, 0, 320, 240)
    // if (CGRectContainsPoint([_imageView1.frame, point)) {
    //   _isTouch = YES;
    //}
}

 // 用户触碰移动时自动调用的方法 (不停的调用)
 - (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
 {
 if (_isTouch) {
 UITouch *touch = [touches anyObject];
 // 获取当前点得坐标
 CGPoint curPoint = [touch locationInView:self.view];
 // 获取上一个点得坐标!
 CGPoint prePoint = [touch previousLocationInView:self.view];
 QFMyPlane *plane = [QFMyPlane sharedPlane];
 CGPoint center = plane.center;
 center.x += curPoint.x - prePoint.x;
 center.y += curPoint.y - prePoint.y;
 plane.center = center;
 }
 }
 
 // 用户触碰结束时自动调用的方法
 - (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
 {
 _isTouch = NO;
 }
 
 // 触碰被取消时自动调用的方法 (电话，home，锁屏)
 - (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
 {
 
 }
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
