//
//  ZZLimitInputManager.h
//  LimitInputManagerDemo
//
//  Created by 刘威振 on 6/6/16.
//  Copyright © 2016 LiuWeiZhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
    @"^\\-?([0-9]\\d{0,5})(\\.\\d{0,4})?$"
    仅输入数字, 小数点后保留四位, 在xib中设置键盘类型
 
     @"[^0].*"
     制不可输入首字符为0
 */

@interface ZZLimitInputManager : NSObject

/**
 *  限制输入长度为length
 *  @param view UITextFiel或UITextView对象
 *  @param length 可以输入的最大长度
 */
+ (void)limitInputView:(UIView<UITextInput> *)view maxLength:(NSUInteger)length;

/**
 *  限制输入符合正则表达式regx
 *  @param view UITextFiel或UITextView对象
 *  @param regx 正则表达式
 */
+ (void)limitInputView:(UIView<UITextInput> *)view regX:(NSString *)regx;

@end

