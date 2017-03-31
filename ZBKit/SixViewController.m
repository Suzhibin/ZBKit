//
//  SixViewController.m
//  ZBKit
//
//  Created by NQ UEC on 17/3/2.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "SixViewController.h"
#import "ZBCarouselView.h"
@interface SixViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation SixViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIde=@"cellIde";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIde];
    }
    if (indexPath.row==0) {
        cell.textLabel.text=@"字符串反转";
        
        cell.detailTextLabel.text=[ZBControlTool reverseWordsInString:@"字符串反转"];
    }
    if (indexPath.row==1) {
        cell.textLabel.text=@"获取汉字的拼音";
        
        cell.detailTextLabel.text=[ZBControlTool phoneticizeChinese:@"获取汉字的拼音"];
    }
    if (indexPath.row==2) {
        cell.textLabel.text=@"阿拉伯数字2017转中文";
        
        cell.detailTextLabel.text=[ZBControlTool translation:@"2017"];
    }
    if (indexPath.row==3) {
        cell.textLabel.text=@"是否包含中文";
        
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%d",[ZBControlTool checkIsChinese:@"是否包含中文"]];
    }
    if (indexPath.row==4) {
        cell.textLabel.text=@"高亮文字";
        NSString *ZBKit=@"ZBKit";
        NSString *Attributed=[NSString stringWithFormat:@"欢迎使用%@",ZBKit];
        
        NSMutableAttributedString *str4=[ZBControlTool AttributedString:Attributed range:4 lengthString:ZBKit];//高亮文字
        cell.detailTextLabel.attributedText=str4;
    }
    
    return cell;

}

//懒加载
- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.tableFooterView=[[UIView alloc]init];
        
    }
    
    return _tableView;
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
