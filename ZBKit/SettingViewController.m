//
//  SettingViewController.m
//  ZBKit
//
//  Created by NQ UEC on 17/1/12.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "SettingViewController.h"
#import "GlobalSettingsTool.h"
#import <MessageUI/MessageUI.h>
#import "NSBundle+ZBKit.h"
#import "ZBNetworking.h"
#import <UIImageView+WebCache.h>
#import "ClearCacheViewController.h"
#define list_URL @"http://api.dotaly.com/lol/api/v1/shipin/latest?author=xiaocang&iap=0jb=0&limit=50&offset=0"
@interface SettingViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 1.第0租
    [self add0SectionItems];
    // 2.第1组
    [self add1SectionItems];
    // 3.第2组
    [self add2SectionItems];
    // 4.第3组
    [self add3SectionItems];

}

#pragma mark - 设置页面
- (void)add0SectionItems{
    __weak typeof(self) weakSelf = self;
    
    // 账号
    //itemWithIcon
    //itemWithTitle
    ZBSettingItem *ID = [ZBSettingItem itemWithIcon:[NSBundle IDInfoIcon] title:@"账号管理" type:ZBSettingItemTypeArrow];
    ID.operation = ^{
        UIViewController *helpVC = [[UIViewController alloc] init];
        helpVC.view.backgroundColor = [UIColor grayColor];
        helpVC.title = @"账号管理";
        [weakSelf.navigationController pushViewController:helpVC animated:YES];
    };
    
    // 字体
    ZBSettingItem *font = [ZBSettingItem itemWithIcon:[NSBundle MoreHelpIcon] title:@"字体大小" type:ZBSettingItemTypeRightText];
    font.rightText=[self setFont];
    __block ZBSettingItem *weakFont = font;
    font.operation = ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设置字体大小" message:@"" preferredStyle:(UIAlertControllerStyleActionSheet)];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        UIAlertAction *defult = [UIAlertAction actionWithTitle:@"小" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *_Nonnull action){
            [GlobalSettingsTool sharedSetting].fontSize=0;
            weakFont.rightText=[weakSelf setFont];
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:0],nil] withRowAnimation:UITableViewRowAnimationTop];
        }];
        UIAlertAction *defult1 = [UIAlertAction actionWithTitle:@"中" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action){
            [GlobalSettingsTool sharedSetting].fontSize=1;
            weakFont.rightText=[weakSelf setFont];
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:0],nil] withRowAnimation:UITableViewRowAnimationTop];
        }];
        UIAlertAction *defult2 = [UIAlertAction actionWithTitle:@"大" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *_Nonnull action){
            [GlobalSettingsTool sharedSetting].fontSize=2;
            weakFont.rightText=[weakSelf setFont];
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:0],nil] withRowAnimation:UITableViewRowAnimationTop];
        }];
        [alert addAction:cancel];
        [alert addAction:defult];
        [alert addAction:defult1];
        [alert addAction:defult2];
        [weakSelf presentViewController:alert animated:YES completion:nil]; //呈现
    };
    
    ZBSettingGroup *group = [[ZBSettingGroup alloc] init];
    group.items = @[ID,font];
    group.headerHeight=5;
    group.footerHeight=5;
    [_allGroups addObject:group];
    
    
}
- (void)add1SectionItems{
    __weak typeof(self) weakSelf = self;
    
    // 1.1.推送和提醒
    ZBSettingItem *push = [ZBSettingItem itemWithTitle:@"新消息通知" type:ZBSettingItemTypeSwitch];
    
    __block ZBSettingItem *weakPush = push;
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if(UIUserNotificationTypeNone != setting.types) {//系统开启
        push.isOpenSwitch=[GlobalSettingsTool sharedSetting].enabledPush;
        push.switchBlock = ^(BOOL on) {
            NSLog(@"通知%zd",on);
            [GlobalSettingsTool sharedSetting].enabledPush=on;
        };
        
    }else{
        
        push.isOpenSwitch=NO;
        push.switchBlock = ^(BOOL on) {
            NSLog(@"通知%zd",on);
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你尚末开启系统推送" message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *_Nonnull action){
                weakPush.isOpenSwitch=NO;
                [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:1],nil] withRowAnimation:UITableViewRowAnimationFade];
            }];
            UIAlertAction *defult = [UIAlertAction actionWithTitle:@"去开启" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *_Nonnull action){
                NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                
                if([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication]openURL:url];
                }
            }];
            
            [alert addAction:cancel];
            [alert addAction:defult];
            [weakSelf presentViewController:alert animated:YES completion:nil]; //呈现
        };
    }
    
    ZBSettingGroup *group1 = [[ZBSettingGroup alloc] init];
    group1.items = @[push];
    group1.headerHeight=5;
    group1.footerHeight=5;
    [_allGroups addObject:group1];
    
    
    
}
- (void)add2SectionItems{
    
    __weak typeof(self) weakSelf = self;
    
    // Wifi
    ZBSettingItem *wifi = [ZBSettingItem itemWithTitle:@"仅-Wifi网络下载图片" type:ZBSettingItemTypeSwitch];
    wifi.isOpenSwitch=[GlobalSettingsTool downloadImagePattern];
    wifi.switchBlock = ^(BOOL on) {
        
        on = [[NSUserDefaults standardUserDefaults]boolForKey:@"readImage"];
        [[NSUserDefaults standardUserDefaults]setBool:!on forKey:@"readImage"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
       // [[NSNotificationCenter defaultCenter]postNotificationName:IMAGE object:[NSString stringWithFormat:@"%d",[[NSUserDefaults standardUserDefaults]boolForKey:@"readImage"]]];
        
    };
    
    // 缓存
    ZBSettingItem *cache= [ZBSettingItem itemWithTitle:@"清除缓存" type:ZBSettingItemTypeArrow];
 
    cache.operation = ^{
        ClearCacheViewController *clearVC=[[ClearCacheViewController alloc]init];
        [self.navigationController pushViewController:clearVC animated:YES];
    };
    
    ZBSettingGroup *group2 = [[ZBSettingGroup alloc] init];
    group2.headerHeight=5;
    group2.footerHeight=5;
    group2.items = @[wifi,cache];
    [_allGroups addObject:group2];
    
}
- (void)add3SectionItems{
    __weak typeof(self) weakSelf = self;
    
    //去评价
    ZBSettingItem *open = [ZBSettingItem itemWithTitle:@"评价" type:ZBSettingItemTypeArrow];
    open.operation = ^{
        [[GlobalSettingsTool sharedSetting]openURL:@"123456789"];
    };
    
    //意见反馈
    ZBSettingItem *feedback = [ZBSettingItem itemWithIcon:[NSBundle MoreMessageIcon] title:@"意见反馈" type:ZBSettingItemTypeArrow];
    feedback.operation = ^{
        [weakSelf createMail];
    };
    
    // 分享
    ZBSettingItem *share = [ZBSettingItem itemWithIcon:[NSBundle MoreShareIcon] title:@"分享" type:ZBSettingItemTypeArrow];
    share.operation = ^{
        NSArray *activityItems=@[@"ZBKit"];
        UIActivityViewController *activityController =
        [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                          applicationActivities:nil];
        [weakSelf presentViewController:activityController
                               animated:YES completion:nil];
    };
    // 关于
    ZBSettingItem *about = [ZBSettingItem itemWithIcon:[NSBundle MoreAboutIcon] title:@"关于" type:ZBSettingItemTypeArrow];
    
    about.operation = ^{
        NSString *aboutString=[NSString stringWithFormat:@"应用名字:%@\n应用ID:%@\n应用版本:%@\n应用build:%@",[[GlobalSettingsTool sharedSetting]appBundleName],[[GlobalSettingsTool sharedSetting]appBundleID],[[GlobalSettingsTool sharedSetting]appVersion],[[GlobalSettingsTool sharedSetting]appBuildVersion]];
        UIViewController *helpVC = [[UIViewController alloc] init];
        UILabel *abotlabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 100, SCREEN_WIDTH-40, 100)];
        abotlabel.text=aboutString;
        abotlabel.numberOfLines=0;
        [helpVC.view addSubview:abotlabel];
        helpVC.view.backgroundColor = [UIColor brownColor];
        helpVC.title = @"关于";
        [weakSelf.navigationController pushViewController:helpVC animated:YES];
    };
    
    ZBSettingGroup *group3 = [[ZBSettingGroup alloc] init];
    group3.items = @[open, feedback, share , about];
    group3.headerHeight=35;
    group3.footerHeight=35;
    group3.header=@"基本设置";
    group3.footer=@"footer";
    [_allGroups addObject:group3];
    
}


