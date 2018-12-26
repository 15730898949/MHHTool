//
//  UIButton+Underline.h
//  CQLorry
//
//  Created by IOS on 2018/8/7.
//  Copyright © 2018年 Peng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIButton(Underline)


@property (nonatomic, assign) BOOL isRedDot;  //是否有红点



-(void)addUnderline:(UIColor *)color;
- (void)hiddenUnderline;
@end
