
//
//  ZBWeatherView.m
//  ZBKit
//
//  Created by NQ UEC on 2017/4/27.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ZBWeatherView.h"
#import "UIView+ZBKit.h"
#import "ZBControlTool.h"
//屏幕宽
#define SCREEN_WIDTH                ([UIScreen mainScreen].bounds.size.width)
//屏幕高
#define SCREEN_HEIGHT               ([UIScreen mainScreen].bounds.size.height)
#define widthPix SCREEN_WIDTH/320
#define heightPix SCREEN_HEIGHT/568
@interface ZBWeatherView ()
@property (nonatomic, strong) UIImageView  *backgroudView;
//多云动画
@property (nonatomic, strong) NSMutableArray *imageArr;//鸟图片数组
@property (nonatomic, strong) UIImageView *birdImage;//鸟本体
@property (nonatomic, strong) UIImageView *birdRefImage;//鸟倒影
@property (nonatomic, strong) UIImageView *cloudImageViewF;//云
@property (nonatomic, strong) UIImageView *cloudImageViewS;//云
//晴天动画
@property (nonatomic, strong) UIImageView *sunImage;//太阳
@property (nonatomic, strong) UIImageView *sunshineImage;//太阳光
@property (nonatomic, strong) UIImageView *sunCloudImage;//晴天云
//雨天动画
@property (nonatomic, strong) UIImageView *rainCloudImage;//乌云
@property (nonatomic, strong) NSArray *jsonArray;

//下雪动画

@end
@implementation ZBWeatherView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
        [self createBackgroundView];
    }
    
    return self;
}
//创建背景视图
- (void)createBackgroundView {
    self.backgroudView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_normal.jpg"]];
    _backgroudView.frame = self.bounds;
    [self addSubview:self.backgroudView];
}

- (void)changeImageAnimated:(UIImage *)image {
    CATransition *transition = [CATransition animation];
    transition.duration = 1;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.backgroudView.layer addAnimation:transition forKey:@"a"];
    [self.backgroudView setImage:image];
    
}

- (void)removeAnimationView {
    //先将所有的动画移除
    [self.birdImage removeFromSuperview];
    [self.birdRefImage removeFromSuperview];
    [self.cloudImageViewF removeFromSuperview];
    [self.cloudImageViewS removeFromSuperview];
    [self.sunImage removeFromSuperview];
    [self.sunshineImage removeFromSuperview];
    [self.sunCloudImage removeFromSuperview];
    [self.rainCloudImage removeFromSuperview];
    
    for (NSInteger i = 0; i < _jsonArray.count; i++) {
        UIImageView *rainLineView = (UIImageView *)[self viewWithTag:100+i];
        [rainLineView removeFromSuperview];//移除下雨
        
        UIImageView *snowView = (UIImageView *)[self viewWithTag:1000+i];
        [snowView removeFromSuperview];//移除雪
    }
}

