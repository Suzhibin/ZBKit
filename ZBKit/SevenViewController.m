//
//  SevenViewController.m
//  ZBKit
//
//  Created by NQ UEC on 2017/4/25.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "SevenViewController.h"
#import "ZBKit.h"
#import "ListModel.h"
#import "NSObject+Caculator.h"
#import "CalculateMananger.h"
#import "UIView+Toast.h"
#import "ZBToastView.h"
#import "Dog.h"
#import "NSObject+ZBKVO.h"
// 主请求路径
#define budejieURL @"http://api.budejie.com/api/api_open.php"
@interface SevenViewController ()
@property (nonatomic,strong)NSString *string;
@property (nonatomic,strong)Dog *d;
@end

@implementation SevenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    int a =10;int b=5;
    a=a+b;//10+5=153
    b=a-b;//15-5=10
    a=a-b;//15-10=5;
    ZBKLog(@"a:%d  b:%d",a,b);
   // [self filter];
    
 //   [self request];
    
 //  [self archive];
    
   // [self chainProgramming];
   // [self notificat];
  //  [self KVO];
    
    NSMutableArray *array=[[NSMutableArray alloc]init];
    
    [array addObject:@"1"];
    
    [array objectAtIndexCheck:2];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
  //  [_d willChangeValueForKey:@"age"];
    _d.age=111;
     _d.name=[NSString stringWithFormat:@"%d",31];
   // [_d didChangeValueForKey:@"age"];
    
    
    //利用kvc观察容器 属性的变化 利用kvc
    /*
  NSMutableArray *tempArr=  [_d mutableArrayValueForKey:@"arr"];
    [tempArr addObject:@"obj"];
     [tempArr removeAllObjects];
  //  [_d.arr addObject:@"1"];
    */
    
     [_d.arr addObject:@"3"];
}
- (void)KVO{
    Dog *d=[[Dog alloc]init];
    d.age=19;
    d.name=[NSString stringWithFormat:@"%d",1];
   // [d zb_addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
  // [d addObserver:self forKeyPath:@"arr" options:NSKeyValueObservingOptionNew context:nil];
    
    [d.arr addObject:@"1"];
    [d.arr addObject:@"2"];
    //@count  @max 数组最大值

    _d=d;
/*
 kind 的类型
 NSKeyValueChangeSetting = 1,  set方法
 NSKeyValueChangeInsertion = 2, 插入方法
 NSKeyValueChangeRemoval = 3,  删除方法
 NSKeyValueChangeReplacement = 4,  替换方法
 */
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    ZBKLog(@"change:%@",change)
    
}

- (void)notificat{
    NSNotification *not=[NSNotification notificationWithName:@"aaa" object:nil];
    
    
    ZBKLog(@"send bedoer 1:%@",[NSThread currentThread]);
    NSNotificationQueue *queue=[NSNotificationQueue defaultQueue];
    [queue enqueueNotification:not postingStyle:NSPostWhenIdle coalesceMask:NSNotificationNoCoalescing forModes:nil];
    
    ZBKLog(@"send over 3");
    ZBKLog(@"currentRunLoop:%@",[NSRunLoop currentRunLoop]);
}
- (void)chainProgramming{
    
       NSLog(@"systemTimeZone:%@",[NSTimeZone systemTimeZone]);
    NSMutableString *str=[NSMutableString string];
    [str appendString:@"1"];
    
    self.string=str;
    [str appendString:@"2"];
    str=[NSMutableString stringWithString:@"3"];
        NSLog(@"self.string:%@",self.string);
     NSLog(@"str:%@",str);
    CalculateMananger *mar=[[CalculateMananger alloc]init];
    mar.add(1).add(3);
    NSLog(@"%d",mar.result);
   int result= [NSObject makeCaculator:^(CalculateMananger *make) {
        make.add(5).add(2).sub(3).add(10);
    }];
    NSLog(@"result:%d",result);
    
//    [UIView makeText:^(ZBToastView *make) {
//        make.textString(@"你好").backgroundColor([UIColor yellowColor]).textColor([UIColor blackColor]);
//    }];
    
//    ZBToastView *toast=[[ZBToastView alloc]init];
//    toast.toastView.textString(@"你好").backgroundColor([UIColor blueColor]).textColor([UIColor blackColor]);
}

