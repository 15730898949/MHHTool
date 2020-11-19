//
//  MHCarousel.h
//  Tool
//
//  Created by Mac on 2020/11/19.
//  Copyright © 2020 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMPageControl.h"
#import "iCarousel.h"

NS_ASSUME_NONNULL_BEGIN
@interface MHCarousel : iCarousel

@property (nonatomic,strong) SMPageControl * _Nullable pageControl;

/**
 *  定时器（在viewDidDisappear记得要销毁)
 */
@property (nonatomic,weak) NSTimer *delayTimer;
/**
 *  定时秒数
 */
@property (nonatomic,assign) CGFloat timingSeconds;

/**
 *  是否显示pageControl
 */
@property (nonatomic,assign,getter=isShowPageContol) BOOL showPageControl;


@end
NS_ASSUME_NONNULL_END