//添加动画
- (void)addAnimationWithType:(NSString *)weatherType{
     if(!weatherType)return;
    //先将所有的动画移除
    [self removeAnimationView];
  //doubleValue integerValue
    NSInteger type = [weatherType doubleValue];
    if (type >= 0 && type < 4) { //晴天
        if ([ZBControlTool isNight]) {
            [self changeImageAnimated:[UIImage imageNamed:@"bg_sunny_night.jpg"]];
            [self sunAndNight:NO];//动画
        }else{
            [self changeImageAnimated:[UIImage imageNamed:@"bg_sunny_day.jpg"]];
            [self sunAndNight:YES];//动画
        }
    }
    else if (type >= 4 && type < 7) { //多云
        [self changeImageAnimated:[UIImage imageNamed:@"bg_na.jpg"]];
        if ([ZBControlTool isNight]) {
            [self rainCloud];
        }else{

            //云朵效果
            _cloudImageViewF = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ele_sunnyCloud2"]];
            CGRect frame = _cloudImageViewF.frame;
            frame.size = CGSizeMake(self.zb_height *0.7, self.zb_width*0.5);
            _cloudImageViewF.frame = frame;
            _cloudImageViewF.center = CGPointMake(self.zb_width * 0.25, self.zb_height*0.7);
            [_cloudImageViewF.layer addAnimation:[self birdFlyAnimationWithToValue:@(self.zb_width+30) duration:70] forKey:nil];
            [self addSubview:_cloudImageViewF];
            
            
            _cloudImageViewS = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ele_sunnyCloud1"]];
            _cloudImageViewS.frame = self.cloudImageViewF.frame;
            _cloudImageViewS.center = CGPointMake(self.zb_width * 0.05, self.zb_height*0.7);
            [_cloudImageViewS.layer addAnimation:[self birdFlyAnimationWithToValue:@(self.zb_width+30) duration:70] forKey:nil];
            [self addSubview:_cloudImageViewS];
        }
       
    }
    else if (type >= 7 && type < 10) { //阴
        [self changeImageAnimated:[UIImage imageNamed:@"bg_normal.jpg"]];
        if ([ZBControlTool isNight]) {
            [self rainCloud];
        }else{
            [self wind];//动画
        }

    }
    else if (type >= 10 && type < 20) { //雨
        if ([ZBControlTool isNight]) {
            [self changeImageAnimated:[UIImage imageNamed:@"bg_rain_night.jpg"]];
        }else{
            [self changeImageAnimated:[UIImage imageNamed:@"bg_rain_day.jpg"]];
        }
        [self rain];
 
    }
    else if (type >= 20 && type < 26) { //雪
        if ([ZBControlTool isNight]) {
            [self changeImageAnimated:[UIImage imageNamed:@"bg_snow_night.jpg"]];
        }else{
            [self changeImageAnimated:[UIImage imageNamed:@"bg_snow_day.jpg"]];
        }
        [self snow];
    }
    else if (type >= 26 && type < 30) { //沙尘暴
        [self changeImageAnimated:[UIImage imageNamed:@"bg_sunny_day.jpg"]];
        
    }
    else if (type >= 30 && type < 32) { //雾霾
        [self changeImageAnimated:[UIImage imageNamed:@"bg_haze.jpg"]];
        
    }
    else if (type >= 32 && type < 37) { //风
        [self changeImageAnimated:[UIImage imageNamed:@"bg_sunny_day.jpg"]];
        
    }
    else if (type == 37) { //冷
        [self changeImageAnimated:[UIImage imageNamed:@"bg_fog_night.jpg"]];
        
    }
    else if (type == 38) { //热
        [self changeImageAnimated:[UIImage imageNamed:@"bg_sunny_day.jpg"]];
        
    }
    else if (type == 99) { //未知
        
        
    }
    
   // [self bringSubviewToFront:self.weatherV];
   // [self bringSubviewToFront:self.changeCityBtn];//懒加载，将切换城市按钮拿到最上层
    
}
//晴天动画
- (void)sunAndNight:(BOOL)isSun{
    if (isSun==YES) {
        //太阳
        _sunImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ele_sunnySun"]];
        CGRect frameSun = _sunImage.frame;
        frameSun.size = CGSizeMake(200, 200*579/612.0);
        _sunImage.frame = frameSun;
        _sunImage.center = CGPointMake(self.zb_width * 0.1, self.zb_height * 0.1);
        [self addSubview:_sunImage];
        [_sunImage.layer addAnimation:[self sunshineAnimationWithDuration:40] forKey:nil];
        
        //太阳光
        _sunshineImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ele_sunnySunshine"]];
        CGRect _sunImageFrame = _sunshineImage.frame;
        _sunImageFrame.size = CGSizeMake(400, 400);
        _sunshineImage.frame = _sunImageFrame;
        _sunshineImage.center = CGPointMake(self.zb_height * 0.1, self.zb_height * 0.1);
        [self addSubview:_sunshineImage];
        [_sunshineImage.layer addAnimation:[self sunshineAnimationWithDuration:40] forKey:nil];
        
        
        //晴天云
        _sunCloudImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ele_sunnyCloud2"]];
        CGRect frame = _sunCloudImage.frame;
        frame.size = CGSizeMake(self.zb_height *0.7, self.zb_width*0.5);
        _sunCloudImage.frame = frame;
        _sunCloudImage.center = CGPointMake(self.zb_width * 0.25, self.zb_height*0.5);
        [_sunCloudImage.layer addAnimation:[self birdFlyAnimationWithToValue:@(self.zb_width+30) duration:50] forKey:nil];
        [self addSubview:_sunCloudImage];
        

    }else{
        //晴天云
        //云朵效果
        _birdImage = [[UIImageView alloc]initWithFrame:CGRectMake(-30, self.zb_height * 0.2, 70, 50)];
        [_birdImage setAnimationImages:self.imageArr];
        _birdImage.animationRepeatCount = 0;
        _birdImage.animationDuration = 1;
        [_birdImage startAnimating];
        [self addSubview:_birdImage];
        [_birdImage.layer addAnimation:[self birdFlyAnimationWithToValue:@(self.zb_width+30) duration:10  ] forKey:nil];

    }
}
- (void)rainCloud{
    //乌云
    _rainCloudImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"night_rain_cloud"]];
    CGRect frame = _rainCloudImage.frame;
    frame.size = CGSizeMake(768/371.0* self.zb_width*0.5, self.zb_width*0.5);
    _rainCloudImage.frame = frame;
    _rainCloudImage.center = CGPointMake(self.zb_width * 0.25, self.zb_height*0.1);
    [_rainCloudImage.layer addAnimation:[self birdFlyAnimationWithToValue:@(self.zb_width+30) duration:50] forKey:nil];
    [self addSubview:_rainCloudImage];

}

