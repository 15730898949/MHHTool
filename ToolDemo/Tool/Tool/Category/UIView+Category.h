//
//  UIView+Category.h
//  GSJuZhang
//
//  Created by kiwi on 17/1/15.
//  Copyright (c) 2017年 __Qing__. All rights reserved.
//

#import <UIKit/UIKit.h>



/**
 UIView category relevant with frame
 */
@interface UIView (frame)


/**
 *     左边距离
 */
@property (nonatomic) CGFloat mh_left;

/**
 *     上面的距离
 */
@property (nonatomic) CGFloat mh_top;

/**
 *     右边距离
 */
@property (nonatomic) CGFloat mh_right;

/**
 *     下面的距离
 */
@property (nonatomic) CGFloat mh_bottom;

/**
 *     宽度
 */
@property (nonatomic) CGFloat mh_width;

/**
 *     高度
 */
@property (nonatomic) CGFloat mh_height;

/**
 *     横向的中心点
 */
@property (nonatomic) CGFloat mh_centerX;

/**
 *     纵向的中心点
 */
@property (nonatomic) CGFloat mh_centerY;

/**
 *     左边距离和上面距离
 */
@property (nonatomic) CGPoint mh_origin;

/**
 *     宽度和高度
 */
@property (nonatomic) CGSize mh_size;


@end



/**
 UIView category relevant with extension
 */
@interface UIView (extension)

///额外的数据 方便传递
@property (nonatomic, strong) id extraData;

/**
 *     添加点击
 *
 *     @param pTarget   响应的对象
 *     @param pSelector SEL
 */
- (void)addTapGestureWithTarget:(id)pTarget selector:(SEL)pSelector;

- (void)addDoubleTapGestureWithTarget:(id)pTarget selector:(SEL)pSelector;

/**
 *     视图的控制器
 *
 *     @return 视图的控制器
 */
- (UIViewController *)viewcontroller;

/**
 *     删除所有子视图
 */
- (void)removeAllSubviews;

- (void)removeAllSubviewsExcludView:(UIView *)view;

/**
 *     添加一个数组的子视图
 *
 *     @param subviews 子视图数组
 */
- (void)addSubviews:(NSArray *)subviews;

/**
 *     删除所有为 UIButton 的子视图
 */
- (void)removeSubviewForUIButton;

/**
 *     设置背景图片
 *
 *     @param img 背景图
 */
- (void)setbackgroundImage:(UIImage *)img;

/**
 *     在父视图的所有子视图中进入最上层
 */
- (void)bringToFront;

/**
 *     在父视图的所有子视图中进入最底层
 */
- (void)sendToBack;

/**
 *     截图
 *
 *     @return 截图
 */
- (UIImage *)imageByRenderingView;

/**
 *     返回是否添加手势
 *
 *     @param gestureObjClass 手势对象
 *
 *     @return 是否添加该手势对象
 */
- (BOOL)hasGesture:(id)gestureObjClass;

/**
 *     删除指定的手势
 *
 *     @param gestureObjClass 指定的手势
 *
 *     @return 是否成功删除
 */
- (BOOL)removeGesture:(id)gestureObjClass;

/**
 *     删除所有手势
 *
 *     @return 是否成功删除
 */
- (BOOL)removeAllGestures;


@end



/**
 *     添加提示文字的扩展
 */
@interface UIView (alert)


/**
 *     提示 label 对象的定义
 */
@property (nonatomic, strong, readonly) UILabel *alertLable;

/**
 *     提示文本定义
 */
@property (nonatomic, strong) NSString *alert;


@end



/**
 *     快速添加线条
 */
@interface UIView (line)

/**
 *     添加横线
 *
 *     @param sross 线宽
 *     @param left  距左边的距离
 *     @param top   距上面的距离
 *     @param width 线长
 *     @param color 颜色
 *
 *     @return 线条对象
 */
- (UIView *)addtionHoriaontalLineWithSross:(CGFloat)sross withLeft:(CGFloat)left withTop:(CGFloat)top withWidth:(CGFloat)width withColor:(UIColor *)color;
/**
 *     添加线条
 *
 *     @param sross  线宽
 *     @param left   距左边的距离
 *     @param top    距上面的距离
 *     @param height 线高
 *     @param color  颜色
 *
 *     @return 线条对象
 */
- (UIView *)addtionVerticalLineWithSross:(CGFloat)sross withLeft:(CGFloat)left withTop:(CGFloat)top withHeight:(CGFloat)height withColor:(UIColor *)color;

@end



@interface UIView (help)


/**
 *     输出所有子视图层级
 *
 *     @param superView 被输出子视图层级的父视图
 */
- (void)printViewHierarchy:(UIView *)superView;


@end



@interface UIView (UIImage)


/**
 *     截图
 *
 *     @return 截图
 */
- (UIImage *)capture;


@end



@interface UIView (keyboard)


/**
 *     取到键盘
 *
 *     @return 键盘对象
 */
+ (UIView *)findKeyboard;


@end


@interface UIView (normal)
/**
这些方法加载出来xib(autolayout)的高度是经过计算的,它的高度绝大数情况下不会是屏幕的高度
*/
+(instancetype)viewForXibMu;
+(instancetype)viewForXibMuWithIndex:(NSUInteger)index;
///刷新布局
-(void)refreshViewLayout;
@end
