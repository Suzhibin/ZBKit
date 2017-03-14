//
//  FiveViewController.m
//  ZBKit
//
//  Created by NQ UEC on 17/2/14.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "FiveViewController.h"
#import "ZBKit.h"
@interface FiveViewController ()

@end

@implementation FiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // __weak typeof(self) weakSelf = self;
    
    NSString *string=@"工厂方法";
    self.title=string;
    
    //==============================================================
    ZBTableItem *reverse = [ZBTableItem itemWithTitle:@"字符串反转" type:ZBTableItemTypeRightText];
    reverse.rightText=string;
    __block ZBTableItem *weakReverse = reverse;
    reverse.operation = ^{
        
        NSString *str=[ZBControlTool reverseWordsInString:string];//字符串反转
        
        weakReverse.rightText=str;
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0],nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    //==============================================================
    ZBTableItem *phoneticize = [ZBTableItem itemWithTitle:@"获取汉字的拼音" type:ZBTableItemTypeRightText];
    phoneticize.rightText=string;
    __block ZBTableItem *weakPhoneticize = phoneticize;
    phoneticize.operation = ^{
        
        NSString *str1=[ZBControlTool phoneticizeChinese:string];//获取汉字的拼音
        
        weakPhoneticize.rightText=str1;
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:0],nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    //==============================================================
    ZBTableItem *translation = [ZBTableItem itemWithTitle:@"阿拉伯数字转中文" type:ZBTableItemTypeRightText];
    translation.rightText=@"2017";
    __block ZBTableItem *weakTranslation = translation;
    translation.operation = ^{
        
        NSString *str2=[ZBControlTool translation:@"2017"];//阿拉伯数字转中文
        
        weakTranslation.rightText=str2;
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:2 inSection:0],nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    //==============================================================
    NSArray *array = @[@"ZBKit",@"欢迎使用ZBkit"];
    NSString *str3 = array[arc4random() % array.count];
    ZBTableItem *chinese = [ZBTableItem itemWithTitle:@"是否包含中文(多点几次😄)" type:ZBTableItemTypeRightText];
    
    BOOL isChinese=[ZBControlTool checkIsChinese:str3];
    
    chinese.rightText=[NSString stringWithFormat:@"%@(%d)",str3,isChinese];
    __block ZBTableItem *weakChinese = chinese;
    chinese.operation = ^{
        NSArray *array = @[@"ZBKit",@"欢迎使用ZBkit"];
        NSString *str3 = array[arc4random() % array.count];
        BOOL isChinese=[ZBControlTool checkIsChinese:str3];
        
        weakChinese.rightText=[NSString stringWithFormat:@"%@(%d)",str3,isChinese];
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:3 inSection:0],nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    //==============================================================
    ZBTableItem *AttributedString = [ZBTableItem itemWithTitle:@"高亮文字" type:ZBTableItemTypeRightAttributedText];
    //显示高亮文字的label 要用attributedText 代替text 显示
    NSString *ZBKit=@"ZBKit";
    NSString *Attributed=[NSString stringWithFormat:@"欢迎使用%@",ZBKit];
    
    NSMutableAttributedString *str4=[ZBControlTool AttributedString:Attributed range:4 lengthString:ZBKit];//高亮文字
    
    AttributedString.rightAttributedText=str4;

    
    ZBTableGroup *group = [[ZBTableGroup alloc] init];
    group.items = @[reverse,phoneticize,translation,chinese,AttributedString];
    [_allGroups addObject:group];
    
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