//多云动画
- (void)wind {
    
    //鸟 本体
    _birdImage = [[UIImageView alloc]initWithFrame:CGRectMake(-30, self.zb_height * 0.2, 70, 50)];
    [_birdImage setAnimationImages:self.imageArr];
    _birdImage.animationRepeatCount = 0;
    _birdImage.animationDuration = 1;
    [_birdImage startAnimating];
    [self addSubview:_birdImage];
    [_birdImage.layer addAnimation:[self birdFlyAnimationWithToValue:@(self.zb_width+30) duration:10  ] forKey:nil];
    
    //鸟 倒影
    _birdRefImage = [[UIImageView alloc]initWithFrame:CGRectMake(-30, self.zb_height * 0.8, 70, 50)];
    [self.backgroudView addSubview:self.birdRefImage];
    [_birdRefImage setAnimationImages:self.imageArr];
    _birdRefImage.animationRepeatCount = 0;
    _birdRefImage.animationDuration = 1;
    _birdRefImage.alpha = 0.4;
    [_birdRefImage startAnimating];
    
    [_birdRefImage.layer addAnimation:[self birdFlyAnimationWithToValue:@(self.zb_width+30) duration:10] forKey:nil];
    
    
    //云朵效果
    _cloudImageViewF = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ele_sunnyCloud2"]];
    CGRect frame = _cloudImageViewF.frame;
    frame.size = CGSizeMake(self.zb_height *0.7, self.zb_width*0.5);
    _cloudImageViewF.frame = frame;
    _cloudImageViewF.center = CGPointMake(self.zb_width * 0.25, self.zb_height*0.7);
    [_cloudImageViewF.layer addAnimation:[self birdFlyAnimationWithToValue:@(self.zb_width+30) duration:70] forKey:nil];
    [self addSubview:_cloudImageViewF];
    
    
    _cloudImageViewS = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ele_sunnyCloud1"]];
    _cloudImageViewS.frame = self.cloudImageViewF.frame;
    _cloudImageViewS.center = CGPointMake(self.zb_width * 0.05, self.zb_height*0.7);
    [_cloudImageViewS.layer addAnimation:[self birdFlyAnimationWithToValue:@(self.zb_width+30) duration:70] forKey:nil];
    [self addSubview:_cloudImageViewS];
    
}

