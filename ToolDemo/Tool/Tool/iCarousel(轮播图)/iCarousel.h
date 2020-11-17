//
//  iCarousel.h
//
//  Version 1.8.3
//
//  Created by Nick Lockwood on 01/04/2011.
//  Copyright 2011 Charcoal Design
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/nicklockwood/iCarousel

/**
 //设置page
 _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 70, 150, 20)];
 _pageControl.numberOfPages = 3;
 _pageControl.currentPage = 0;
 [carousel addSubview:_pageControl];

 
 - (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
     return 2;
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
 ///定时跳转下一页
  - (void)delayMethod{
      if (carousel.numberOfItems<= 0 && carousel) {
          return;
      }
      [carousel scrollToItemAtIndex:carousel.currentItemIndex == carousel.numberOfItems-1?0:carousel.currentItemIndex+1 duration:1];
  }

  ///滑动完成 定时滑动
  - (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
     //设置currentPage
      _pageControl.currentPage = carousel.currentItemIndex;
     //延时加载下一页
      [self performSelector:@selector(delayMethod) withObject:nil afterDelay:3];

  }

  ///开始触摸 取消自动翻页
  - (void)carouselWillBeginDragging:(iCarousel *)carousel{
      [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayMethod) object:nil];
      [NSObject cancelPreviousPerformRequestsWithTarget:self];
  }

 ///循环播放  无限滚动
 - (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
     if (option == iCarouselOptionWrap) {
         return YES;
     }
     return value;
 }

///点击item
 - (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
     NSLog(@"iCarousel点击%ld",index);
 }

 */


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wreserved-id-macro"
#pragma clang diagnostic ignored "-Wobjc-missing-property-synthesis"


#import <Availability.h>
#undef weak_delegate
#undef __weak_delegate
#if __has_feature(objc_arc) && __has_feature(objc_arc_weak) && \
(!(defined __MAC_OS_X_VERSION_MIN_REQUIRED) || \
__MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_8)
#define weak_delegate weak
#else
#define weak_delegate unsafe_unretained
#endif


#import <QuartzCore/QuartzCore.h>
#if defined USING_CHAMELEON || defined __IPHONE_OS_VERSION_MAX_ALLOWED
#define ICAROUSEL_IOS
#else
#define ICAROUSEL_MACOS
#endif


#ifdef ICAROUSEL_IOS
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
typedef NSView UIView;
#endif


typedef NS_ENUM(NSUInteger, iCarouselType)
{
    iCarouselTypeLinear = 0,           //线性类型
    iCarouselTypeRotary,               //可旋转类型
    iCarouselTypeInvertedRotary,       //反向旋转类型
    iCarouselTypeCylinder,             //圆柱类型
    iCarouselTypeInvertedCylinder,     //反向圆柱类型
    iCarouselTypeWheel,                //车轮类型
    iCarouselTypeInvertedWheel,        //反向车轮类型
    iCarouselTypeCoverFlow,            //封面流类型
    iCarouselTypeCoverFlow2,           //封面流类型2
    iCarouselTypeTimeMachine,          //时光机类型
    iCarouselTypeInvertedTimeMachine,  //反向时光机类型
    iCarouselTypeCustom                //可自定义Carousel类型
};


typedef NS_ENUM(NSInteger, iCarouselOption)
{
    iCarouselOptionWrap = 0,
    iCarouselOptionShowBackfaces,
    iCarouselOptionOffsetMultiplier,
    iCarouselOptionVisibleItems,
    iCarouselOptionCount,
    iCarouselOptionArc,
    iCarouselOptionAngle,
    iCarouselOptionRadius,
    iCarouselOptionTilt,
    iCarouselOptionSpacing,
    iCarouselOptionFadeMin,
    iCarouselOptionFadeMax,
    iCarouselOptionFadeRange,
    iCarouselOptionFadeMinAlpha
};


NS_ASSUME_NONNULL_BEGIN

@protocol iCarouselDataSource, iCarouselDelegate;

@interface iCarousel : UIView

