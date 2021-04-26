//
//  MHOnePhotoImageView.h
//  sdl
//
//  Created by 马海鸿 on 2021/4/12.
//  Copyright © 2021 马海鸿. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHOnePhotoImageView : UIImageView
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, copy)void(^selectImageBlock)(MHOnePhotoImageView *imageView);
@property (nonatomic, copy)void(^deleteImageBlock)(MHOnePhotoImageView *imageView);

@end

NS_ASSUME_NONNULL_END
