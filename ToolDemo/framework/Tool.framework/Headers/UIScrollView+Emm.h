//
//  UIScrollView+Emm.h
//  ScrollViewDemo
//
//  Created by Emmm on 2018/7/31.
//  Copyright © 2018年 Emmm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>

#define NOTHING_IMSGEWIDTH  240
#define TOPBTN_WIDTH 30
#define TEXT_COLOR [UIColor lightGrayColor]

typedef void (^ButtonBlock)(UIButton *);
@interface EmmButton : UIButton
@property(nonatomic,copy)ButtonBlock block;

- (void)addTapBlock:(ButtonBlock)block;
@end


@interface UIScrollView (Emm)
//返回顶部Btn
@property (nonatomic,strong) UIButton *backToTopBtn;
//下拉刷新(头部)
@property (nonatomic,strong) MJRefreshNormalHeader *headerRefresh;
//上拉加载(底部)
@property (nonatomic,strong) MJRefreshBackNormalFooter *footerRefresh;
//缺省页
@property (nonatomic,strong) UIView *nothingView;
//下拉动画背景
@property (nonatomic,strong) UIView *dropView;

//page 页码
@property (nonatomic,assign) NSInteger  page;


/**
 设置返回顶部Btn
 */
- (void)addScrollToTopButton;

/**
 移除返回顶部Btn
 */
- (void)removeScrollToTopButton;

/**
 移除返回顶部Btn点击事件
 */
- (void)removeScrollToTopButtonTarget;

 




/**
 添加上拉加载控件
 */
- (void)addFooterRefreshWithBlock:(void(^)(void))block;


/**
 添加下拉刷新控件
 */
- (void)addHeaderRefreshWithBlock:(void(^)(void))block;


/**
 移除下拉刷新头部控件
 */
- (void)removeHeader;

/**
 *  移除上拉加载控件
 */
- (void)removeFooter;



- (void)endRefreshing;

@end
