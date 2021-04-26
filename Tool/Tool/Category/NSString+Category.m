//
//  NSString+Category.m
//  Tool
//
//  Created by Mac on 2020/9/3.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "NSString+Category.h"
#import <CommonCrypto/CommonDigest.h>
#pragma mark -NSString常用

@implementation NSString(Category)

- (CGSize)mh_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    CGSize resultSize;
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:@selector(boundingRectWithSize:options:attributes:context:)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:@selector(boundingRectWithSize:options:attributes:context:)];
        NSDictionary *attributes = @{ NSFontAttributeName:font };
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
        NSStringDrawingContext *context;
        [invocation setArgument:&size atIndex:2];
        [invocation setArgument:&options atIndex:3];
        [invocation setArgument:&attributes atIndex:4];
        [invocation setArgument:&context atIndex:5];
        [invocation invoke];
        CGRect rect;
        [invocation getReturnValue:&rect];
        resultSize = rect.size;
    } else {
        NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:@selector(sizeWithFont:constrainedToSize:)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:@selector(sizeWithFont:constrainedToSize:)];
        [invocation setArgument:&font atIndex:2];
        [invocation setArgument:&size atIndex:3];
        [invocation invoke];
        [invocation getReturnValue:&resultSize];
    }
    return resultSize;
}


//时间戳转YYYY-MM-dd格式
-(NSString *)timestampToYYYY_MM_ddFromMu{
    
    if (![self allNumberCharacters]) {
        return self;
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self integerValue]] ;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormat stringFromDate:date];
    return dateString;
}

