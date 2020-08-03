//
//  MenuViewController.m
//  ZBKit
//
//  Created by Suzhibin on 2020/6/17.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import "MenuViewController.h"
#import "ZBKit.h"
@interface MenuViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)UICollectionView *collectionView;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self createWelfare];
}
- (void)createWelfare{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(128,180);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
  
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, ZB_SCREEN_WIDTH, 160) collectionViewLayout:flowLayout];
    self.collectionView.collectionViewLayout=flowLayout;
    self.collectionView .delegate = self;
    self.collectionView .dataSource = self;
    self.collectionView .showsHorizontalScrollIndicator= NO;
   // self.collectionView .pagingEnabled =YES;
  //  self.collectionView .scrollEnabled=NO;
   self.collectionView .backgroundColor = [UIColor clearColor];
    [self.view addSubview: self.collectionView ];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 15, 0,15);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
  
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    cell.contentView.backgroundColor=RandomColor;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //NSString *welfareStr=[self.dataArray objectAtIndex:indexPath.item];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate didSelectItemAtIndex:indexPath.item];
    }];
    
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
