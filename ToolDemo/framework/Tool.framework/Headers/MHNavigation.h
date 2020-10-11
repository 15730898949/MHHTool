//
//  MHNavigation.h
//  Tool
//
//  Created by 马海鸿 on 2020/10/10.
//  Copyright © 2020 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 当前很多导航控制器的框架都是UINavigationController的类别，虽然用法简单但操作繁杂。几乎都是对Navigation Bar样式的统一设置，如果在一个控制器中设置了样式，然后push的下一个控制器也设置了样式。当pop时，如果没有还原Navigation Bar的样式，就会影响到上一个控制器的样式。这个框架很好解决了这个问题，而且如果你有自定义的UINavigationController，则它的设置不会影响到你的自定义导航控制器的样式。当然这个框架的缺点是不适合用于设置皮肤，因为Navigation Bar的样式是由UINavigationController里的控制器单独控制的。
 */

@interface UIViewController (MHNavigation)

- (void)addNavBar;

@property(nonatomic, strong)UIView               *navBar;                   //导航栏

@property(nonatomic, strong)UIButton            *backBtn;                  //返回按钮

@property(nonatomic, strong)UILabel              *titleLab;                 //标题

@property(nonatomic, strong)UIButton            *RightBtn;                  //右按钮


@property(nonatomic, strong)UIView               *barline;                  //分割线





/**
 当前控制器不是导航控制器时，设置电池电量条的颜色
 Setting the statusBar Style in the UIControler which is not kind of UINavigationController.
 */
@property(nonatomic, assign) UIStatusBarStyle statusBarStyle;

//设置显示隐藏电池电量条状态栏
@property(nonatomic, assign) BOOL statusBarHidden;





/**
 导航条和电池电量条高度
 Return a value of navigation bar and status Bar height.
 */
@property(nonatomic, assign ,readonly) CGFloat navigationBarAndStatusBarHeight;


/**
 当前导航栏在y轴方向上偏移距离
 Setting the navigation bar translation in the y axis with a value.
 */
@property(nonatomic, assign) CGFloat            navigationBarTranslationY;//导航在y轴方向上偏移距离

- (void)backAction;//点击返回

- (void)RightAction;//点击右按钮


@end



