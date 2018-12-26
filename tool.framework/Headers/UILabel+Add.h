//
//  UILabel+Add.h
//  WechatMaster
//
//  Created by Peng on 2017/12/15.
//  Copyright © 2017年 Peng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Add)

@property (nonatomic, assign) BOOL isCopyable;  //是否允许复制

//设置行间距
- (void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing;


@end
