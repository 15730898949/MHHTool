//
//  UILabel+AddButton.h
//  CQLorry
//
//  Created by IOS on 2018/8/7.
//  Copyright © 2018年 Peng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel(Category)



//修改lab上部分字颜色和大小
- (void)setAttributedText:(NSArray<NSString *> *)change andMarkColor:(UIColor *)markColor andMarkFondSize:(float)fontSize  andlineSpace:(CGFloat)lineSpace;


-(void)addButtonWithTitle:(NSString *)titleStr andIsLeft:(BOOL)isLeft andSpacing:(float)spacing AndBtnBGColor:(UIColor *)BGColor;
-(void)addOtherText:(NSString *)TextStr;
@end
