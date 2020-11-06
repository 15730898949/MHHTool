//
//  TBCityIconFont.m
//  iCoupon
//
//  Created by John Wong on 10/12/14.
//  Copyright (c) 2014 Taodiandian. All rights reserved.
//

#import "TBCityIconFont.h"
#import <CoreText/CoreText.h>

@implementation TBCityIconFont

static NSString *_fontName;

+ (void)registerFontWithURL:(NSURL *)url {
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:[url path]], @"Font file doesn't exist");
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)url);
    CGFontRef newFont = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CTFontManagerRegisterGraphicsFont(newFont, nil);
    CGFontRelease(newFont);
}

+ (UIFont *)fontWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:[self fontName] size:size];
    if (font == nil) {
        NSURL *fontFileUrl = [[NSBundle mainBundle] URLForResource:[self fontName] withExtension:@"ttf"];
        [self registerFontWithURL: fontFileUrl];
        font = [UIFont fontWithName:[self fontName] size:size];
        NSAssert(font, @"UIFont object should not be nil, check if the font file is added to the application bundle and you're using the correct font name.");
    }
    return font;
}

+ (void)setFontName:(NSString *)fontName {
    _fontName = fontName;
    ICF_image(@"\U0000e665", 20, [UIColor redColor]);

}


+ (NSString *)fontName {
    return _fontName ? : @"iconfont";
}

// e62c 转  \U0000e62c
+ (NSString * )stringFromHexString:(NSString *)hexString { //
    
    hexString=[hexString lowercaseString];//转换为小写
    int  length =(int) hexString.length;
    unsigned int sum = 0;
    for (int i=length-1; i>=0; i--) {
        
        char c = (char)[hexString characterAtIndex:i];
        if (c>='0'&&c<='9') {
            
            c = c-'0';
        }
        else if(c>='a'&&c<='f')
        {
            c=c-'a'+10;
        }
        sum+=c*(int)pow(16, length-1-i);
    }
    unichar ch = sum;
    return [NSString stringWithCharacters:&ch length:1];
}

@end