//时间戳转YYYY-MM-dd hh:mm:ss格式
-(NSString *)timestampToDateFromMu{
    if (![self allNumberCharacters]) {
        return self;
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self integerValue]] ;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];//设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSString *dateString = [dateFormat stringFromDate:date];
    return dateString;
}
//时间戳转你想要的格式
-(NSString *)timestampToDateWithFormatFromMu:(NSString *)Format{
    if (![self allNumberCharacters]) {
        return self;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:Format]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[self doubleValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

//时间转时间戳
-(NSString *)timestampFromDateWithFormatMu:(NSString *)Format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //指定时间显示样式: HH表示24小时制 hh表示12小时制
    [formatter setDateFormat:Format];
    NSDate *lastDate = [formatter dateFromString:self];
    //以 1970/01/01 GMT为基准，得到lastDate的时间戳
    long firstStamp = [lastDate timeIntervalSince1970];
    return [NSString stringWithFormat:@"%ld",firstStamp];
}
//获取当前时间戳
+(NSString *)getNowTimeTimestampMu{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    
    ;
    return timeString;
}

/**分别根据时间戳与标准时间计算: 几分钟之前，几小时之前...*/
-(NSString *)timeBeforeInfoWithTimestampMu:(NSString *)timestamp{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //获取此时时间戳长度
    NSTimeInterval timeIntrval     = [timestamp doubleValue];
    NSTimeInterval nowTimeinterval = [[NSDate date] timeIntervalSince1970];
    int timeInt = nowTimeinterval - timeIntrval; //时间差
    int year = timeInt / (3600 * 24 * 30 *12);
    int month = timeInt / (3600 * 24 * 30);
    int day = timeInt / (3600 * 24);
    int hour = timeInt / 3600;
    int minute = timeInt / 60;
    //    int second = timeInt;
    if (year > 0) {
        return [NSString stringWithFormat:@"%d年以前",year];
    }else if(month > 0){
        return [NSString stringWithFormat:@"%d个月以前",month];
    }else if(day > 0){
        return [NSString stringWithFormat:@"%d天以前",day];
    }else if(hour > 0){
        return [NSString stringWithFormat:@"%d小时以前",hour];
    }else if(minute > 0){
        return [NSString stringWithFormat:@"%d分钟以前",minute];
    }else{
        return [NSString stringWithFormat:@"刚刚"];
    }
    
}
/**时间戳转星座摩羯座 12月22日------1月19日
 水瓶座 1月20日-------2月18日
 双鱼座 2月19日-------3月20日
 白羊座 3月21日-------4月19日
 金牛座 4月20日-------5月20日
 双子座 5月21日-------6月21日
 巨蟹座 6月22日-------7月22日
 狮子座 7月23日-------8月22日
 处女座 8月23日-------9月22日
 天秤座 9月23日------10月23日
 天蝎座 10月24日-----11月21日
 射手座 11月22日-----12月21日
 */
-(NSString *)timestampToConstellationMu{
    //计算月份
    NSString *date = [self timestampToYYYY_MM_ddFromMu];
    NSString *retStr=@"";
    NSString *birthStr = [date substringFromIndex:5];
    int month=0;
    NSString *theMonth = [birthStr substringToIndex:2];
    if([[theMonth substringToIndex:0] isEqualToString:@"0"]){
        month = [[theMonth substringFromIndex:1] intValue];
    }else{
        month = [theMonth intValue];
    }
    //计算天数
    int day=0;
    NSString *theDay = [birthStr substringFromIndex:3];
    if([[theDay substringToIndex:0] isEqualToString:@"0"]){
        day = [[theDay substringFromIndex:1] intValue];
    }else {
        day = [theDay intValue];
    }
    
    if (month<1 || month>12 || day<1 || day>31){
        return @"错误日期格式!";
    }
    if(month==2 && day>29) {
        return @"错误日期格式!!";
    }else if(month==4 || month==6 || month==9 || month==11) {
        if (day>30) {
            return @"错误日期格式!!!";
        }
    }
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    retStr=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(month*2-(day < [[astroFormat substringWithRange:NSMakeRange((month-1), 1)] intValue] - (-19))*2,2)]];
    return [NSString stringWithFormat:@"%@座",retStr];
}
/**根据时间戳算年龄*/
-(NSString *)timestampToAgeMu{
    NSString *dateString = [self timestampFromDateWithFormatMu:@"yyyy/MM/dd"];
    NSString *year = [dateString substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [dateString substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [dateString substringWithRange:NSMakeRange(dateString.length-2, 2)];
    //    NSLog(@"出生于%@年%@月%@日", year, month, day);
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierISO8601];
    NSDateComponents *compomemts = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:nowDate];
    NSInteger nowYear = compomemts.year;
    NSInteger nowMonth = compomemts.month;
    NSInteger nowDay = compomemts.day;
    //    NSLog(@"今天是%ld年%ld月%ld日", nowYear, nowMonth, nowDay);
    
    // 计算年龄
    NSInteger userAge = nowYear - year.intValue - 1;
    if ((nowMonth > month.intValue) || (nowMonth == month.intValue && nowDay >= day.intValue)) {
        userAge++;
    }
    return [NSString stringWithFormat:@"%ld",(long)userAge];
    
}
/**
 * @brief 将数字1234 格式化为1,234
 */
