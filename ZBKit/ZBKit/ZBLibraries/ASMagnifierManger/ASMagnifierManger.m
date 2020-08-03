
//  ASMagnifierManger.m
//  ASMagnifierMangerDemo
//
//  Created by OneForAll on 2018/1/29.
//  Copyright © 2018年 OneForAll. All rights reserved.
//

#import "ASMagnifierManger.h"

static ASMagnifierManger *_sharedInstance;

@interface ASMagnifierManger ()
/* 放大镜 */
@property (nonatomic, strong) UIImageView *cutImageView;
/* 全屏的截图 */
@property (nonatomic, strong) UIImage *cutScreenImage;
@end

@implementation ASMagnifierManger
- (instancetype)init{
    self = [super init];
    if (self) {
        [self initParameter];
    }
    return self;
}
- (void)initParameter {
    self.magnifierWidth = 90;
    self.magnification = 1.5;
}

#pragma mark -----------  截图方法 -----------------
//截图
- (UIImage *)snapshot:(UIView *)view {
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size,YES,0);
    
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
- (UIImage *)ct_imageFromImage:(UIImage *)image inRect:(CGRect)rect{
    
    //把像 素rect 转化为 点rect（如无转化则按原图像素取部分图片）
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat x= rect.origin.x*scale,y=rect.origin.y*scale,w=rect.size.width*scale,h=rect.size.height*scale;
    CGRect dianRect = CGRectMake(x, y, w, h);
    
    //截取部分图片并生成新图片
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, dianRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    return newImage;
}

- (void)magnifier_touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event view:(UIView *)view{
    self.cutScreenImage = [self snapshot:view];
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:view];
    self.cutImageView.center =CGPointMake(point.x, point.y-self.magnifierWidth/_magnification); // point;
    UIImage *image =  [self ct_imageFromImage:self.cutScreenImage inRect:CGRectMake(point.x-self.magnifierWidth/_magnification/2, point.y-(self.magnifierWidth+self.magnifierWidth/2)/_magnification, self.magnifierWidth/_magnification, self.magnifierWidth/_magnification)];
    self.cutImageView.image = image;
    [view addSubview:self.cutImageView];
}
- (void)magnifier_touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event view:(UIView *)view {
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:view];
    self.cutImageView.center =CGPointMake(point.x, point.y-self.magnifierWidth/_magnification);// point;
    UIImage *image =  [self ct_imageFromImage:self.cutScreenImage inRect:CGRectMake(point.x-self.magnifierWidth/_magnification/2, point.y-(self.magnifierWidth+self.magnifierWidth/2)/_magnification, self.magnifierWidth/_magnification, self.magnifierWidth/_magnification)];
    self.cutImageView.image = image;
}
- (void)magnifier_touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
   [self.cutImageView removeFromSuperview];
}

#pragma mark ----------  set ----------------------
- (void)setMagnification:(float)magnification {
    if(magnification<=1) return;
    _magnification = magnification;
}
- (void)setMagnifierWidth:(float)magnifierWidth {
    _magnifierWidth = magnifierWidth;
    _cutImageView.frame = CGRectMake(0, 0, magnifierWidth, magnifierWidth);
    _cutImageView.layer.cornerRadius = magnifierWidth/2;
}
- (UIImageView *)cutImageView {
    if (!_cutImageView) {
        _cutImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.magnifierWidth, self.magnifierWidth)];
        _cutImageView.layer.masksToBounds = YES;
        _cutImageView.layer.borderColor = [[UIColor grayColor] CGColor];
        _cutImageView.layer.borderWidth = 1;
        _cutImageView.layer.cornerRadius = self.magnifierWidth/2;
    }
    return _cutImageView;
}

@end
