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

#define iPhoneX  CGSizeEqualToSize([[UIScreen mainScreen] bounds].size, CGSizeMake(375, 812)) || (SCREEN_Width>=375.0f && SCREEN_Height>=812.0f)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)


#define WeakSelf(type)    __weak   typeof(type) weak##type = type;
#define StrongSelf(type)  __strong typeof(type) type = weak##type;


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

#pragma mark -- 字体
//粗体
#define  FONT_PingFangSC_Bold(fontSize) [UIFont fontWithName:@"PingFangSC-Semibold" size:fontSize]
//字体
//系统字体
#define  FONT(fontSize) [UIFont systemFontOfSize:fontSize]
//数字体
#define  FONT_NUMBER(fontSize) [UIFont fontWithName:@"HelveticaNeue-Thin" size:fontSize]
//平方字体
//瘦字体
#define  FONT_PingFangSC_Thin(fontSize) [UIFont fontWithName:@"PingFangSC-Thin" size:fontSize]
#define  FONT_PingFangSC_Heavy(fontSize) [UIFont fontWithName:@"PingFangSC-Heavy" size:fontSize]
//

#define  FONT_PingFangSC_Ultralight(fontSize) [UIFont fontWithName:@"PingFangSC-Ultralight" size:fontSize]

#define  FONT_PingFangSC_Regular(fontSize) [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize]
#define  FONT_PingFangSC_Semibold(fontSize) [UIFont fontWithName:@"PingFangSC-Semibold" size:fontSize]
//通用
#define  FONT_PingFangSC_ExtraLight(fontSize) [UIFont fontWithName:@"PingFangSC-ExtraLight" size:fontSize]
//平方medium
#define  FONT_PingFangSC_Medium(fontSize) [UIFont fontWithName:@"PingFangSC-Medium" size:fontSize]
#define  FONT_PingFangSC_Light(fontSize) [UIFont fontWithName:@"PingFangSC-Light" size:fontSize]


#pragma mark --- 颜色
//RGB色值
#define RGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
//自定义颜色
#define Color(r, g, b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

#define     DEFAULT_CHATBOX_COLOR            Color(244.0, 244.0, 246.0, 1.0)

#define     DEFAULT_LINE_GRAY_COLOR          Color(188.0, 188.0, 188.0, 0.6f)


//16进制的颜色
#define UIColorFromHEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


//16进制带透明度的颜色
#define UIColorForHEXAlpha(rgbValue,alphar) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphar]

#define UIColorFromHex(rgbValue,a) [UIColor colorWithRed:((float)(([rgbValue longValue] & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define UIColorFromRGB(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

//随机色
#define RandomColor Color(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256),1)

#define UIColorFromHex(HEXColor) \
{\
NSString *cString = [[HEXColor stringByTrimmingCharactersInSet:[NSCharacterSet\ whitespaceAndNewlineCharacterSet]] uppercaseString];\
if ([cString length] < 6) return [UIColor clearColor];\
if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];\
if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];\
if ([cString length] != 6) return [UIColor clearColor];\
NSRange range;\
range.location = 0;\
range.length = 2;\
NSString *rString = [cString substringWithRange:range];\
range.location = 2;\
NSString *gString = [cString substringWithRange:range];\
range.location = 4;\
NSString *bString = [cString substringWithRange:range];\
unsigned int r, g, b;\
[[NSScanner scannerWithString:rString] scanHexInt:&r];\
[[NSScanner scannerWithString:gString] scanHexInt:&g];\
[[NSScanner scannerWithString:bString] scanHexInt:&b];\
return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];\
}




//image
#define IMAGE(name) [UIImage imageNamed:name]
//线程
#define dispatch_async_main_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}
//随机生成6个数字
#define RandomTenNum  [NSString stringWithFormat:@"%010d", arc4random() % 1000000000]
//系统版本号
#define UIDeviceSystem  [[[UIDevice currentDevice] systemVersion] floatValue]

//Debug 输出，relese打包无输出
#ifdef DEBUG
#define NSLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )//分别是方法地址，文件名，在文件的第几行，自定义输出内容
#else

#define NSLog( s, ... )
#endif



#endif
