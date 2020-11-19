//
//  TBCityIconFont.h
//  iCoupon
//
//  Created by John Wong on 10/12/14.
//  Copyright (c) 2014 Taodiandian. All rights reserved.
//

#import "TBCityIconInfo.h"

#define TBCityIconInfoMake(text, imageSize, imageColor) [TBCityIconInfo iconInfoWithText:text size:imageSize color:imageColor]

#define ICF_image(text, imageSize, imageColor) [UIImage iconWithInfo:TBCityIconInfoMake(text, imageSize, imageColor)]


//imageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e603", 30, [UIColor redColor])];
//[button setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e60c", 40, [UIColor redColor])] forState:UIControlStateNormal];
//label.font = [UIFont fontWithName:@"iconfont" size:15];//设置label的字体
//label.text = @"这是用label显示的iconfont  \U0000e60c";

@interface TBCityIconFont : NSObject

+ (UIFont *)fontWithSize: (CGFloat)size;
+ (void)setFontName:(NSString *)fontName;
+ (NSString *)fontName;

// e62c 转  \U0000e62c
+ (NSString * )stringFromHexString:(NSString *)hexString;

@end
