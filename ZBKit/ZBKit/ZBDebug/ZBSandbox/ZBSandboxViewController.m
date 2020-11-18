//
//  ZBSandboxViewController.m
//  ZBKit
//
//  Created by NQ UEC on 2018/4/25.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "ZBSandboxViewController.h"
#import "ZBMacros.h"
#import "ZBCacheManager.h"
#import "ZBFileModel.h"
#import <QuickLook/QuickLook.h>
#import "ZBDebugWebViewController.h"
#import "ZBDebug.h"
@interface ZBSandboxViewController ()<UITableViewDelegate,UITableViewDataSource,QLPreviewControllerDataSource,UIViewControllerPreviewingDelegate>
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)UITableView *sandboxTableView;
@property (nonatomic,strong) NSURL *URL;
@property (strong, nonatomic) ZBFileModel *previewingFileModel;
@end
@implementation ZBSandboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor blackColor];

    [self leftButton];

    self.dataArray= [self getDiskFileWithURL:self.model.URL];
    [self.view addSubview:self.sandboxTableView];
    [self.sandboxTableView reloadData];
    [self isAutomaticJump];
    
}
- (void)isAutomaticJump{
    if (self.fileNames.count>0) {
        NSMutableArray *fileTitles=[[NSMutableArray alloc]init];
        [self.dataArray enumerateObjectsUsingBlock:^(ZBFileModel *fileModel, NSUInteger idx, BOOL * _Nonnull stop) {
            [fileTitles addObject:fileModel.fileName];
        }];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF  in %@",self.fileNames];
        NSArray *arr = [fileTitles filteredArrayUsingPredicate:predicate];
        if (arr.count>0) {
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.dataArray enumerateObjectsUsingBlock:^(ZBFileModel *fileModel, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *fileName= [arr objectAtIndex:0];
                    NSLog(@"fileName:%@",fileModel.fileName);
                    NSLog(@"相同元素:%@",fileName);
                    if ([fileModel.fileName isEqualToString:fileName]) {
                        UIViewController *vc = [self viewControllerWithFileInfo:fileModel];
                        if ([vc isKindOfClass:[QLPreviewController class]]) {
                            [self presentViewController:vc animated:YES completion:nil];
                        }else{
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                    }
                }];
                          
            });
        }
    }
}
- (NSMutableArray *)getDiskFileWithURL:(NSURL *)URL{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    BOOL isDir = NO;
    BOOL isExists = [NSFileManager.defaultManager fileExistsAtPath:URL.path isDirectory:&isDir];
    if (isExists && isDir) {
        NSError *error;
        NSArray *subpaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:URL.path error:&error];
      
        if (!error){
            NSString *lastPathComponent;
            for (NSString *subpath in subpaths) {
                ZBKLog(@"URL:%@ subpath:%@",URL,subpath);
//                if ([URL.absoluteString hasSuffix:@"com.hackemist.SDWebImageCache.default/"]) {
//                   lastPathComponent=[subpath stringByAppendingString:@".png"];
//                }else{
                    lastPathComponent=subpath;
              //  }
                ZBFileModel *model=[[ZBFileModel alloc]initWithFileURL:[URL URLByAppendingPathComponent:subpath]];
                [array addObject:model];
            }
        }
    }
    return array;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *listID=@"list";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:listID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:listID];
        
        cell.backgroundColor = [UIColor blackColor];
        cell.contentView.backgroundColor = [UIColor blackColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ZBFileModel *model=[self.dataArray objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:model.typeImageName inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
    cell.textLabel.text=model.fileName;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.adjustsFontSizeToFitWidth=YES;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.modificationDateText];
    if ([attributedString length] >= 21) {
        [attributedString setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:66/255.0 green:212/255.0 blue:89/255.0 alpha:1.0], NSFontAttributeName: [UIFont boldSystemFontOfSize:12]} range:NSMakeRange(0, 21)];
    }
    cell.detailTextLabel.attributedText = [attributedString copy];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    cell.accessoryType = model.type == ZBFileTypeDirectory ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZBFileModel *model=[self.dataArray objectAtIndex:indexPath.row];
    UIViewController *vc = [self viewControllerWithFileInfo:model];
    if ([vc isKindOfClass:[QLPreviewController class]]) {
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (UIViewController *)viewControllerWithFileInfo:(ZBFileModel *)model{
    if (model.type==ZBFileTypeDirectory) {
        ZBSandboxViewController *sandboxVC = [[ZBSandboxViewController alloc] init];
        //        sandboxViewController.hidesBottomBarWhenPushed = YES;//liman
        sandboxVC.fileNames=self.fileNames;
        sandboxVC.model = model;
        return sandboxVC;
    } else {
        if ([QLPreviewController canPreviewItem:model.URL]) {
            ZBKLog(@"QLPreview");
            self.previewingFileModel = model;
            QLPreviewController *previewController = [[QLPreviewController alloc] init];
            previewController.dataSource = self;
            return previewController;
        } else {
            ZBKLog(@"Web");
            [self.fileNames  removeAllObjects];
            ZBDebugWebViewController *webVC= [[ZBDebugWebViewController alloc] init];
            webVC.hidesBottomBarWhenPushed = YES;//liman
            webVC.model = model;
            return webVC;
        }
    }
}
//懒加载
- (UITableView *)sandboxTableView{
    if (!_sandboxTableView) {
        _sandboxTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ZB_SCREEN_WIDTH, ZB_SCREEN_HEIGHT-ZB_TABBAR_HEIGHT-ZB_NAVBAR_HEIGHT) style:UITableViewStylePlain];
        _sandboxTableView.delegate=self;
        _sandboxTableView.dataSource=self;
        _sandboxTableView.tableFooterView=[[UIView alloc]init];
        _sandboxTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _sandboxTableView.rowHeight = 60.0;
        _sandboxTableView.backgroundColor = [UIColor blackColor];
    }
    return _sandboxTableView;
}
- (void)leftButton{
    if (self.isHomeDirectory) {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] style:UIBarButtonItemStyleDone target:self action:@selector(exit)];
        leftItem.tintColor = [UIColor colorWithRed:66/255.0 green:212/255.0 blue:89/255.0 alpha:1.0];
        self.navigationController.topViewController.navigationItem.leftBarButtonItem = leftItem;
    }else{
        self.title = self.model.fileName;
    }
}
- (void)exit{
    //[[ZBDebug sharedInstance]enable];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - QLPreviewControllerDataSource

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return self.previewingFileModel ? 1 : 0;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return self.previewingFileModel.URL;
}
#pragma mark - UIViewControllerPreviewingDelegate

/// Create a previewing view controller to be shown at "Peek".
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    // Obtain the index path and the cell that was pressed.
    NSIndexPath *indexPath = [self.sandboxTableView indexPathForRowAtPoint:location];
    UITableViewCell *cell = [self.sandboxTableView cellForRowAtIndexPath:indexPath];
    if (!cell) { return nil; }
    
    ZBFileModel *model = [self.dataArray objectAtIndex:indexPath.row];
    // Create a detail view controller and set its properties.
    UIViewController *detailViewController = [self viewControllerWithFileInfo:model];

    detailViewController.preferredContentSize = CGSizeZero;
    
    // Set the source rect to the cell frame, so surrounding elements are blurred.
    if (@available(iOS 9.0, *)) {
        previewingContext.sourceRect = cell.frame;
    } else {
        // Fallback on earlier versions
        // do nothing by author
    }
    return detailViewController;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
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
