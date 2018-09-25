//
//  ZBScreenAdvertise.m
//  ZBKit
//
//  Created by NQ UEC on 2017/6/27.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ZBScreenAdvertise.h"
#import <UIKit/UIKit.h>
#import "ZBNetworking.h"
#import "ZBWebImageManager.h"
#import "ZBMacros.h"
#import "DetailsViewController.h"
#import "UIViewController+ZBKit.h"
NSString *const AdvertiseDefaultPath =@"Advertise";
static NSString *const adImageName = @"adImageName";
static NSString *const adUrlName = @"adUrl";
@interface ZBScreenAdvertise ()
@property (nonatomic, strong) UIWindow* window;
@property (nonatomic, strong) UIButton *downCountButton;
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, weak) NSTimer *enterBackgroundTimer;

@property (nonatomic, assign) int downCount;
@end
@implementation ZBScreenAdvertise

+ (void)load{
    [self shareInstance];
}
+ (instancetype)shareInstance{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [[ZBCacheManager sharedInstance]createDirectoryAtPath:[self AdvertiseFilePath]];
           __weak typeof(self) weakSelf = self;
        ///应用启动, 首次开屏广告
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [weakSelf checkAdvertise];
        }];
        ///进入后台
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [weakSelf requestAdvertise];
            weakSelf.enterBackgroundTimer = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(enterBackgroundClick) userInfo:nil repeats:NO];
        }];
        ///后台启动,二次开屏广告
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
     
//            if ([weakSelf.enterBackgroundTimer isValid]) {
//                ZBKLog(@"后台进入前台 没有超时");
//                [weakSelf.enterBackgroundTimer invalidate];
//                weakSelf.enterBackgroundTimer =nil;
//            }else{
                ZBKLog(@"后台进入前台 超300秒");
                [weakSelf checkAdvertise];
//            }
        }];
    }
    return self;
}

- (void)enterBackgroundClick{
      ZBKLog(@"超300秒了");
}

- (void)checkAdvertise{
    NSString *imagekey= [[NSUserDefaults standardUserDefaults] valueForKey:adImageName];
     NSString *urlkey= [[NSUserDefaults standardUserDefaults] valueForKey:adUrlName];
    ZBKLog(@"imagekey:%@",imagekey);
    
    if ([[ZBCacheManager sharedInstance]diskCacheExistsWithKey:imagekey path:[self AdvertiseFilePath]]) {
        
        [[ZBCacheManager sharedInstance]getCacheDataForKey:imagekey path:[self AdvertiseFilePath] value:^(NSData *data,NSString *filePath) {
            
            UIImage *image=[UIImage imageWithData:data];
            [self show:image];
            [[ZBCacheManager sharedInstance]getCacheDataForKey:urlkey path:[self AdvertiseFilePath] value:^(NSData *data, NSString *filePath) {
                self.dict=[NSDictionary dictionaryWithContentsOfFile:filePath];
            }];
    
        }];
    }

    [self requestAdvertise];
}

