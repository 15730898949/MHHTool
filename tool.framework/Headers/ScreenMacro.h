//
//  ScreenMacro.h
//
//  Created by Peng on 2016/10/29.
//  Copyright ©  2016年 Peng. All rights reserved.
//

/*
 *  尺寸相关的宏定义
 */

#ifndef ScreenMacro_h
#define ScreenMacro_h

#define WINDOW [[UIApplication sharedApplication] keyWindow]

//[UIApplication sharedApplication].keyWindow.rootViewController.view.bounds

#define WinSize_Width  [[UIScreen mainScreen] bounds].size.width            //屏幕宽度
#define WinSize_Height [[UIScreen mainScreen] bounds].size.height           //屏幕高度

#define HwinScale      [[UIScreen mainScreen] bounds].size.width/375        //iphone6缩放宽度比例
#define VwinScale      [[UIScreen mainScreen] bounds].size.height/667       //iphone6缩放高度比例

#define Scale(s) HwinScale*s                                                //根据宽度比例缩放

#define NavgationBar_Height   (iPhoneX ? 88:64)

#define TabBar_Height         (iPhoneX ? 83:49)

#define Status_Height         [[UIApplication sharedApplication] statusBarFrame].size.height




#define ItemViewControllerFrame CGRectMake(0, 0, WinSize_Width, WinSize_Height-TabBar_Height)

#define iPhoneX  CGSizeEqualToSize([[UIScreen mainScreen] bounds].size, CGSizeMake(375, 812))

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)


#define WeakSelf(type)    __weak   typeof(type) weak##type = type;
#define StrongSelf(type)  __strong typeof(type) type = weak##type;

#define SE_RGBColor(r, g, b, alp) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:alp]

#define SeparatorColor   [UIColor colorWithHexString:@"#F1F1F1"]
#define BackgroundColor  [UIColor colorWithHexString:@"#F1F4F6"]
#define WorldColor1      [UIColor colorWithHexString:@"#141414"]


#define IsNOTNullOrEmptyOfNSString(string) !((![string isKindOfClass:[NSString class]])||[string isEqualToString:@""] || (string == nil) || [string isEqualToString:@"<null>"]|| [string isEqualToString:@"(null)"]|| [string isEqualToString:@"null"]|| [string isEqualToString:@"nil"] || [string isKindOfClass:[NSNull class]]||[[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)

#endif
