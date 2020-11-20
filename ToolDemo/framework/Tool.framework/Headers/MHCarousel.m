//
//  MHCarousel.m
//  Tool
//
//  Created by Mac on 2020/11/19.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "MHCarousel.h"

@interface MHCarousel()
@end

@implementation MHCarousel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)reloadData{
    [super reloadData];
}

#pragma mark----------Add Timer
-(void)addTimerWithSecond:(CGFloat)second
{
    [self removeTimer];

    if (second <= 0) {
        return;
    }
    self.delayTimer = [NSTimer scheduledTimerWithTimeInterval:second
                                                  target:self
                                                selector:@selector(nextImage)
                                                userInfo:nil
                                                 repeats:YES];
    //添加到runloop中
    [[NSRunLoop mainRunLoop] addTimer:self.delayTimer forMode:NSDefaultRunLoopMode];
#ifdef ICAROUSEL_IOS
    [[NSRunLoop mainRunLoop] addTimer:self.delayTimer forMode:UITrackingRunLoopMode];
#endif

}

- (void)removeTimer
{
    [self.delayTimer invalidate];
    self.delayTimer = nil;
}

- (void)nextImage{
    NSInteger index = self.currentItemIndex + 1;
    if (index == self.numberOfItems) {
        index  = 0;
    }
    [self scrollToItemAtIndex:index animated:YES];
}


- (void)mh_willBeginDragging{
    if (self.timingSeconds>0) {
        [self removeTimer];
    }
}

- (void)mh_didEndDragging{
    if (self.timingSeconds>0) {
        [self addTimerWithSecond:self.timingSeconds];
    }
}
-(void)mh_didScroll{
    self.pageControl.currentPage  = self.currentItemIndex;
}

///点击pageControl 跳转相应位置
- (void)spacePageControl:(SMPageControl *)pageControl{
    if (self.timingSeconds>0) {
        [self removeTimer];
    }
    [self scrollToItemAtIndex:pageControl.currentPage animated:YES];
    if (self.timingSeconds>0) {
        [self addTimerWithSecond:self.timingSeconds];
    }

}


- (SMPageControl *)pageControl{
    if (!_pageControl) {
    _pageControl      = [[SMPageControl alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - 40, CGRectGetWidth(self.bounds), 40)];
    _pageControl.pageIndicatorTintColor        = [UIColor blackColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [_pageControl addTarget:self action:@selector(spacePageControl:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_pageControl];

    }
    return _pageControl;

}

- (void)setTimingSeconds:(CGFloat)timingSeconds{
    _timingSeconds                             = timingSeconds;
    [self addTimerWithSecond:timingSeconds];
}
- (void)setShowPageControl:(BOOL)showPageControl{
    _showPageControl                           = showPageControl;
    self.pageControl.hidden                    = !showPageControl;
}


- (void)dealloc
{
    [self removeTimer];
}

#ifdef ICAROUSEL_IOS

- (void)didMoveToSuperview

#else

- (void)viewDidMoveToSuperview

#endif

{
    #ifdef ICAROUSEL_IOS
    [super didMoveToSuperview];
    #else
    [super viewDidMoveToSuperview]
    #endif

    if (self.superview)
    {
        [self addTimerWithSecond:self.timingSeconds];
    }
    else
    {
        [self removeTimer];
    }
}
@end
