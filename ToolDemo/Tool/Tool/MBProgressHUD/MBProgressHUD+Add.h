//
//  ArcView.h
//  HUD
//
//  Created by yangsq on 2017/4/24.
//  Copyright © 2017年 yangsq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface MBProgressHUD(Add)

+(MBProgressHUD *)show;
+(void)hide;
//加载环形
+(MBProgressHUD *)showRingInView:(UIView *)view Msg:(NSString *)msg animation:(BOOL)animation;
///系统菊花样式
+(MBProgressHUD *)showActivView:(UIView *)view Msg:(NSString *)msg animation:(BOOL)animation;
+(MBProgressHUD *)showInView:(UIView *)view animation:(BOOL)animation;
+(void)hideInView:(UIView *)view animation:(BOOL)animation;

+(void)setHudStyle:(MBProgressHUD *)hud;

+(void)showMsg:(NSString *)msg;
+(void)showMsgInView:(UIView *)view msg:(NSString *)msg;
+(void)showMsg:(NSString *)msg andOffer:(CGFloat)offerset;
+(void)showMsg:(NSString *)msg andDelay:(float)delay;
+(void)showInView:(UIView *)view Msg:(NSString *)msg andOffer:(CGFloat)offerset andDelay:(float)delay;




@end



@interface SVIndefiniteAnimatedView : UIView

@property (nonatomic, assign) CGFloat strokeThickness;//线宽
@property (nonatomic, assign) CGFloat radius;//半径
@property (nonatomic, strong) UIColor *strokeColor;//颜色

@end