-(NSString *)decimalStringWithNumberMu{
    
    if (![self allNumberCharacters]) {
        return self;
    }
    NSNumber *number  = [NSNumber numberWithDouble:[self doubleValue]];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSString *string = [formatter stringFromNumber:number];
    //    if(suffix != nil){
    //        string = [string stringByAppendingString:suffix];
    //    }
    return string;
}
+ (NSString *)decimalStringWithNumber:(NSNumber *)number andSuffix:(NSString *)suffix {
    if(number == nil){
        return @"0";
    }
    if([number isKindOfClass:[NSString class]]){
        number = [NSNumber numberWithDouble:[(NSString *)number doubleValue]];
    }
    if (![number isKindOfClass:[NSNumber class]]) {
        
        return @"0";
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSString *string = [formatter stringFromNumber:number];
    if(suffix != nil){
        string = [string stringByAppendingString:suffix];
    }
    return string;
}
/**正常号转银行卡号 － 增加4位间的空格*/
-(NSString *)normalNumberToBankNumberMu{
    NSString *tmpStr = self;
    NSInteger size = (tmpStr.length / 4);
    NSMutableArray *tmpStrArr = [[NSMutableArray alloc] init];
    for (int n = 0;n < size; n++)
    {
        [tmpStrArr addObject:[tmpStr substringWithRange:NSMakeRange(n*4, 4)]];
    }
    
    [tmpStrArr addObject:[tmpStr substringWithRange:NSMakeRange(size*4, (tmpStr.length % 4))]];
    
    tmpStr = [tmpStrArr componentsJoinedByString:@" "];
    
    return tmpStr;
}
//将 &lt 等类似的字符转化为HTML中的“<”等
+ (NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
    
    return string;
}
/**银行卡号转正常号 － 去除4位间的空格*/
-(NSString *)bankNumberToNormalNumberMu{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}
/**中间的用*替代*/
-(NSString *)stringByReplacingIndex:(NSUInteger)index count:(NSUInteger)count withString:(NSString *)aString{
    
    if ((index+count) > self.length) {
        return self;
    }
    NSString *subStr1 = [self substringToIndex:index];
    NSString *subStr2 = [self substringFromIndex:index+count];
    NSString *replaceStr = @"";
    if (!aString) {
        aString = @"*";
    }
    for (NSUInteger num = 0; num < count; num++) {
        replaceStr = [NSString stringWithFormat:@"%@%@",replaceStr,aString];
    }
    return [NSString stringWithFormat:@"%@%@%@",subStr1,replaceStr,subStr2];
}
//判断字符串是否为纯数字
- (BOOL)allNumberCharacters{
    NSString *str = [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    
    if(str.length > 0)
    {
        return NO;
    }
    return YES;
}
/**处理银行卡 格式为****1234保留最后4位*/
- (NSString *)securityBankCardMu{
    NSString *IDCard =  self;
    if(IDCard.length > 10){
        return [NSString stringWithFormat:@"%@********%@",[IDCard substringToIndex:6], [IDCard substringFromIndex:IDCard.length-4]];
    }else if(IDCard.length > 4){
        return [NSString stringWithFormat:@"********%@", [IDCard substringFromIndex:IDCard.length-4]];
    }
    return IDCard;
}
/*邮箱*/
-(BOOL)validateEmailMu{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}
/*车牌号验证*/
-(BOOL)validateCarNoMu{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:self];
}
/*车型*/
-(BOOL)validateCarTypeMu{
    NSString *CarTypeRegex = @"^[\u4E00-\u9FFF]+$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CarTypeRegex];
    return [carTest evaluateWithObject:self];
}
/*身份证号*/
- (BOOL)validateIdentityCardMu{
    if (self.length != 18) return NO;
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:self];
}
//字典转字符串
+(NSString *)dictionaryToJson:(NSDictionary *)dict{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
}
//文字首行缩进
-(NSMutableAttributedString *)attributesWithLineSpacing:(CGFloat)firstLineHeadIndent{
    //分段样式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //头部缩进
    paragraphStyle.headIndent = firstLineHeadIndent;
    //首行缩进
    paragraphStyle.firstLineHeadIndent = firstLineHeadIndent;
    //尾部缩进
    paragraphStyle.tailIndent = -firstLineHeadIndent;
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:self attributes:@{ NSParagraphStyleAttributeName : paragraphStyle}];
    NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithAttributedString:attrText];
    return mString;
}
static dispatch_source_t timer;
/*倒计时*/
-(void)countdownWithTimeInterval:(NSString *)timeInterval callback:(void (^)(NSDictionary *))callback{
    
    if (timer) {
        dispatch_source_cancel(timer);
    }
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] ;
    double currentTime = [timeInterval doubleValue] - interval;
    __block float timeout= currentTime; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),0.1*NSEC_PER_SEC, 0); // 每100毫秒执行
    timer = _timer;
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                // 倒计时结束，关闭处理
                if(callback){
                    callback(nil);
                }
            });
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] ;
                double currentTime = [timeInterval doubleValue] - interval;
                
                int currentDay   = currentTime / (3600 *24);
                int currentHour  = (currentTime - currentDay*3600*24) / 3600;
                int currentMinute = (currentTime -currentDay*3600*24 -currentHour*3600) / 60;
                int currentSeconds = currentTime -currentDay*3600*24- currentHour*3600 -currentMinute*60;
                int currentMsec = (currentTime - currentDay*3600*24-currentHour*3600 - currentMinute*60 - currentSeconds)*1000;
                int msec = (currentMsec/100) % 1000;
                NSDictionary *dict = @{@"Day":[NSString stringWithFormat:@"%d",currentDay],@"Hour":[NSString stringWithFormat:@"%d",currentHour],@"Minute":[NSString stringWithFormat:@"%d",currentMinute],@"Seconds":[NSString stringWithFormat:@"%d",currentSeconds],@"Msec":[NSString stringWithFormat:@"%d",msec]};
                
                if(callback){
                    callback(dict);
                }
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
-(NSAttributedString *)attributesWithColor:(UIColor *)color string:(NSString *)string{
    
    NSRange range = [self rangeOfString:string];
    if (range.location != NSNotFound) {
        
        NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithString:self];
        [mString addAttributes:@{NSForegroundColorAttributeName:color} range:range];
        
        return mString;
    }
    return nil;
}

