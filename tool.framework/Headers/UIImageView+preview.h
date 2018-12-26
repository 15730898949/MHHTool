//
//  UIImageView+preview.h
//  CQLorry
//
//  Created by IOS on 2018/9/19.
//  Copyright © 2018年 Peng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView(preview)
@property (nonatomic, assign) BOOL isPreview;  //是否点击显示预览

@property(nonatomic, strong)NSArray *urlArray;
@property(nonatomic, strong)NSArray *imageArray;
@property (nonatomic, assign) NSInteger selectIndex;



@end