//雨天动画
- (void)rain {
    //加载JSON文件
    NSString *path = [[NSBundle mainBundle] pathForResource:@"rainData.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    //将JSON数据转为NSArray或NSDictionary
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    _jsonArray = dict[@"weather"][@"image"];
    
    for (NSInteger i = 0; i < _jsonArray.count; i++) {
        
        NSDictionary *dic = [_jsonArray objectAtIndex:i];
        UIImageView *rainLineView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:dic[@"-imageName"]]];
       
        rainLineView.tag = 100+i;
        NSArray *sizeArr = [dic[@"-size"] componentsSeparatedByString:@","];
        NSArray *originArr = [dic[@"-origin"] componentsSeparatedByString:@","];
        rainLineView.frame = CGRectMake([originArr[0] integerValue]*widthPix , [originArr[1] integerValue], [sizeArr[0] integerValue], [sizeArr[1] integerValue]);
        [self addSubview:rainLineView];
        [rainLineView.layer addAnimation:[self rainAnimationWithDuration:2+i%5] forKey:nil];
        [rainLineView.layer addAnimation:[self rainAlphaWithDuration:2+i%5] forKey:nil];
    }
    
    //乌云
    [self rainCloud];
}

//下雪
- (void)snow {
    
    //加载JSON文件
    NSString *path = [[NSBundle mainBundle] pathForResource:@"rainData.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    //将JSON数据转为NSArray或NSDictionary
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    _jsonArray = dict[@"weather"][@"image"];
    for (NSInteger i = 0; i < _jsonArray.count; i++) {
        
        NSDictionary *dic = [_jsonArray objectAtIndex:i];
        UIImageView *snowView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"snow"]];
        snowView.tag = 1000+i;
        NSArray *originArr = [dic[@"-origin"] componentsSeparatedByString:@","];
        snowView.frame = CGRectMake([originArr[0] integerValue]*widthPix , [originArr[1] integerValue], arc4random()%7+3, arc4random()%7+3);
        [self addSubview:snowView];
        [snowView.layer addAnimation:[self rainAnimationWithDuration:5+i%5] forKey:nil];
        [snowView.layer addAnimation:[self rainAlphaWithDuration:5+i%5] forKey:nil];
        [snowView.layer addAnimation:[self sunshineAnimationWithDuration:5] forKey:nil];//雪花旋转
    }
    
}


//动画横向移动方法
- (CABasicAnimation *)birdFlyAnimationWithToValue:(NSNumber *)toValue duration:(NSInteger)duration{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.toValue = toValue;
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    animation.repeatCount = MAXFLOAT;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

//动画旋转方法
- (CABasicAnimation *)sunshineAnimationWithDuration:(NSInteger)duration{
    //旋转动画
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.duration = duration;
    rotationAnimation.repeatCount = MAXFLOAT;//你可以设置到最大的整数值
    rotationAnimation.cumulative = NO;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    return rotationAnimation;
}

//下雨动画方法
- (CABasicAnimation *)rainAnimationWithDuration:(NSInteger)duration{
    
    CABasicAnimation* caBaseTransform = [CABasicAnimation animation];
    caBaseTransform.duration = duration;
    caBaseTransform.keyPath = @"transform";
    caBaseTransform.repeatCount = MAXFLOAT;
    caBaseTransform.removedOnCompletion = NO;
    caBaseTransform.fillMode = kCAFillModeForwards;
    caBaseTransform.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-170, -620, 0)];
    caBaseTransform.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(self.zb_height/2.0*34/124.0, self.zb_height/2, 0)];
    
    return caBaseTransform;
    
}
//透明度动画
- (CABasicAnimation *)rainAlphaWithDuration:(NSInteger)duration {
    
    CABasicAnimation *showViewAnn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    showViewAnn.fromValue = [NSNumber numberWithFloat:1.0];
    showViewAnn.toValue = [NSNumber numberWithFloat:0.1];
    showViewAnn.duration = duration;
    showViewAnn.repeatCount = MAXFLOAT;
    showViewAnn.fillMode = kCAFillModeForwards;
    showViewAnn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    showViewAnn.removedOnCompletion = NO;
    
    return showViewAnn;
}


//--getter----------------------------------------------------
-(NSMutableArray *)imageArr {
    if (!_imageArr) {
        _imageArr = [NSMutableArray array];
        for (int i=1; i<9; i++) {
            NSString *imageName = [NSString stringWithFormat:@"ele_sunnyBird%d",i];
            UIImage *image = [UIImage imageNamed:imageName];
           // NSLog(@"image:%@",image);
            [_imageArr addObject:image];
        }

    }
    return _imageArr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