- (NSString *)setFont{
    switch ([GlobalSettingsTool sharedSetting].fontSize) {
        case 0:
            return  [NSString stringWithFormat:@"小"];
            break;
        case 1:
            return [NSString stringWithFormat:@"中"];
            break;
        case 2:
            return  [NSString stringWithFormat:@"大"];
            break;
        default:
            return [NSString stringWithFormat:@"中"];
            break;
    }
    
}

- (NSString *)getCacheSize{
    
    float cacheSize=[[ZBCacheManager sharedManager]getCacheSize];//json缓存文件大小
    float imageSize = [[SDImageCache sharedImageCache]getSize];//图片缓存大小
    
    float AppCacheSize=cacheSize+imageSize;
    AppCacheSize=AppCacheSize/1000.0/1000.0;
    return [NSString stringWithFormat:@"%.2fM",AppCacheSize];
}
- (NSString *)getCacheCount{
    float cacheCount=[[ZBCacheManager sharedManager]getCacheCount];//json缓存文件个数
    float imageCount=[[SDImageCache sharedImageCache]getDiskCount];//图片缓存个数
    float AppCacheCount=cacheCount+imageCount;
    return [NSString stringWithFormat:@"%.f",AppCacheCount];
}
#pragma mark - mail delegate
- (void)createMail
{
    MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
    //判断是否支持发送邮件的功能
    if ([MFMailComposeViewController canSendMail]) {
        //设置邮件的主题
        [mail setSubject:@"ZBKit反馈"];
        //设置收件人(设置一组)
        [mail  setToRecipients:[NSArray arrayWithObjects:@"szb2323@163.com",nil]];
        //设置邮件的正文,是否解析正文中的html标签
        NSString *aboutString=[NSString stringWithFormat:@"%@%@/%@/%@",[[GlobalSettingsTool sharedSetting]appBundleName],[[GlobalSettingsTool sharedSetting]appVersion],[[UIDevice currentDevice] systemVersion],[[GlobalSettingsTool sharedSetting]machineName]];
        [mail setMessageBody:aboutString isHTML:NO];
        //设置代理
        mail.mailComposeDelegate = self;
        //添加图片附件
        UIImage *image = [UIImage imageNamed:@"handShake.png"];
        //转成NData
        NSData *data = UIImagePNGRepresentation(image);
        //添加附件 mimeType 附件的类型  fileName:图片的名称
        [mail addAttachmentData:data mimeType:@"file/png" fileName:@"handShake.png"];
        [self presentViewController:mail animated:YES completion:^{
            
        }];
    }else{
        NSLog(@"不支持发邮件");
    }
    
}
//用于接收邮件的状态
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:
        {
            NSLog(@"mailCancel!");
        }
            break;
        case MFMailComposeResultFailed:
        {
            NSLog(@"mail failed!");
        }break;
        case MFMailComposeResultSaved:{
            NSLog(@"mail Save!");
        }break;
        case MFMailComposeResultSent:{
            NSLog(@"mail send!");
        }
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:^{
        
    }];
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
