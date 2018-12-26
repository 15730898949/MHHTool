//
//  NSString+Size.h
//  ShootMaster
//
//  Created by 浩GG on 2017/2/26.
//  Copyright © 2017年 Peng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Size)

@property (nonatomic , copy , readonly)NSString *Money;

//计算高宽
+ (CGSize)getContentSizeWithStr:(NSString *)str andFont:(UIFont *)font andSize:(CGSize)size;

//计算多少行
+ (NSInteger)getLineNum:(NSString*)str font:(UIFont*)font labelWidth:(CGFloat)width;


+(BOOL)isEmpty:(NSString*)text;



@end