-(NSAttributedString *)attributesWithFont:(UIFont *)font string:(NSString *)string{
    NSRange range = [self rangeOfString:string];
    if (range.location != NSNotFound) {
        
        NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithString:self];
        [mString addAttributes:@{NSFontAttributeName:font} range:range];
        
        return mString;
    }
    return nil;
}
-(NSAttributedString *)attributesWithUnderlineColor:(UIColor *)color string:(NSString *)string{
    NSRange range = [self rangeOfString:string];
    if (range.location != NSNotFound) {
        
        NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithString:self];
        [mString addAttributes:@{NSUnderlineColorAttributeName:color,NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:range];
        
        return mString;
    }
    return nil;
}

-(NSAttributedString *)attributesWithStrikethroughlineColor:(UIColor *)color string:(NSString *)string{
    
    NSRange range = [self rangeOfString:string];
    if (range.location != NSNotFound) {
        NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithString:self];
        [mString addAttributes:@{NSUnderlineColorAttributeName:color,NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)} range:range];
        
        return mString;
        
    }
    return nil;
}
+ (NSString *)timeBeforeInfoWithTimestampMu:(NSString *)timestamp interval:(NSUInteger)seconds{
    NSTimeInterval timeIntrval     = [timestamp integerValue];
    NSTimeInterval nowTimeinterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval timeInt = nowTimeinterval - timeIntrval; //时间差
    //   NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:timeDate];
    int minute = timeInt / 60;
    if(minute > seconds){
        return [NSString stringWithFormat:@"%d",minute];
    }
    return @"0";
}

#define EmojiCodeToSymbol(c) ((((0x808080F0 | (c & 0x3F000) >> 4) | (c & 0xFC0) << 10) | (c & 0x1C0000) << 18) | (c & 0x3F) << 24)
- (NSString *)emoji
{
    return [NSString emojiWithStringCode:self];
}

+ (NSString *)emojiWithStringCode:(NSString *)stringCode
{
    char *charCode = (char *)stringCode.UTF8String;
    long intCode = strtol(charCode, NULL, 16);
    return [self emojiWithIntCode:(int)intCode];
}

+ (NSString *)emojiWithIntCode:(int)intCode {
    int symbol = EmojiCodeToSymbol(intCode);
    NSString *string = [[NSString alloc] initWithBytes:&symbol length:sizeof(symbol) encoding:NSUTF8StringEncoding];
    if (string == nil) { // 新版Emoji
        string = [NSString stringWithFormat:@"%C", (unichar)intCode];
    }
    return string;
}

//根据时间戳
+(NSString *)getDateDisplayString:(NSString *) miliSeconds{
    return [NSString convertDataWithTimeInterval:[miliSeconds integerValue]];
}

