//
//  UIButton+Category.h
//  Tool
//
//  Created by Mac on 2020/8/17.
//  Copyright © 2020 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MHButtonEdgeInsetsStyle) {
    MHButtonEdgeInsetsStyleTop,    // image在上，label在下
    MHButtonEdgeInsetsStyleLeft,   // image在左，label在右
    MHButtonEdgeInsetsStyleBottom, // image在下，label在上
    MHButtonEdgeInsetsStyleRight   // image在右，label在左
};


@interface UIButton(Category)

/**
 * 设置button的titleLabel和imageView的布局样式，及间距
 *
 * @param style titleLabel和imageView的布局样式
 * @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(MHButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;


//倒计时
/**
 @param seconds 倒计时的秒数
 */
- (void)startCountDownWithSeconds:(NSInteger)seconds;

//倒计时
/**
 @param seconds 倒计时的秒数
 @param callback 倒计时回调并把当前剩余秒数返回
 */
-( void)countDownWithSeconds:(NSInteger)seconds  callback:(void(^)(NSString *string))callback;

@end


