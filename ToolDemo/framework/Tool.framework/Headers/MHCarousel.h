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

/**
 //初始化
 MHCarousel* carousel = [[MHCarousel alloc]initWithFrame:CGRectMake(0, 100, SCREEN_Width, 100)];
 carousel.pagingEnabled = YES;
 carousel.type = iCarouselTypeLinear;
 carousel.delegate = self;
 carousel.dataSource = self;
 carousel.timingSeconds = 3;
 [carousel reloadData];
 carousel.pageControl.frame = CGRectMake(0, CGRectGetHeight(carousel.bounds)-30, SCREEN_Width, 20);

 
 - (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
     return 3;
 }

 - (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
     if (view == nil) {
         view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_Width, 100)];
         view.layer.masksToBounds = YES;
         view.clipsToBounds = YES;
     }
     
     [view addSubview:({
         UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_Width-20, 100)];
         imgView.tag = 10001;
         imgView.backgroundColor = [UIColor redColor];
         imgView.contentMode =  UIViewContentModeScaleAspectFill;
         imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"timg-%ld",index+1]];
         imgView;
     })];
     
     [view addSubview:({
         UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(20, view.mh_bottom - 30, 200, 20)];
         lab.tag = 10002;
         lab.textColor = [UIColor whiteColor];
         lab.backgroundColor =UIColorFromRGB(0, 0, 0, 0.5);
         lab.text = [NSString stringWithFormat:@" 这是第%ld张图片 ",index+1];
         [lab sizeToFit];
         lab;
     })];
     
     return view;
 }

 ///循环播放  无限滚动
 - (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
     if (option == iCarouselOptionWrap) {
         return YES;
     }
     return value;
 }

 */


NS_ASSUME_NONNULL_BEGIN
@interface MHCarousel : iCarousel

/**
 *需要手动设置frame，numberOfPages
 */
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

