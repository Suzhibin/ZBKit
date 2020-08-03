//
//  PlayViewController.m
//  ZBKit
//
//  Created by Suzhibin on 2020/6/18.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import "PlayViewController.h"
#import "ZBKit.h"
#import "VTMagic.h"
#import "APIConstants.h"
#import "ListModel.h"
#import "IGListKit.h"
#import "PlaySectionController.h"
#import "DetailsViewController.h"
@interface PlayViewController ()<IGListAdapterDataSource,UIScrollViewDelegate,UIGestureRecognizerDelegate,PlaySectionControllerDelegate>
@property(nonatomic, strong, readwrite) UICollectionView *collectionView;
@property(nonatomic, strong, readwrite) IGListAdapter *listAdapter;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];

    [self.view addSubview:({
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[UICollectionViewFlowLayout new]];
        _collectionView.backgroundColor=[UIColor whiteColor];
        _collectionView;
    })];

     _listAdapter = [[IGListAdapter alloc] initWithUpdater:[IGListAdapterUpdater new]
                                            viewController:self
                                          workingRangeSize:0];
     _listAdapter.dataSource = self;
     _listAdapter.scrollViewDelegate = self;
     _listAdapter.collectionView = _collectionView;
    [self requestList];
}
- (void)requestList{
    NSString *wid=@"all";
    NSString *url=[NSString stringWithFormat:list_URL,wid];;
    [ZBRequestManager requestWithConfig:^(ZBURLRequest *request){
        request.URLString=url;
    } success:^(id responseObject,ZBURLRequest *request){
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if (request.apiType==ZBRequestTypeRefresh) {
                [self.dataArray removeAllObjects];
            }
            NSDictionary *dataDict = (NSDictionary *)responseObject;
            NSArray *array=[dataDict objectForKey:@"videos"];
               
            for (NSDictionary *dict in array) {
                ListModel *model=[[ListModel alloc]initWithDict:dict];
                [self.dataArray addObject:model];
            }
            [self.listAdapter reloadDataWithCompletion:nil];
        }
    } failure:^(NSError *error){
    }];
}
#pragma mark - PlaySectionControllerDelegate
- (void)playSectiondidSelectItemAtIndex:(NSInteger)index model:(nonnull ListModel *)model{
    DetailsViewController *detailsVC=[[DetailsViewController alloc]init];
    detailsVC.model=model;
    detailsVC.functionType=Details;
    [self.navigationController pushViewController:detailsVC animated:YES];
}
#pragma mark - IGListAdapterDataSource
- (NSArray<id <IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return self.dataArray;
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    PlaySectionController *sectionVC=[[PlaySectionController alloc]init];
    sectionVC.delegate=self;
    return sectionVC;
}

- (nullable UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    if (@available(iOS 13.0, *)) {
        UIView *bjView=[[UIView alloc]init];
        bjView.backgroundColor=[UIColor whiteColor];
        UIImageView *emptyImage=[[UIImageView alloc]initWithFrame:CGRectMake(ZB_SCREEN_WIDTH/2-50,ZB_SCREEN_HEIGHT/2-50, 110, 100)];
        emptyImage.image=[[UIImage systemImageNamed:@"wifi.slash"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [bjView addSubview:emptyImage];
        return bjView;
    } else {
        return nil;
    }
}
#pragma mark - UISCROLLVIEW DELEGATE

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    //
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
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
