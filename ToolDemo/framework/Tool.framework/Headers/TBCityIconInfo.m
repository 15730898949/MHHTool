//
//  TBCityFontImageInfo.m
//  iCoupon
//
//  Created by John Wong on 10/12/14.
//  Copyright (c) 2014 Taodiandian. All rights reserved.
//

#import "TBCityIconInfo.h"
#import <objc/runtime.h>
#import <CoreText/CoreText.h>
#import "TBCityIconFont.h"

@implementation TBCityIconInfo

- (instancetype)initWithText:(NSString *)text size:(NSInteger)size color:(UIColor *)color {
    if (self = [super init]) {
        self.text = text;
        self.size = size;
        self.color = color;
    }
    return self;
}

+ (instancetype)iconInfoWithText:(NSString *)text size:(NSInteger)size color:(UIColor *)color {
    return [[TBCityIconInfo alloc] initWithText:text size:size color:color];
}

@end

/*
 *
 *
 UIImage分类
 *
 *
 */


@implementation UIImage (TBCityIconFont)

+ (UIImage *)iconWithInfo:(TBCityIconInfo *)info {
    
    UILabel *lab = [UILabel new];
    [lab setIconFontSize:info.size];
    lab.text = info.text;
    [lab sizeToFit];
    
    
    
    CGFloat size = info.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat realSize = size * scale;
    UIFont *font = [TBCityIconFont fontWithSize:realSize];
//    UIGraphicsBeginImageContext(CGSizeMake(realSize, realSize));
    UIGraphicsBeginImageContext(CGSizeMake(lab.frame.size.width * scale, (lab.frame.size.width * scale)*(lab.frame.size.height/lab.frame.size.width)));

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if ([info.text respondsToSelector:@selector(drawAtPoint:withAttributes:)]) {
        /**
         * 如果这里抛出异常，请打开断点列表，右击All Exceptions -> Edit Breakpoint -> All修改为Objective-C
         * See: http://stackoverflow.com/questions/1163981/how-to-add-a-breakpoint-to-objc-exception-throw/14767076#14767076
         */
        [info.text drawAtPoint:CGPointZero withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName: info.color}];
    } else {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGContextSetFillColorWithColor(context, info.color.CGColor);
        [info.text drawAtPoint:CGPointMake(0, 0) withFont:font];
#pragma clang pop
    }
    
    UIImage *image = [UIImage imageWithCGImage:UIGraphicsGetImageFromCurrentImageContext().CGImage scale:scale orientation:UIImageOrientationUp];
    UIGraphicsEndImageContext();
    
    return image;
}

@end


/*
 *
 *
    UIButton分类
 *
 *
 */

@implementation UIButton(IconFont)



-(NSString *)iconFontText{
    return    objc_getAssociatedObject(self, @selector(iconFontText));
    
}

- (void)setIconFontText:(NSString *)iconFontText{
    
//    if ([iconFontText hasPrefix:@"\""]) {
//
//    }
    
    objc_setAssociatedObject(self, @selector(iconFontText), iconFontText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setIconFontSize:self.titleLabel.font.pointSize];
    [self setTitle:[NSString stringWithFormat:@"%@%@",self.titleLabel.text?self.titleLabel.text:@"",[TBCityIconFont stringFromHexString:iconFontText]] forState:UIControlStateNormal];
    
}


- (CGFloat)iconFontSize{
    NSNumber *number = objc_getAssociatedObject(self, @selector(iconFontSize));
    return number.floatValue;
    
}

- (void)setIconFontSize:(CGFloat)iconFontSize{
    NSNumber *number = [NSNumber numberWithDouble:iconFontSize];
    objc_setAssociatedObject(self, @selector(iconFontSize), number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    self.titleLabel.font = [UIFont fontWithName:[TBCityIconFont fontName] size:iconFontSize];

}



@end




/*
 *
 *
 UILabel分类
 *
 *
 */

@implementation  UILabel(IconFont)



-(NSString *)iconFontText{
    return    objc_getAssociatedObject(self, @selector(iconFontText));
    
}

- (void)setIconFontText:(NSString *)iconFontText{
    
    objc_setAssociatedObject(self, @selector(iconFontText), iconFontText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setIconFontSize:self.font.pointSize];
    self.text =[NSString stringWithFormat:@"%@%@",self.text?self.text:@"",[TBCityIconFont stringFromHexString:iconFontText]];
}


- (CGFloat)iconFontSize{
    NSNumber *number = objc_getAssociatedObject(self, @selector(iconFontSize));
    return number.floatValue;

}

- (void)setIconFontSize:(CGFloat)iconFontSize{
    NSNumber *number = [NSNumber numberWithDouble:iconFontSize];
    objc_setAssociatedObject(self, @selector(iconFontSize), number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    self.font = [UIFont fontWithName:[TBCityIconFont fontName] size:iconFontSize];
}


@end

