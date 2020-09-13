//
//  ToolMacro.h
//
//  Created by Peng on 2016/10/29.
//  Copyright ©  2016年 Peng. All rights reserved.
//

/*
 *  尺寸相关的宏定义
 *  颜色
 *  判断字符串是否空
 */

#ifndef ToolMacro_h
#define ToolMacro_h

#define WINDOW [[UIApplication sharedApplication] keyWindow]

//[UIApplication sharedApplication].keyWindow.rootViewController.view.bounds

#define SCREEN_Width  [[UIScreen mainScreen] bounds].size.width            //屏幕宽度
#define SCREEN_Height [[UIScreen mainScreen] bounds].size.height           //屏幕高度

#define HwinScale      [[UIScreen mainScreen] bounds].size.width/375        //iphone6缩放宽度比例
#define VwinScale      [[UIScreen mainScreen] bounds].size.height/667       //iphone6缩放高度比例

#define Scale(s) HwinScale*s                                                //根据宽度比例缩放

#define NavgationBar_Height   (iPhoneX ? 88:64)
#define TabBar_Height         (iPhoneX ? 83:49)
#define Status_Height         [[UIApplication sharedApplication] statusBarFrame].size.height
#define ExtraBottomHeight (iPhoneX ? 34 : 0)
#define ExtraTopHeight (iPhoneX ? 24 : 0)



#define ItemViewControllerFrame CGRectMake(0, 0, WinSize_Width, WinSize_Height-TabBar_Height)

#define iPhoneX  CGSizeEqualToSize([[UIScreen mainScreen] bounds].size, CGSizeMake(375, 812)) || (RCDScreenWidth>=375.0f && RCDScreenHeight>=812.0f)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)


#define WeakSelf(type)    __weak   typeof(type) weak##type = type;
#define StrongSelf(type)  __strong typeof(type) type = weak##type;

#define UIColorFromHex(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define UIColorFromRGB(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

//YES =  空字符串 ；； NO = 不是空
#define isNullString(string) ((![string isKindOfClass:[NSString class]])||[string isEqualToString:@""] || (string == nil) || [string isEqualToString:@"<null>"]|| [string isEqualToString:@"(null)"]|| [string isEqualToString:@"null"]|| [string isEqualToString:@"nil"] || [string isKindOfClass:[NSNull class]]||[[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)


///当前控制器
#define MHCurrentViewController \
^(){\
{\
UIViewController* currentViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;\
BOOL runLoopFind = YES;\
while (runLoopFind) {\
    if (currentViewController.presentedViewController) {\
        currentViewController = currentViewController.presentedViewController;\
    } else if ([currentViewController isKindOfClass:[UINavigationController class]]) {\
        UINavigationController* navigationController = (UINavigationController* )currentViewController;\
        currentViewController = [navigationController.childViewControllers lastObject];\
    } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {\
        UITabBarController* tabBarController = (UITabBarController* )currentViewController;\
        currentViewController = tabBarController.selectedViewController;\
    } else {\
        NSUInteger childViewControllerCount = currentViewController.childViewControllers.count;\
        if (childViewControllerCount > 0) {\
            currentViewController = currentViewController.childViewControllers.lastObject; \
            return currentViewController;\
        } else {\
            return currentViewController;\
        }\
    }\
}\
return currentViewController;\
}\
}()


#endif
