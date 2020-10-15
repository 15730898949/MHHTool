//
//  CWCarousel.h
//  CWCarousel
//
//  Created by WangChen on 2018/4/3.
//  Copyright © 2018年 ChenWang. All rights reserved.
//

/**
    CWFlowLayout *layout = [[CWFlowLayout alloc]initWithStyle:CWCarouselStyle_H_1];
    CWCarousel *banner = [[CWCarousel alloc]initWithFrame:CGRectMake(0, 100, SCREEN_Width, 100) delegate:self datasource:self flowLayout:layout];
    banner.isAuto = YES;
    banner.autoTimInterval = 2;
    banner.endless = YES;
    [banner.carouselView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    banner.backgroundColor = [UIColor redColor];
    [banner freshCarousel];

 
 
     UICollectionViewCell *cell = [carousel.carouselView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
     UIImageView *imgView = [cell.contentView viewWithTag:10001];
     if(!imgView) {
         imgView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
         imgView.contentMode =  UIViewContentModeScaleAspectFill;
         imgView.tag = 10001;
         imgView.backgroundColor = [UIColor whiteColor];
         [cell.contentView addSubview:imgView];
         cell.layer.masksToBounds = YES;
     }

    imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"timg-%ld",index+1]];
     return cell;

 */

#import <UIKit/UIKit.h>
#import "CWFlowLayout.h"
@class CWCarousel;

@protocol CWCarouselDelegate<NSObject>
/**
 轮播图点击代理

 @param carousel 轮播图实例对象
 @param index 被点击的下标
 */
- (void)CWCarousel:(CWCarousel *)carousel didSelectedAtIndex:(NSInteger)index;

@optional

/**
将要开始滑动时,会触发该代理

 @param carousel 轮播图控件
 @param index 开始滑动时,处于中心点图片的下标
 @param indexPathRow 开始滑动时,处于中心点图片的在控件内部的实际下标
 */
- (void)CWCarousel:(CWCarousel *)carousel didStartScrollAtIndex:(NSInteger)index indexPathRow:(NSInteger)indexPathRow;


/**
 滑动结束后,会触发该代理

 @param carousel 轮播图控件
 @param index 结束滑动时,处于中心点图片的下标
 @param indexPathRow 结束滑动时,处于中心点图片在控件内部的实际下标
 */
- (void)CWCarousel:(CWCarousel *)carousel didEndScrollAtIndex:(NSInteger)index indexPathRow:(NSInteger)indexPathRow;
@end

@protocol CWCarouselDatasource<NSObject>
/**
 轮播图数量

 @return 轮播图展示个数
 */
- (NSInteger)numbersForCarousel;
/**
 自定义每个轮播图视图

 @param carousel 轮播图控件
 @param indexPath 轮播图cell实际下标
 @param index 业务逻辑需要的下标
 @return 自定义视图
 */
- (UICollectionViewCell *)viewForCarousel:(CWCarousel *)carousel indexPath:(NSIndexPath *)indexPath index:(NSInteger)index;
@end


@protocol CWCarouselPageControlProtocol<NSObject>
@required
/**
 总页数
 */
@property (nonatomic, assign) NSInteger         pageNumbers;
/**
 当前页
 */
@property (nonatomic, assign) NSInteger         currentPage;

- (void)setCurrentPage:(NSInteger)currentPage;
- (void)setPageNumbers:(NSInteger)pageNumbers;
@end



@interface CWCarousel : UIView
#pragma mark - < 相关属性 >

/**
 控件版本号
 */
@property (nonatomic, readonly, copy) NSString                  * _Nullable version;


/**
 相关代理
 */
@property (nonatomic, weak) id <CWCarouselDelegate> _Nullable delegate;


/**
 相关数据源
 */
@property (nonatomic, weak) id <CWCarouselDatasource> _Nullable datasource;


/**
 布局自定义layout
 */
@property (nonatomic, strong, readonly) CWFlowLayout    * _Nonnull flowLayout;


/**
 样式风格
 */
@property (nonatomic, assign, readonly) CWCarouselStyle   style;


/**
 style = CWCarouselStyle_H_3时的扩展高度 (1.1.0版本后该属性废弃,请不要使用了)
 */
@property (nonatomic, assign, readonly) CGFloat           addHeight;


/**
 实际的示轮播图内容的视图(其实就是基于collectionView实现的)
 */
@property (nonatomic, strong, readonly) UICollectionView  * _Nonnull carouselView;


/**
 是否自动轮播, 默认为NO
 */
@property (nonatomic, assign) BOOL                        isAuto;


/**
 自动轮播时间间隔, 默认 3s
 */
@property (nonatomic, assign) NSTimeInterval              autoTimInterval;


/**
 默认的pageControl
 1. 默认在水平居中正下方
 2. 位置可以自己根据frame自行调整
 3. 如果不想将其添加在carousel上,请自行通过调用目标父视图的addSubview方法添加到其他父视图上
 */
@property (nonatomic, strong) UIPageControl               * _Nullable pageControl;


/**
 自定义的pageControl
 */
@property (nonatomic, strong) UIView<CWCarouselPageControlProtocol> * _Nullable customPageControl;


/**
 是否开始无限轮播
 YES: 可以无限衔接
 NO: 滑动到第一张或者最后一张就不能滑动了
 */
@property (nonatomic, assign) BOOL                        endless;
#pragma mark - < 相关方法 >
/**
 创建实例构造方法

 @param frame 尺寸大小
 @param delegate 代理
 @param datasource 数据源
 @param flowLayout 自定义flowlayout
 @return 实例对象
 */
- (instancetype _Nullable )initWithFrame:(CGRect)frame
                        delegate:(id<CWCarouselDelegate> _Nullable)delegate
                        datasource:(id<CWCarouselDatasource> _Nullable)datasource
                       flowLayout:(nonnull CWFlowLayout *)flowLayout;

/**
 注册自定视图

 @param viewClass 自定义视图类名
 @param identifier 重用唯一标识符
 */
- (void)registerViewClass:(Class _Nullable )viewClass identifier:(NSString *_Nullable)identifier;

/**
 注册自定义视图

 @param nibName 自定义视图xib相关文件名
 @param identifier 重用唯一标识符
 */
- (void)registerNibView:(NSString *_Nullable)nibName identifier:(NSString *_Nullable)identifier;


/**
 刷新轮播图
 */
- (void)freshCarousel;

/**
 暂停轮播图后,可以调用改方法继续播放
 */
- (void)resumePlay;

/**
 轮播图暂停自动播放
 */
- (void)pause;

/**
 如果开启自动轮播,销毁前需要调用该方法,释放定时器.否则可能内存泄漏
 */
- (void)releaseTimer;

/**
 轮播图所处控制器WillAppear方法里调用
 */
- (void)controllerWillAppear;

/**
 轮播图所处控制器WillDisAppear方法里调用
 */
- (void)controllerWillDisAppear;
@end


