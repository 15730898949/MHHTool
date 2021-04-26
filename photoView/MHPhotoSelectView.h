//
//  MHPhotoSelectView.h
//  PeanutBusiness
//
//  Created by Mac on 2020/12/10.
//  Copyright © 2020 因联科技. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MHPhotoViewImage(imageName) [[UIImage imageWithContentsOfFile:[[NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"MHPhotoView" ofType:@"bundle"]] pathForResource:imageName ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]

NS_ASSUME_NONNULL_BEGIN

@interface MHPhotoSelectView : UIView
//刷新
- (void)reloadData;
@property(nonatomic , strong)NSMutableArray *selectedPhotos;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, readonly) CGSize contentSize;

@property (assign, nonatomic)IBInspectable NSInteger maxCount;  ///< 照片最大可选张数，设置为1即为单选模式
@property (assign, nonatomic)IBInspectable NSInteger rowCount;  ///每行多少个

@property (assign, nonatomic)IBInspectable BOOL isAdd;  ///是否需要添加按钮
@property (assign, nonatomic)IBInspectable BOOL isDelete;  ///是否需要删除按钮
@property (assign, nonatomic)IBInspectable BOOL isMove;  ///是否需要移动




@property (nonatomic, copy) void (^changeSortBlock)(NSMutableArray *selectedPhotos);

@property (nonatomic, copy)void(^addClickBlock)(NSMutableArray *selectedPhotos);

@property (nonatomic, copy) void (^deleteClickBlock)(NSMutableArray *selectedPhotos);


@end

NS_ASSUME_NONNULL_END
