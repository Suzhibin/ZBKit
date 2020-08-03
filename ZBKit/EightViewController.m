//
//  EightViewController.m
//  ZBKit
//
//  Created by NQ UEC on 2018/9/20.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "EightViewController.h"
#import "DWaveView.h"
#import "ASMagnifierManger.h"
@interface EightViewController ()
@property (strong, nonatomic) DWaveView *waveView;
@property (strong, nonatomic) ASMagnifierManger *magnifierManger;
@end

@implementation EightViewController
- (void)dealloc{
    NSLog(@"释放");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
   
    
    UIView *redView1=[[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 200)];
    redView1.backgroundColor=[UIColor colorWithRed:0.42f green:0.62f blue:0.83f alpha:1.00f];;
    [self.view addSubview:redView1];
    
    UIImageView *ship=[[UIImageView alloc]initWithFrame:CGRectMake(100,100, 100, 100)];
    ship.image=[UIImage imageNamed:@"timg3"];
 
    [redView1 addSubview:ship];
    [redView1 addSubview:self.waveView];
    
    self.waveView.waveBlock = ^(CGFloat currentY){
        CGRect iconFrame = [ship frame];
        iconFrame.origin.y = CGRectGetHeight(ship.frame)+currentY;
        ship.frame  =iconFrame;
    };
    
    ZBLabel *label=[[ZBLabel alloc]initWithFrame:CGRectMake(20, 300, ZB_SCREEN_WIDTH-40,100)];
    [label setAlignment:ZBTextAlignmentTop];
    label.backgroundColor=[UIColor redColor];
    label.textAlignment=NSTextAlignmentRight;
    label.text=@"点击显示放大镜(text显示在label的top)";
    [self.view addSubview:label];
    
    ZBLabel *label1=[[ZBLabel alloc]initWithFrame:CGRectMake(20, 400, ZB_SCREEN_WIDTH-40,100)];
    [label1 setAlignment:ZBTextAlignmentBottom];
    label1.backgroundColor=[UIColor yellowColor];
    label1.text=@"点击显示放大镜(text显示在label的Bottom)";
    [self.view addSubview:label1];
    
    self.magnifierManger=[[ASMagnifierManger alloc]init];
    self.magnifierManger.magnification = 3.0;//放大倍数
    //self.magnifierManger.magnifierWidth = 100;//放大镜大小
}
- (DWaveView *)waveView{
    if (!_waveView) {
        _waveView = [[DWaveView alloc] init];
        _waveView.frame=CGRectMake(0, 200,self.view.frame.size.width, 50);
        _waveView.realWaveColor = [UIColor whiteColor];
       // _waveView.maskWaveColor = [UIColor redColor];
        [_waveView startWaveAnimation];
    }
    return _waveView;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.magnifierManger magnifier_touchesBegan:touches withEvent:event view:self.view];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.magnifierManger magnifier_touchesMoved:touches withEvent:event view:self.view];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.magnifierManger magnifier_touchesEnded:touches withEvent:event];
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
