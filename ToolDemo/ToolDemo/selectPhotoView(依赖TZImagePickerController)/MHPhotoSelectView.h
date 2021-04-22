//
//  MHPhotoSelectView.h
//  PeanutBusiness
//
//  Created by Mac on 2020/12/10.
//  Copyright © 2020 因联科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHPhotoSelectView : UIView
@property(nonatomic , strong)NSMutableArray *selectedPhotos;

@property (assign, nonatomic) BOOL showTakePhoto;  ///< 允许拍照
@property (assign, nonatomic) BOOL showTakeVideo;  ///< 允许拍视频
@property (assign, nonatomic) BOOL allowPickingVideo;  ///< 允许选择视频
@property (assign, nonatomic) BOOL allowPickingImage; ///< 允许选择图片
@property (assign, nonatomic) BOOL allowPickingGif;///< 允许选择GIF
@property (assign, nonatomic) BOOL allowPickingOriginalPhoto; ///< 允许选择原图
@property (assign, nonatomic) NSInteger maxCount;  ///< 照片最大可选张数，设置为1即为单选模式
@property (assign, nonatomic) NSInteger columnNumber;
@property (assign, nonatomic) BOOL allowCrop;
@property (assign, nonatomic) BOOL needCircleCrop;
@property (assign, nonatomic) BOOL allowPickingMuitlpleVideo;
@property (assign, nonatomic) BOOL showSelectedIndex;

@property (nonatomic, copy) void (^contentSizeChanged)(CGSize size);
@property (nonatomic, copy) void (^didFinishPickingPhotosHandle)(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto);


- (void)pushTZImagePickerController;

@end

NS_ASSUME_NONNULL_END