- (void)requestAdvertise{
    [ZBRequestManager requestWithConfig:^(ZBURLRequest *request) {
        request.URLString=@"http://192.168.33.186:9080/BOSS_APD_WEB/news/ads/screen_zh_CN";
        request.apiType=ZBRequestTypeRefresh;
    } success:^(id responseObject, apiType type,BOOL isCache) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSArray *array = (NSArray *)responseObject;
            //        NSArray  *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if (array.count>0) {
                for (NSDictionary *dict in array) {
                    NSString *imgUrl=[dict objectForKey:@"imgUrl"];
                    NSString *url=[dict objectForKey:@"url"];
                    NSString *adsTitle=[dict objectForKey:@"adsTitle"];
                    [self downloadAdImageWithUrl:imgUrl url:url title:adsTitle];
                }
            }else{
                [self deleteOldImage];
            }
        }
        
    } failure:^(NSError *error) {
        ZBLog(@"error:%@",error);
    }];
    
}
- (void)downloadAdImageWithUrl:(NSString *)imageUrl url:(NSString *)url title:(NSString *)adsTitle{
    [[ZBWebImageManager sharedInstance]downloadImageUrl:imageUrl path:[self AdvertiseFilePath] completion:^(UIImage *image) {
        if (image) {
            [[NSUserDefaults standardUserDefaults] setValue:imageUrl forKey:adImageName];
            [[NSUserDefaults standardUserDefaults] synchronize];
            // 如果有广告链接，将广告链接也保存下来
            NSDictionary *linkdict=@{@"link":url,@"imageUrl":imageUrl,@"title":adsTitle};
            [[ZBCacheManager sharedInstance]storeContent:linkdict forKey:url path:[self AdvertiseFilePath] isSuccess:nil];
            [[NSUserDefaults standardUserDefaults] setValue:url forKey:adUrlName];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
}

- (void)show:(UIImage *)image{
    ///初始化一个Window， 做到对业务视图无干扰。
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = [UIViewController new];
    window.rootViewController.view.backgroundColor = [UIColor clearColor];
    window.rootViewController.view.userInteractionEnabled = NO;

    self.downCount=3;
    ///设置为最顶层，防止 AlertView 等弹窗的覆盖
    window.windowLevel = UIWindowLevelStatusBar + 1;
    
    ///默认为YES，当你设置为NO时，这个Window就会显示了
    window.hidden = NO;
    window.alpha = 1;
    ///广告布局
    [self setupSubviews:window image:image];
    ///防止释放，显示完后  要手动设置为 nil
    self.window = window;
}
- (void)letGo{
    ///不直接取KeyWindow 是因为当有AlertView 或者有键盘弹出时， 取到的KeyWindow是错误的。
    UIViewController* rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
    DetailsViewController *details= [[DetailsViewController alloc]init];
    details.functionType=Advertise;
    details.url=[self.dict objectForKey:@"link"];
 
    [[rootVC zb_navigationController] pushViewController:details animated:YES];
   //   [[NSNotificationCenter defaultCenter] postNotificationName:@"pushtoad" object:nil userInfo:urlDict];
    
    ZBKLog(@"跳转的信息：%@",self.dict);
    [self hide];
}
- (void)goOut{
    [self hide];
}
- (void)hide{
    ///来个渐显动画
    [UIView animateWithDuration:0.3 animations:^{
        self.window.alpha = 0;
    } completion:^(BOOL finished) {
        [self.window.subviews.copy enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        self.window.hidden = YES;
        self.window = nil;
        [self.enterBackgroundTimer invalidate];
        self.enterBackgroundTimer =nil;
    }];
}

///初始化显示的视图， 可以挪到具
- (void)setupSubviews:(UIWindow*)window image:(UIImage *)image{
    ///随便写写
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:window.bounds];
    imageView.image =image;
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    ///给非UIControl的子类，增加点击事件
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(letGo)];
    [imageView addGestureRecognizer:tap];
    [window addSubview:imageView];
    
    //CGRect rectStatus=  [[UIApplication sharedApplication] statusBarFrame];
    UIButton * downCountButton = [[UIButton alloc] initWithFrame:CGRectMake(window.bounds.size.width - 80 - 20, ZB_STATUS_HEIGHT+15, 80, 30)];
    downCountButton.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.5];
    [downCountButton addTarget:self action:@selector(goOut) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:downCountButton];
    self.downCountButton=downCountButton;
 
    [self countDown];
}

- (void)countDown{
    [self.downCountButton setTitle:[NSString stringWithFormat:@"跳过:%ld",(long)self.downCount] forState:UIControlStateNormal];
    if (self.downCount <= 0) {
        [self hide];
    }
    else {
        self.downCount --;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self countDown];
        });
    }
}

- (NSString *)AdvertiseFilePath{
    NSString *AppImagePath =  [[[ZBCacheManager sharedInstance]ZBKitPath]stringByAppendingPathComponent:AdvertiseDefaultPath];
    return AppImagePath;
}

- (void)deleteOldImage{
    [[ZBCacheManager sharedInstance]clearDiskWithpath:[self AdvertiseFilePath] completion:nil];
}
@end
