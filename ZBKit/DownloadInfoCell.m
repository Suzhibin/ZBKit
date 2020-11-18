//
//  DownloadInfoCell.m
//  FKDownloaderDemo
//
//  Created by norld on 2020/1/19.
//  Copyright © 2020 norld. All rights reserved.
//

#import "DownloadInfoCell.h"

#import <Masonry/Masonry.h>
#import "ZBNetworking.h"
@interface DownloadInfoCell ()

@property (nonatomic, strong) UILabel *urlLabel;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UILabel *progressInfoLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UIButton *controlButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, assign) NSUInteger identifier;
@property (nonatomic, assign) BOOL isDownload;
@end

@implementation DownloadInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.urlLabel = [[UILabel alloc] init];
        self.urlLabel.font = [UIFont systemFontOfSize:15];
        self.urlLabel.text = @"下载链接";
        [self.contentView addSubview:self.urlLabel];
        
        self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        [self.contentView addSubview:self.progressView];
        
        self.progressInfoLabel = [[UILabel alloc] init];
        self.progressInfoLabel.font = [UIFont systemFontOfSize:15];
        self.progressInfoLabel.textAlignment = NSTextAlignmentLeft;
        self.progressInfoLabel.text = @"进度信息";
        [self.contentView addSubview:self.progressInfoLabel];
        
        self.stateLabel = [[UILabel alloc] init];
        self.stateLabel.font = [UIFont systemFontOfSize:15];
        self.stateLabel.textAlignment = NSTextAlignmentRight;
        self.stateLabel.text = @"状态信息";
        [self.contentView addSubview:self.stateLabel];
        
        self.controlButton = [[UIButton alloc] init];
        [self.controlButton setTitle:@"开始" forState:UIControlStateNormal];
        [self.controlButton setTitle:@"暂停" forState:UIControlStateSelected];
        [self.controlButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
        [self.controlButton addTarget:self action:@selector(controlDidTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.controlButton];
        
        self.cancelButton = [[UIButton alloc] init];
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(cancelDidTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.cancelButton];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:@"DidEnterBackground" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [self resumeForURL:self.url downloadState:ZBDownloadStateStop];
        }];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:@"DidBecomeActive" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            if (self.isDownload==YES) {
               [self resumeForURL:self.url downloadState:ZBDownloadStateStart];
            }
        }];
        
    }
    return self;
}
#pragma mark - Action
- (void)controlDidTap:(UIButton *)sender {
    sender.selected =!sender.selected;
    if (sender.isSelected==YES) {
        [self resumeForURL:self.url downloadState:ZBDownloadStateStart];
    }else{
        [self resumeForURL:self.url downloadState:ZBDownloadStateStop];
    }
}

- (void)cancelDidTap:(UIButton *)sender {
    [ZBRequestManager cancelRequest:self.identifier];
}

#pragma mark - Getter/Setter
- (void)setUrl:(NSString *)url {
    _url = url;
    self.urlLabel.text=url;
    
}
- (void)resumeForURL:(NSString *)URLString downloadState:(ZBDownloadState)downloadState{
    self.isDownload=YES;
    self.identifier=[ZBRequestManager requestWithConfig:^(ZBURLRequest * request) {
        request.url=URLString;
        request.downloadState=downloadState;
        request.methodType=ZBMethodTypeDownLoad;
    } progress:^(NSProgress * _Nullable progress) {
        NSLog(@"identifier：%ld onProgress: %.2f", self.identifier,100.f * progress.completedUnitCount/progress.totalUnitCount);
    } success:^(id  responseObject,ZBURLRequest * request) {
        NSLog(@"ZBMethodTypeDownLoad 此时会返回存储路径文件: %@", responseObject);
        self.isDownload=NO;
        self.controlButton.selected=NO;
    //        [self downLoadPathSize:request.downloadSavePath];//返回下载路径的大小
    //      //  [self downLoadPathSize:[[ZBCacheManager sharedInstance] tmpPath]];//返回下载路径的大小
    //
    //        sleep(5);
    //        [[NSFileManager defaultManager] removeItemAtPath:responseObject error:nil];
    ////        //删除下载的文件
    ////        [[ZBCacheManager sharedInstance]clearDiskWithPath:request.downloadSavePath completion:^{
    //            NSLog(@"删除下载的文件");
    //            [self downLoadPathSize:request.downloadSavePath];
    //     //   }];
    //
    //
    } failure:^(NSError * _Nullable error) {
         self.controlButton.selected=NO;
        
    }];
    NSLog(@"identifier:%ld",self.identifier);
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.controlButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.contentView);
        make.width.mas_equalTo(80);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.contentView);
        make.top.equalTo(self.controlButton.mas_bottom);
        make.width.mas_equalTo(80);
        make.height.equalTo(self.controlButton.mas_height);
    }];
    
    [self.urlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).mas_offset(8);
        make.left.equalTo(self.contentView.mas_left).mas_offset(4);
        make.right.equalTo(self.controlButton.mas_left).mas_offset(8);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.urlLabel.mas_bottom).mas_offset(8);
        make.left.equalTo(self.contentView.mas_left).mas_offset(4);
        make.right.equalTo(self.controlButton.mas_left).mas_offset(8);
        make.height.mas_equalTo(2);
    }];
    
    [self.progressInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressView.mas_bottom).mas_offset(8);
        make.left.equalTo(self.contentView.mas_left).mas_offset(4);
    }];
    
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressView.mas_bottom).mas_offset(8);
        make.right.equalTo(self.controlButton.mas_left).mas_offset(4);
        make.left.equalTo(self.progressInfoLabel.mas_right);
    }];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    // 在 cell 被复用前清除旧的信息回调
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