@property (nonatomic, weak_delegate) IBOutlet __nullable id<iCarouselDataSource> dataSource;
@property (nonatomic, weak_delegate) IBOutlet __nullable id<iCarouselDelegate> delegate;
@property (nonatomic, assign) iCarouselType type;
@property (nonatomic, assign) CGFloat perspective;
@property (nonatomic, assign) CGFloat decelerationRate;
@property (nonatomic, assign) CGFloat scrollSpeed;//当用户用手指轻击carousel时，carousel的滚动速度，默认为1.0。


@property (nonatomic, assign) CGFloat bounceDistance;
@property (nonatomic, assign, getter = isScrollEnabled) BOOL scrollEnabled;
@property (nonatomic, assign, getter = isPagingEnabled) BOOL pagingEnabled;
@property (nonatomic, assign, getter = isVertical) BOOL vertical;
@property (nonatomic, readonly, getter = isWrapEnabled) BOOL wrapEnabled;
@property (nonatomic, assign) BOOL bounces;
@property (nonatomic, assign) CGFloat scrollOffset;
@property (nonatomic, readonly) CGFloat offsetMultiplier;
@property (nonatomic, assign) CGSize contentOffset;
@property (nonatomic, assign) CGSize viewpointOffset;
@property (nonatomic, readonly) NSInteger numberOfItems;
@property (nonatomic, readonly) NSInteger numberOfPlaceholders;
@property (nonatomic, assign) NSInteger currentItemIndex;
@property (nonatomic, strong, readonly) UIView * __nullable currentItemView;
@property (nonatomic, strong, readonly) NSArray *indexesForVisibleItems;
@property (nonatomic, readonly) NSInteger numberOfVisibleItems;
@property (nonatomic, strong, readonly) NSArray *visibleItemViews;
@property (nonatomic, readonly) CGFloat itemWidth;
@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, readonly) CGFloat toggle;
@property (nonatomic, assign) CGFloat autoscroll;
@property (nonatomic, assign) BOOL stopAtItemBoundary;
@property (nonatomic, assign) BOOL scrollToItemBoundary;
@property (nonatomic, assign) BOOL ignorePerpendicularSwipes;
@property (nonatomic, assign) BOOL centerItemWhenSelected;
@property (nonatomic, readonly, getter = isDragging) BOOL dragging;
@property (nonatomic, readonly, getter = isDecelerating) BOOL decelerating;
@property (nonatomic, readonly, getter = isScrolling) BOOL scrolling;

- (void)scrollByOffset:(CGFloat)offset duration:(NSTimeInterval)duration;
- (void)scrollToOffset:(CGFloat)offset duration:(NSTimeInterval)duration;
- (void)scrollByNumberOfItems:(NSInteger)itemCount duration:(NSTimeInterval)duration;
- (void)scrollToItemAtIndex:(NSInteger)index duration:(NSTimeInterval)duration;
- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated;

- (nullable UIView *)itemViewAtIndex:(NSInteger)index;
- (NSInteger)indexOfItemView:(UIView *)view;
- (NSInteger)indexOfItemViewOrSubview:(UIView *)view;
- (CGFloat)offsetForItemAtIndex:(NSInteger)index;
- (nullable UIView *)itemViewAtPoint:(CGPoint)point;

- (void)removeItemAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)insertItemAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)reloadItemAtIndex:(NSInteger)index animated:(BOOL)animated;

- (void)reloadData;

@end


@protocol iCarouselDataSource <NSObject>

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel;
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view;

@optional

- (NSInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel;
- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(nullable UIView *)view;

@end


@protocol iCarouselDelegate <NSObject>
@optional

- (void)carouselWillBeginScrollingAnimation:(iCarousel *)carousel;
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel;
- (void)carouselDidScroll:(iCarousel *)carousel;
- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel;
- (void)carouselWillBeginDragging:(iCarousel *)carousel;
- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate;
- (void)carouselWillBeginDecelerating:(iCarousel *)carousel;
- (void)carouselDidEndDecelerating:(iCarousel *)carousel;

- (BOOL)carousel:(iCarousel *)carousel shouldSelectItemAtIndex:(NSInteger)index;
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index;

- (CGFloat)carouselItemWidth:(iCarousel *)carousel;
- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform;
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value;

@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop

