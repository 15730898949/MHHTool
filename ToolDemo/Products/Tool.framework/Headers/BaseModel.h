//
//  GOModel.h
//  MJExtensionExample
//
//  Created by nia_wei on 14-12-18.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

@property(nonatomic , strong ,readonly)NSDictionary *AllKey;

/**
 *  根据path路径加载模型
 */
+ (id)loadFromFile:(NSString *)path;

/**
 *  存放模型到path路径
 */
- (BOOL)saveToFile:(NSString *)path;

/**
 *  根据data数据加载模型
 */
+ (id)loadFromData:(NSData *)data;

/**
 *  将model转为data
 */
- (NSData*)dataFromModel;


@end
