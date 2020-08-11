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

+(MBProgressHUD *)showRingInView:(UIView *)view Msg:(NSString *)msg animation:(BOOL)animation;


+(void)showMsgInView:(UIView *)view msg:(NSString *)msg;
+(void)showMsg:(NSString *)msg;
+(void)showMsg:(NSString *)msg andOffer:(CGFloat)offerset;

+(MBProgressHUD *)showInView:(UIView *)view animation:(BOOL)animation;
+(void)hideInView:(UIView *)view animation:(BOOL)animation;



+(void)setHudStyle:(MBProgressHUD *)hud;

@end



@interface SVIndefiniteAnimatedView : UIView

@property (nonatomic, assign) CGFloat strokeThickness;//线宽
@property (nonatomic, assign) CGFloat radius;//半径
@property (nonatomic, strong) UIColor *strokeColor;//颜色

@end
