//
//  ZBWebImageManager.m
//  ZBKit
//
//  Created by NQ UEC on 17/3/14.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ZBWebImageManager.h"
#import "NSFileManager+pathMethod.h"

NSString *const ImageDefaultPath =@"AppImage";
static const NSInteger ImageCacheMaxCacheAge  = 60*60*24*7;
@implementation ZBWebImageManager
+ (ZBWebImageManager *)sharedInstance{
    static ZBWebImageManager *imageInstance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageInstance = [[ZBWebImageManager alloc] init];
    });
    return imageInstance;
}

- (id)init{
    self = [super init];
    if (self) {
        
        [[ZBCacheManager sharedInstance]createDirectoryAtPath:[self imageFilePath]];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(automaticCleanImageCache) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(automaticCleanImageCache)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backgroundCleanImageCache) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)downloadImageUrl:(NSString *)imageUrl{
    [self downloadImageUrl:imageUrl completion:nil];
}

- (void)downloadImageUrl:(NSString *)imageUrl completion:(downloadCompletion)completion{
    [self downloadImageUrl:imageUrl path:[self imageFilePath] completion:completion];
}

- (void)downloadImageUrl:(NSString *)imageUrl path:(NSString *)path{
    [self downloadImageUrl:imageUrl path:path completion:nil];
}

- (void)downloadImageUrl:(NSString *)imageUrl path:(NSString *)path completion:(downloadCompletion)completion{
    
    if ([[ZBCacheManager sharedInstance]diskCacheExistsWithKey:imageUrl path:path]) {
        
        [[ZBCacheManager sharedInstance]getCacheDataForKey:imageUrl path:path value:^(NSData *data,NSString *filePath) {
            
            UIImage *image=[UIImage imageWithData:data];
            
            completion(image) ;
        }];
        
    }else{
        [self requestImageUrl:imageUrl completion:^(UIImage *image){
            
            [[ZBCacheManager sharedInstance]storeContent:image forKey:imageUrl path:path];
            
            completion(image);
        }];
    }
}

- (void)requestImageUrl:(NSString *)imageUrl completion:(downloadCompletion)completion{
    if (!imageUrl)return;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSURL *url=[NSURL URLWithString:imageUrl];
        
        NSData *data=[NSData dataWithContentsOfURL:url];
        
        UIImage *image=[UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(image);
        });
    });
}

- (NSUInteger)imageFileSize{
    return [[ZBCacheManager sharedInstance]getFileSizeWithpath:[self imageFilePath]];
}

- (NSUInteger)imageFileCount{
    return [[ZBCacheManager sharedInstance]getFileCountWithpath:[self imageFilePath]];
}

- (void)clearImageFile{
    [self clearImageFileCompletion:nil];
}

- (void)clearImageFileCompletion:(ZBCacheCompletedBlock)completion{
    [[ZBCacheManager sharedInstance]clearDiskWithpath:[self imageFilePath] completion:completion];
}

- (void)clearImageForkey:(NSString *)key{
    [self clearImageForkey:key completion:nil];
}

- (void)clearImageForkey:(NSString *)key completion:(ZBCacheCompletedBlock)completion{
    [[ZBCacheManager sharedInstance]clearCacheForkey:key path:[self imageFilePath] completion:completion];
}

- (void)automaticCleanImageCache{
     [[ZBCacheManager sharedInstance] clearCacheWithTime:-ImageCacheMaxCacheAge path:[self imageFilePath] completion:nil];
}

- (void)backgroundCleanImageCache {
    [[ZBCacheManager sharedInstance]backgroundCleanCacheWithPath:[self imageFilePath]];
}

- (NSString *)imageFilePath{
    NSString *AppImagePath =  [[[ZBCacheManager sharedInstance]ZBKitPath]stringByAppendingPathComponent:ImageDefaultPath];
    return AppImagePath;
}

/*
 - (void)saveThePhotoAlbum:(UIImage *)image{
 UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
 }
 
 - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
 NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
 if (error) {
 
 }else{
 
 }
 }
 */
@end
