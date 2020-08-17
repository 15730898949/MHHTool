//
//  RKNotificationHub.h
//  RKNotificationHub
//
//  Created by Richard Kim on 9/30/14.
//  Copyright (c) 2014 Richard Kim. All rights reserved.
//

/*
 
 Copyright (c) 2014 Choong-Won Richard Kim <cwrichardkim@gmail.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished
 to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  The default diameter of the notification hub view.
 *
 *
    MH_RKNotificationHub* hub = [[MH_RKNotificationHub alloc]initWithView:yourView]; // sets the count to 0
    [hub increment];//加1
    [hud showCount];
 */
FOUNDATION_EXPORT CGFloat const RKNotificationHubDefaultDiameter;

@interface RKNotificationHub : NSObject

///创建一个气泡
- (id)initWithView:(UIView *)view;
- (id)initWithBarButtonItem:(UIBarButtonItem *)barButtonItem;

/// 气泡初始条数
- (void)setView:(UIView *)view andCount:(int)startCount;
/// 设置气泡的尺寸
- (void)setCircleAtFrame:(CGRect)frame;
///  设置气泡颜色,和通知个数的颜色
- (void)setCircleColor:(UIColor*)circleColor labelColor:(UIColor*)labelColor;
///  设置边框颜色,和边框width
- (void)setCircleBorderColor:(UIColor *)color borderWidth:(CGFloat)width;
/// 移动气泡的指定位置
- (void)moveCircleByX:(CGFloat)x Y:(CGFloat)y;
/// 设置缩放比例,中心点不变
- (void)scaleCircleSizeBy:(CGFloat)scale;
@property (nonatomic, strong) UIFont *countLabelFont;

//%%% changing the count
/// 增加一条
- (void)increment;
/// 增加N条
- (void)incrementBy:(int)amount;
/// 删除一条
- (void)decrement;
/// 删除N条
- (void)decrementBy:(int)amount;
/// 当前条数
@property (nonatomic, assign) int count;
/// 最大条数
@property (nonatomic, assign) int maxCount;

//%%% hiding / showing the count
///隐藏数字
- (void)hideCount;
///显示数字
- (void)showCount;

//%%% animations
- (void)pop;  // 弹出
- (void)blink; // 眨眼
- (void)bump; // 跳动

@property (nonatomic)UIView *hubView;

@end