+ (NSString *)convertDataWithTimeInterval:(NSTimeInterval)timeInterval{
    NSTimeInterval tempMilli = timeInterval;
    NSTimeInterval seconds = tempMilli;
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    NSCalendar *calendar = [ NSCalendar currentCalendar ];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear ;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[ NSDate date ]];
    NSDateComponents *myCmps = [calendar components:unit fromDate:myDate];
    
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc ] init ];
    
    //2. 指定日历对象,要去取日期对象的那些部分.
    NSDateComponents *comp =  [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:myDate];
    
    if (nowCmps.year != myCmps.year) {
        dateFmt.dateFormat = @"yyyy-MM-dd HH:mm";
    } else {
        if (nowCmps.day==myCmps.day) {
            dateFmt.AMSymbol = @"上午";
            dateFmt.PMSymbol = @"下午";
            dateFmt.dateFormat = @"HH:mm";
            
        } else if((nowCmps.day-myCmps.day)==1) {
            dateFmt.AMSymbol = @"上午";
            dateFmt.PMSymbol = @"下午";
            dateFmt.dateFormat = @"昨天 HH:mm";
            
        } else if ((nowCmps.day-myCmps.day)==2){
            dateFmt.AMSymbol = @"上午";
            dateFmt.PMSymbol = @"下午";
            dateFmt.dateFormat = @"前天 HH:mm";
        }else {
            if ((nowCmps.day-myCmps.day) <=7) {
                
                dateFmt.AMSymbol = @"上午";
                dateFmt.PMSymbol = @"下午";
                
                switch (comp.weekday) {
                    case 1:
                        dateFmt.dateFormat = @"周日 HH:mm";
                        break;
                    case 2:
                        dateFmt.dateFormat = @"周一 HH:mm";
                        break;
                    case 3:
                        dateFmt.dateFormat = @"周二 HH:mm";
                        break;
                    case 4:
                        dateFmt.dateFormat = @"周三 HH:mm";
                        break;
                    case 5:
                        dateFmt.dateFormat = @"周四 HH:mm";
                        break;
                    case 6:
                        dateFmt.dateFormat = @"周五 HH:mm";
                        break;
                    case 7:
                        dateFmt.dateFormat = @"周六 HH:mm";
                        break;
                    default:
                        break;
                }
            }else {
                dateFmt.dateFormat = @"yyyy-MM-dd HH:mm";
            }
        }
    }
    return [dateFmt stringFromDate:myDate];
}
//根据时间戳
+(NSString *)getDateDisplayString:(NSString *)date dataFormat:(NSString *)dataFormat{
    
    
    NSTimeInterval miliSeconds = [[date timestampFromDateWithFormatMu:dataFormat] integerValue];
    
    return  [NSString convertDataWithTimeInterval:miliSeconds];
}
+ (NSString *)objectToJson:(NSObject *)object{
    NSData *data = [NSJSONSerialization dataWithJSONObject:object
                                                   options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments | NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    if (data == nil) {
        return nil;
    }
    
    NSString *string = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    return string;
}

//截取字符串
- (NSString *)subStringFrom:(NSString *)startString to:(NSString *)endString{
    NSRange startRange = [self rangeOfString:startString];
    NSRange endRange = [self rangeOfString:endString];
    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    return [self substringWithRange:range];
}

///MD5 32位大小写
+ (NSString *)MD5_32Bit:(NSString *)srcString isUppercase:(BOOL)isUppercase{
    // 参数 srcString 传进来的字符串
    // 参数 isUppercase 是否需要大小写
    const char *cStr = [srcString UTF8String];// 先转为UTF_8编码的字符串
    unsigned char digest[CC_MD5_DIGEST_LENGTH];//设置一个接受字符数组
    CC_MD5( cStr, (int)strlen(cStr), digest );// 把str字符串转换成为32位的16进制数列，存到了result这个空间中
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [result appendFormat:@"%02x", digest[i]];//将16字节的16进制转成32字节的16进制字符串
    }
    //    x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
    if (isUppercase) {
        return   [result uppercaseString];
    }else{
        return result;
    }
    
}

@end
