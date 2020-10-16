//
//  NSString+Category.h
//  Tool
//
//  Created by Mac on 2020/9/3.
//  Copyright © 2020 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString(Category)
///计算字符串长度
- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

///YYYY_MM_dd
- (NSString *)timestampToYYYY_MM_ddFromMu;

///YYYY-MM-dd hh:mm:ss
- (NSString *)timestampToDateFromMu;

///*时间戳转化为时间*/
- (NSString *)timestampToDateWithFormatFromMu:(NSString *)Format;

///时间转时间戳
- (NSString *)timestampFromDateWithFormatMu:(NSString *)Format;

///*获取当前时间戳,秒为单位*/
+ (NSString *)getNowTimeTimestampMu;

////**判断几分钟前*/
+ (NSString *)timeBeforeInfoWithTimestampMu:(NSString *)timestamp interval:(NSUInteger)seconds;

///**时间戳转星座*/
- (NSString *)timestampToConstellationMu;

///**根据时间戳算年龄*/
- (NSString *)timestampToAgeMu;
/**
 * @brief 将数字1234 格式化为1,234
 */
- (NSString *)decimalStringWithNumberMu;
///**正常号转银行卡号 － 增加4位间的空格*/
- (NSString *)normalNumberToBankNumberMu;

///**银行卡号转正常号 － 去除4位间的空格*/
- (NSString *)bankNumberToNormalNumberMu;

///**处理银行卡 格式为****1234保留最后4位*/
- (NSString *)securityBankCardMu;

////**中间的用*替代*/
- (NSString *)stringByReplacingIndex:(NSUInteger)index count:(NSUInteger)count withString:(NSString *)aString;

///*邮箱*/
- (BOOL)validateEmailMu;

///*车牌号验证*/
- (BOOL)validateCarNoMu;

///*车型*/
- (BOOL)validateCarTypeMu;

///*身份证号*/
- (BOOL)validateIdentityCardMu;

///*格式化HTML代码*/
+ (NSString *)htmlEntityDecode:(NSString *)string;

///*倒计时  @"Day",@"Hour",@"Minute",@"Seconds",@"Msec",如果dictionary为nil则表示倒计时结束*/
- (void)countdownWithTimeInterval:(NSString *)timeInterval callback:(void(^)(NSDictionary *dictionary))callback;

///*字典转字符串**/
+ (NSString*)dictionaryToJson:(NSDictionary *)dict;

///*字符串转字典**/
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

///文字首行缩进
- (NSAttributedString *)attributesWithLineSpacing:(CGFloat)firstLineHeadIndent;

///颜色
- (NSAttributedString *)attributesWithColor:(UIColor *)color string:(NSString *)string;

///字体
- (NSAttributedString *)attributesWithFont:(UIFont *)font string:(NSString *)string;

///下划线
- (NSAttributedString *)attributesWithUnderlineColor:(UIColor *)color string:(NSString *)string;

///中划线
- (NSAttributedString *)attributesWithStrikethroughlineColor:(UIColor *)color string:(NSString *)string;

- (NSString *)emoji;

///根据时间戳转时间
+(NSString *)getDateDisplayString:(NSString *) miliSeconds;

///根据时间戳
+(NSString *)getDateDisplayString:(NSString *)date dataFormat:(NSString *)dataFormat;

///NSObject转json
+ (NSString *)objectToJson:(NSObject *)object;
///截取字符串
- (NSString *)subStringFrom:(NSString *)startString to:(NSString *)endString;

///MD5 32位大小写 isUppercase YES大写 NO小写
+ (NSString *)MD5_32Bit:(NSString *)srcString isUppercase:(BOOL)isUppercase;

@end

NS_ASSUME_NONNULL_END
