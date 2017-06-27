//
//  SevenViewController.m
//  ZBKit
//
//  Created by NQ UEC on 2017/4/25.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "SevenViewController.h"
#import "ZBKit.h"
// 主请求路径
#define budejieURL @"http://api.budejie.com/api/api_open.php"
@interface SevenViewController ()

@end

@implementation SevenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDictionary *dict=@{@"a":@"tag_recommend",@"c":@"topic",@"action":@"sub"};
    
    [ZBNetworkManager requestWithConfig:^(ZBURLRequest *request) {
        request.urlString=budejieURL;
        request.parameters=dict;
    } success:^(id responseObj, apiType type) {

        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
       // NSLog(@"dict：%@",dict);
        
    } failed:^(NSError *error) {
        
    }];
    
    
    [ZBURLSessionManager requestWithConfig:^(ZBURLRequest *request) {
        request.urlString=budejieURL;
        request.parameters=dict;
    } success:^(id responseObj, apiType type) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
      //  NSLog(@"dict：%@",dict);
    } failed:^(NSError *error) {
        
    }];
    
    
    
    /*
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    
    [parameters setValue:@"0" forKey:@"launchCount"];
    [parameters setValue:@"zh_CN" forKey:@"assignLang"];
    [parameters setValue:@"1001" forKey:@"channelId"];
    [parameters setValue:@"D53AA748-7AD3-47A5-B11C-5CC216518471" forKey:@"userId"];
    
    [ZBNetworkManager requestWithConfig:^(ZBURLRequest *request) {
        request.urlString=@"";
        request.methodType=POST;
        request.parameters=parameters;
    } success:^(id responseObj, apiType type) {
      //  NSLog(@"postresponseObj:%@",responseObj);
        
        NSDictionary * dataDict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
     //   NSLog(@"post:%@",dataDict);
    } failed:^(NSError *error) {
     //   NSLog(@"posterror:%@",error);
    }];
*/
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
