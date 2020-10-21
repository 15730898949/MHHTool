//
//  TZPhotoPreviewController.h
//  TZImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TZPhotoPreviewController : UIViewController
/**
 Use this init method / 用这个初始化方法

 @param photos 所有图片数组，支持PHAsset、UIImage、NSURL对象
 @param currentIndex 用户点击的图片的索引
 @param tzImagePickerVc 不必传，主要是为了读取一些配置
 @return 一个TZPreviewController实例
 */
- (instancetype)initWithPhotos:(NSArray *)photos currentIndex:(NSInteger)currentIndex tzImagePickerVc:(UIViewController *)tzImagePickerVc;

@property (nonatomic, strong) NSMutableArray *models;                  ///< All photo models / 所有图片模型数组
@property (nonatomic, strong) NSMutableArray *photos;                  ///< All photos  / 所有图片数组
@property (nonatomic, assign) NSInteger currentIndex;           ///< Index of the photo user click / 用户点击的图片的索引
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;       ///< If YES,return original photo / 是否返回原图
@property (nonatomic, assign) BOOL isCropImage;

/// Return the new selected photos / 返回最新的选中图片数组
@property (nonatomic, copy) void (^backButtonClickBlock)(BOOL isSelectOriginalPhoto);
@property (nonatomic, copy) void (^doneButtonClickBlock)(BOOL isSelectOriginalPhoto);
@property (nonatomic, copy) void (^doneButtonClickBlockCropMode)(UIImage *cropedImage,id asset);
@property (nonatomic, copy) void (^doneButtonClickBlockWithPreviewType)(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto);

/// 传入的photos有NSURL对象时会触发，请使用你依赖的图片库给imageView设置图片
@property (nonatomic, copy) void (^setImageWithURLBlock)(NSURL *URL, UIImageView *imageView, void (^completion)(void));


@end
