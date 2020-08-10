//
//  TBCityIconInfo.h
//  iCoupon
//
//  Created by John Wong on 10/12/14.
//  Copyright (c) 2014 Taodiandian. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TBCityIconInfo : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, strong) UIColor *color;

- (instancetype)initWithText:(NSString *)text size:(NSInteger)size color:(UIColor *)color;
+ (instancetype)iconInfoWithText:(NSString *)text size:(NSInteger)size color:(UIColor *)color;

@end


@interface UIButton(IconFont)
@property (nonatomic, strong) IBInspectable NSString  *iconFontText;
@property (nonatomic, assign) IBInspectable  CGFloat iconFontSize;

@end

@interface UIImage (TBCityIconFont)

+ (UIImage *)iconWithInfo:(TBCityIconInfo *)info;

@end


@interface UILabel(IconFont)
@property (nonatomic, strong) IBInspectable NSString  *iconFontText;
@property (nonatomic, assign) IBInspectable  CGFloat iconFontSize;


@end
