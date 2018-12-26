//  版本更新
//  GAVersionUpdatePublic.h
//  gjpt
//
//  Created by Gamin on 2016/12/5.
//  Copyright © 2016年 CQYGKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GAVersionUpdatePublic : NSObject 

// 通过网络同步请求获取App Store上对应APP ID的应用信息
+ (void)checkAppStoreVersionWithAppid:(NSString *)appid andIsShowNOUpdateAlertView:(BOOL)isShow;
@end
