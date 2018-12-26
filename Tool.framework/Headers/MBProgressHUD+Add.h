//
//  MBProgressHUD+Add.h
//
//  Created by Peng on 2016/10/29.
//  Copyright © 2016年 Peng. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Add)

+(void)show;
+(void)hide;

+(void)showMsg:(NSString *)msg;
+(void)showMsg:(NSString *)msg andOffer:(CGFloat)offerset;

+(MBProgressHUD *)showInView:(UIView *)view animation:(BOOL)animation;
+(void)setHudStyle:(MBProgressHUD *)hud;

@end
