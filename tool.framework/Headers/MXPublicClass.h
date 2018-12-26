//
//  MXPublicClass.h
//  CQLorry
//
//  Created by IOS on 2018/7/31.
//  Copyright © 2018年 Peng. All rights reserved.

////抗拉伸
//[self.phoneBtn setContentHuggingPriority:UILayoutPriorityRequired
//                                 forAxis:UILayoutConstraintAxisHorizontal];
////抗压缩
//[processLab setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
//如果你希望view.left大于等于button.left
//make.left.mas_greaterThanOrEqualTo(button);


//

#import <Foundation/Foundation.h>

@interface MXPublicClass : NSObject

typedef void (^PublicClassBlock)(id result);


+ (void)messageAction:(UILabel *)theLab changeString:(NSString *)change andAllColor:(UIColor *)allColor andMarkColor:(UIColor *)markColor andMarkFondSize:(float)fontSize;

/// 使用系统提示
+ (void)useAlertAddVC:(UIViewController *)viewController Message:(NSString *)message;

// 使用系统提示带回调
+ (void)useAlertAddVC:(UIViewController *)viewController Message:(NSString *)message block:(PublicClassBlock)block;



//行间距
+(NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace;

//拨打电话
+(void)CallPhone:(NSString *)phoneNumber andVC:(UIViewController *)viewController;


//  验证手机号
+ (BOOL)validateMobile:(NSString *)mobileNum;

//  验证身份证
+ (BOOL)validateIdCard:(NSString *)IdCard;

+ (BOOL)isBlankString:(NSString *)string;

+(NSString *)md5HexDigest:(NSString *)input;


//获取Window当前显示的ViewController
+ (UIViewController*)currentViewController;

@end
