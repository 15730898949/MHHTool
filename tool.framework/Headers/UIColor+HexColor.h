//
//  UIColor+HexColor.h
//
//  Created by Peng on 2016/10/29.
//  Copyright © 2016年 Peng. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIColor (HexColor)

+ (UIColor *)colorWithHexString:(NSString *)color;

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;


@end
