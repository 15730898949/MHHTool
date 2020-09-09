//
//  UIScrollView+Emm.m
//  ScrollViewDemo
//
//  Created by Emmm on 2018/7/31.
//  Copyright © 2018年 Emmm. All rights reserved.
//

#import "UIScrollView+Emm.h"


@implementation UIScrollView (Emm)
@dynamic backToTopBtn;
@dynamic nothingView;
@dynamic dropView;

//实现get/set方法 防止crash
static const char FPPageSizeKey = '\0';
- (NSInteger)page{
    NSNumber *pageSize = (NSNumber*)objc_getAssociatedObject(self, &FPPageSizeKey);
    return pageSize.integerValue == 0 ? 1 : pageSize.integerValue;
}
- (void)setPage:(NSInteger)page{
    objc_setAssociatedObject(self, &FPPageSizeKey,
                             @(page), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIButton *)backToTopBtn{
    return objc_getAssociatedObject(self, @selector(backToTopBtn));
}
- (void)setBackToTopBtn:(UIButton *)backToTopBtn{
    objc_setAssociatedObject(self, @selector(backToTopBtn), backToTopBtn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)nothingView{
    return objc_getAssociatedObject(self, @selector(nothingView));
}
- (void)setNothingView:(UIView *)nothingView{
    objc_setAssociatedObject(self, @selector(nothingView), nothingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)dropView{
    return objc_getAssociatedObject(self, @selector(dropView));
}
- (void)setDropView:(UIView *)dropView{
    objc_setAssociatedObject(self, @selector(dropView), dropView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (MJRefreshNormalHeader *)headerRefresh{
    return objc_getAssociatedObject(self, @selector(headerRefresh));
}

- (void)setHeaderRefresh:(MJRefreshNormalHeader *)headerRefresh{
    objc_setAssociatedObject(self, @selector(headerRefresh), headerRefresh, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MJRefreshBackNormalFooter *)footerRefresh{
    
    return objc_getAssociatedObject(self, @selector(footerRefresh));
}

- (void)setFooterRefresh:(MJRefreshBackNormalFooter *)footerRefresh{
    objc_setAssociatedObject(self, @selector(footerRefresh), footerRefresh, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

/**
 设置返回顶部按钮
 */
- (void)addScrollToTopButton{    
    CGFloat margin = 10.f;
    CGFloat x = self.frame.origin.x + self.superview.frame.size.width - TOPBTN_WIDTH -margin;
    CGFloat y = self.superview.frame.size.height - TOPBTN_WIDTH - margin;
    self.backToTopBtn = [[UIButton alloc] init];
    self.backToTopBtn.frame = CGRectMake(x, y, TOPBTN_WIDTH, TOPBTN_WIDTH);
    [self.backToTopBtn setBackgroundImage:[UIImage imageNamed:@"up-circle"] forState:0];
    self.backToTopBtn.alpha = 1.f;
    self.backToTopBtn.clipsToBounds = NO;
    self.backToTopBtn.hidden = NO;
    [self.backToTopBtn addTarget:self
                          action:@selector(backToTop)
                forControlEvents:UIControlEventTouchUpInside];
    [self.superview addSubview:self.backToTopBtn];
    [self.superview bringSubviewToFront:self.backToTopBtn];
}

/**
 移除返回顶部Btn
 */
- (void)removeScrollToTopButton{
    if (!self.backToTopBtn) return;
    
    self.backToTopBtn.hidden = YES;
    self.backToTopBtn = nil;
    [self.backToTopBtn removeFromSuperview];
    
}

/**
 移除返回顶部Btn点击事件
 */
- (void)removeScrollToTopButtonTarget{
    if (!self.backToTopBtn) return;
    [self.backToTopBtn removeTarget:self
                             action:@selector(backToTopBtn)
                   forControlEvents:UIControlEventTouchUpInside];
}

/**
 回到顶部
 */
- (void)backToTop{
    [self setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];
}

/**
 添加上拉加载控件
 
 */
- (void)addFooterRefreshWithBlock:(void(^)(void))block{
        //  6.1上滑刷新
        MJRefreshBackNormalFooter *refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            self.page  += 1;
            if (block) {
                block();
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0/*延迟执行时间*/ * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.mj_footer endRefreshing];
            });
            
            
        }];
        
        refreshFooter.automaticallyChangeAlpha = YES;    //上拉时透明度改变
        [refreshFooter.arrowView setHidden:YES];

        self.footerRefresh = refreshFooter;
        self.mj_footer = self.footerRefresh;

        [self bringSubviewToFront:self.mj_footer];


}




/**
  添加下拉刷新控件
  
  */
- (void)addHeaderRefreshWithBlock:(void(^)(void))block{
        //  6.2下拉刷新器header
        MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page  = 1;
            if (block) {
                block();
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0/*延迟执行时间*/ * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.mj_header endRefreshing];
            });
            
        }];
        self.headerRefresh = refreshHeader;
        self.mj_header = self.headerRefresh;
        
        refreshHeader.lastUpdatedTimeLabel.hidden = YES;    // 隐藏时间label
        [self bringSubviewToFront:self.mj_header];

}


/**
 *  移除下拉刷新头部控件
 */
- (void)removeHeader
{
    __block MJRefreshHeader *header = self.headerRefresh;
    [self.headerRefresh removeFromSuperview];
    self.headerRefresh = nil;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        header = nil;
    });
    
    
}


/**
 *  移除上拉加载尾部控件
 */
- (void)removeFooter
{
    if (!self.mj_footer) {
        return;
    }
    [self.mj_footer endRefreshing];
    self.contentSize = CGSizeMake(self.contentSize.width, self.contentSize.height - self.mj_footer.mj_size.height);
    __block MJRefreshFooter *foot = self.mj_footer;
    [self.mj_footer removeFromSuperview];
    self.mj_footer = nil;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        foot = nil;
    });
    foot = nil;
}

- (void)endRefreshing{
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}


@end
