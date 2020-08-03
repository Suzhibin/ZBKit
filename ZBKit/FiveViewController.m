//
//  FiveViewController.m
//  ZBKit
//
//  Created by NQ UEC on 17/3/31.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "FiveViewController.h"
#import "ZBKit.h"
#import <SceneKit/SceneKit.h>
@interface FiveViewController ()
@property(strong,nonatomic)SCNView *scnView;
@property(nonatomic,strong)SCNNode *shoseNode;
@property(nonatomic,strong)UIView *shoseView;
@property(nonatomic,strong)UILabel *titleLabel;
@end

@implementation FiveViewController

- (void)dealloc{
    NSLog(@"释放%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
   [self layoutView];
      [self changeshosesurface];
      [self addSCNView];
}
-(void)layoutView{
    
    self.shoseView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ZB_SCREEN_WIDTH, 0.6*ZB_SCREEN_HEIGHT)];
    [self.view addSubview:_shoseView];
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _shoseView.frame.size.height+64, ZB_SCREEN_WIDTH, 40)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.backgroundColor = [UIColor grayColor];
    _titleLabel.text = @"板鞋👟";
    [self.view addSubview:_titleLabel];
    
    
}

-(void)addSCNView{
    SCNSceneSource *sceneSource = [SCNSceneSource sceneSourceWithURL:[[NSBundle mainBundle] URLForResource:@"vans-authentic-shoe-low-poly" withExtension:@".dae"] options:nil];
    
    //     SCNNode *shoseNode = [sceneSource entryWithIdentifier:@"vans-authentic-shoe-low-poly" withClass:[SCNNode class]];
    
    _scnView= [[SCNView alloc]initWithFrame:self.shoseView.bounds];
    _scnView.allowsCameraControl = YES;//允许您通过简单的手势手动控制活动相机。
    _scnView.showsStatistics = YES;//在场景底部启用实时统计面板。
    _scnView.autoenablesDefaultLighting=YES;//在场景中创建一个通用的全向灯，因此您不必担心添加自己的光源。
    _scnView.backgroundColor = [UIColor grayColor];
    
    
    
    SCNScene *scene  = [sceneSource sceneWithOptions:nil error:nil];
    
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.camera.automaticallyAdjustsZRange = true;
    cameraNode.camera.zFar = 400;//视距
    [scene.rootNode addChildNode:cameraNode];
    cameraNode.position = SCNVector3Make(0, 0, 300);
    //    cameraNode.eulerAngles = SCNVector3Make(0,M_PI/4, 0);
    // create and add a light to the scene
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.position = SCNVector3Make(0, 0, 100);
    [scene.rootNode addChildNode:lightNode];
    
    // create and add an ambient light to the scene
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor whiteColor];
    [scene.rootNode addChildNode:ambientLightNode];
    
    _shoseNode = [_scnView.scene.rootNode childNodeWithName:@"Authentic-Low-Poly" recursively:YES];
    // 绕 y轴 一直旋转
//    SCNAction *action = [SCNAction repeatActionForever:[SCNAction rotateByX:0 y:1 z:0 duration:0.5]];
//    [_shoseNode runAction:action];
   
    _scnView.scene = scene;

    // retrieve the SCNView
        [self.shoseView addSubview:_scnView];
}


-(void)changeshosesurface{
    UIButton *redbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    redbutton.frame = CGRectMake(20, _titleLabel.frame.origin.y +60, 120, 50);
    [redbutton setTitle:@"鞋面颜色" forState:UIControlStateNormal];
    [redbutton addTarget:self action:@selector(changeColor) forControlEvents:UIControlEventTouchUpInside];
    redbutton.backgroundColor  = [UIColor grayColor];
    [self.view addSubview:redbutton];
    
  
    
    UIButton *xjxbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    xjxbutton.frame = CGRectMake(ZB_SCREEN_WIDTH-120-20, _titleLabel.frame.origin.y +60, 120, 50);
    [xjxbutton setTitle:@"鞋带" forState:UIControlStateNormal];
    [xjxbutton addTarget:self action:@selector(heartClothes) forControlEvents:UIControlEventTouchUpInside];
    xjxbutton.backgroundColor  = [UIColor grayColor];;
    [self.view addSubview:xjxbutton];
}

-(void)changeColor{
    
    SCNNode *shirtNode = [_scnView.scene.rootNode childNodeWithName:@"polySurface394" recursively:YES];
    shirtNode.geometry.firstMaterial.diffuse.contents  = RandomColor;
//    SCNNode *newnode = [shirtNode clone];
////    [_shoseNode replaceChildNode:shirtNode with:newnode];
//    [shirtNode removeFromParentNode];
//    SCNNode *sunNode = [SCNNode node];
//    sunNode.geometry = [SCNSphere sphereWithRadius:100];
//    sunNode.geometry.firstMaterial.diffuse.contents = [UIColor redColor];
    
    NSLog(@"%@ ❤️❤️❤️",shirtNode);
//    NSLog(@"%@ ❤️❤️❤️",newnode);
//    [_shoseNode replaceChildNode:shirtNode with:sunNode];
//    [_shoseNode addChildNode:sunNode];
    
}

-(void)heartClothes{
    SCNNode *shirtNode = [_scnView.scene.rootNode childNodeWithName:@"Binding" recursively:YES];
    shirtNode.geometry.firstMaterial.diffuse.contents = RandomColor;
//    SCNAction *sunaction = [SCNAction repeatAction:[SCNAction rotateByAngle:<#(CGFloat)#> aroundAxis:<#(SCNVector3)#> duration:<#(NSTimeInterval)#>] count:<#(NSUInteger)#>]
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