- (void)filter{
    NSArray *cityArray = [NSArray arrayWithObjects:@"Shanghai",@"Hangzhou",@"Beijing",@"Macao",@"Taishan", nil];
    
    NSArray *arr=[cityArray zb_containElement:@"an"];
    NSLog(@"包含an元素:%@",arr);
    NSArray *arr1=[cityArray zb_beginsWithElement:@"M"];
    NSLog(@"已M开头:%@",arr1);
    NSArray *arr2=[cityArray zb_endsWithElement:@"an"];
    NSLog(@"an结尾:%@",arr2);
    NSArray *arr3=[cityArray zb_selfElement:@"Beijing"];
    NSLog(@"含有完整元素的数组:%@",arr3);
    
    NSArray *arabicArray = [NSArray arrayWithObjects:@1,@2,@3,@4,@5,@2,@6,@8,@10, nil];
    
    NSArray *arr4=[arabicArray zb_betweenAtIndex:4 index:6];
    
    NSLog(@"某范围之间:%@",arr4);
    
    NSArray *arr5=[arabicArray zb_greaterToCompare:4];
    NSLog(@"大于某值得:%@",arr5);
    
    NSArray *arr6=[arabicArray zb_lessToCompare:4];
    NSLog(@"小于某值得:%@",arr6);
    
    
    NSArray *array1 = [NSArray arrayWithObjects:@1,@2,@3,@5,@5,@6,@7, nil];
    
    NSArray *array2 = [NSArray arrayWithObjects:@4,@5, nil];
    NSArray *arr7=[array1 zb_filterArray:array2];
    NSLog(@"俩个数组相同的值 返回得数组:%@",arr7);
}

- (void)request{
    NSDictionary *dict=@{@"a":@"tag_recommend",@"c":@"topic",@"action":@"sub"};
    
    [ZBRequestManager requestWithConfig:^(ZBURLRequest *request) {
        request.URLString=budejieURL;
        request.parameters=dict;
        request.apiType=ZBRequestTypeCache;
    } success:^(id responseObj, ZBURLRequest *request) {
          NSLog(@"responseObj：%@",responseObj);
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
         ZBKLog(@"requestdict：%@",dict);
        
    } failure:^(NSError *error) {
        
    }];
    
    
    [ZBRequestManager requestWithConfig:^(ZBURLRequest *request) {
        request.URLString=budejieURL;
        request.parameters=dict;
    } success:^(id responseObj,ZBURLRequest *request) {
        
     //   NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        //  NSLog(@"dict：%@",dict);
    } failure:^(NSError *error) {
        
    }];
    
    
    
    
   //  NSDictionary *parameters=[[NSMutableDictionary alloc]init];
     
     //[parameters setValue:@"0" forKey:@"launchCount"];
    // [parameters setValue:@"zh_CN" forKey:@"assignLang"];
    // [parameters setValue:@"1001" forKey:@"channelId"];
    // [parameters setValue:@"D53AA748-7AD3-47A5-B11C-5CC216518471" forKey:@"userId"];
    
   NSDictionary *  parameters=@{
        @"assignLang": @"zh_CN",
        @"channelId" : @"1001",
        @"deviceInfo":@{
                @"imei" : @"ACC53CC3-7B29-4CE4-A9E3-2D3EA7460DF4",
                @"imsi" : @"ACC53CC3-7B29-4CE4-A9E3-2D3EA7460DF4"
            },
        @"launchCount" : @"11",
        @"softwareInfo" :@{
        @"buildNo" : @"186",
        @"business":@"0",
           @"country" : @"CN",
        @"idfv"  : @"060C9C43-DF70-41B0-86D8-6D760160728E",
        @"language"  : @"zh_CN",
        @"partner"  : @"0",
        @"platformId": @"225",
        @"timezone"  : @"Asia/Shanghai"
        },
        @"userId":@"ACC53CC3-7B29-4CE4-A9E3-2D3EA7460DF4"};
     
     [ZBRequestManager requestWithConfig:^(ZBURLRequest *request) {
     request.URLString=@"http://192.168.33.186:9080/BOSS_APD_WEB/user/information";
     request.methodType=ZBMethodTypePOST;
     request.parameters=parameters;
        request.requestSerializer=ZBJSONRequestSerializer;
     } success:^(id responseObject, ZBURLRequest *request) {
      // ZBKLog(@"postresponseObj:%@",responseObject);
     
     NSDictionary * dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        ZBKLog(@"post:%@",dataDict);
     } failure:^(NSError *error) {
        NSLog(@"posterror:%@",error);
     }];
    
    /*
     [ZBURLSessionManager requestWithConfig:^(ZBURLRequest *request) {
     request.urlString=@"";
     request.methodType=POST;
     request.parameters=parameters;
     } success:^(id responseObj, apiType type) {
     NSLog(@"postresponseObj1:%@",responseObj);
     
     id dataDict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
     NSLog(@"post1:%@",dataDict);
     
     } failed:^(NSError *error) {
     NSLog(@"posterror1:%@",error);
     }];
     */
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
