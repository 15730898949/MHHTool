//
//  UILabel+topString.h
//  Tool
//
//  Created by Mac on 2020/8/17.
//  Copyright © 2020 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel(topString)
/**
 @param string 需要点击的字符串
 @param attributes 需要点击字符串的富文本属性
 @param tap 文字被点击后的回调block
 */
- (void)addTapWithString:(NSString *)string attributes:(NSDictionary *)attributes tapBlock:(void (^)(void))tap;


/**
 @param array 需要点击的字符串数组
 @param attributes 需要点击字符串的富文本属性
 @param tap 文字被点击后的回调block
 */
- (void)addTapWithArray:(NSArray<__kindof NSString *> *)array attributes:(NSDictionary *)attributes tapBlock:(void (^)(NSString * string))tap;//文字点击方法


@end


