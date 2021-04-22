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

@property (nonatomic, copy) void (^contentSizeChanged)(CGSize size);
@property (nonatomic, copy) void (^didFinishPickingPhotosHandle)(NSArray<UIImage *> *photos);


@end

NS_ASSUME_NONNULL_END
