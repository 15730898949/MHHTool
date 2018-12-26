//
//  UIImage+Extension.h
//  WechatMaster
//
//  Created by Peng on 2018/3/5.
//  Copyright © 2018年 Peng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

+ (UIImage *)shotcutView:(UIView *)view;
+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;




@end
