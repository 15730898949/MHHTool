//
//  SortNameTool.h
//  YouYouBao
//
//  Created by Funny on 2017/6/16.
//  Copyright © 2017年 Funny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"


#define CharacatorNumberArray  @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"]


@interface NameModel : BaseModel

@property(copy,nonatomic)NSString *chineseCharacter;

@property(copy,nonatomic)NSString *initialString;

@property(copy,nonatomic)NSString *pinyin;

@end



@interface SortNameTool : NSObject

/**
 首字母数组
 */
@property(nonatomic)NSArray *initialArray;


/**
 调用此方法就可直接排序

 @param names 无序的名字数组
 */
- (NSArray *)getTableArrayWithNames:(NSArray *)names;

@end
