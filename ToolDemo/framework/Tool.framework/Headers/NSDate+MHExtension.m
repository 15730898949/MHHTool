//
//  NSDate+Extension.m
//  FangZhou
//
//  Created by wtw on 16/6/6.
//  Copyright © 2016年 rocedar. All rights reserved.
//

#import "NSDate+MHExtension.h"

static const unsigned componentFlags = (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal);

@implementation NSDate (mh_extension)


+ (NSDateComponents *)nowDate{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *nowCmps=  [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
    
    // 1.获得当前时间的年月日
    return nowCmps;
}


// 获取某个月的天数
+ (NSInteger)getSumOfDaysInYear:(NSString *)year month:(NSString *)month{

    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];

    [formatter setDateFormat:@"yyyy-MM"]; // 年-月

    NSString * dateStr = [NSString stringWithFormat:@"%@-%@",year,month];

    NSDate * date = [formatter dateFromString:dateStr];

    //
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit
                                   inUnit: NSMonthCalendarUnit
                                  forDate:date];
    return range.length;
    
}



+ (NSDate *)dateFromString:(NSString *)string {
    return [self dateFromString:string withDateFormatStyle:DateFormatYMDHMS];
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:string];
    return date;
}

+ (NSDate *)dateFromString:(NSString *)string withDateFormatStyle:(DateFormatStyle)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.calendar = [NSCalendar currentCalendar];
    switch (format) {
        case DateFormatYMDHMS: {
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            break;
        }
        case DateFormatYMDHM: {
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            break;
        }
        case DateFormatYMD: {
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            break;
        }
        case DateFormatMDHMS: {
            [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
            break;
        }
        case DateFormatMDHM: {
            [dateFormatter setDateFormat:@"MM-dd HH:mm"];
            break;
        }
        case DateFormatMD: {
            [dateFormatter setDateFormat:@"MM-dd"];
            break;
        }
        case DateFormatHMS: {
            [dateFormatter setDateFormat:@"HH:mm:ss"];
            break;
        }
        case DateFormatHM: {
            [dateFormatter setDateFormat:@"HH:mm"];
            break;
        }
        case DateFormatMS: {
            [dateFormatter setDateFormat:@"mm:ss"];
            break;
        }
        default: {
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            break;
        }
    }
    
    return [dateFormatter dateFromString:string];;
}

/****************************************************
 *@Description:根据年份、月份、日期、小时数、分钟数、秒数返回NSDate
 *@Params:
 *  year:年份
 *  month:月份
 *  day:日期
 *  hour:小时数
 *  minute:分钟数
 *  second:秒数
 *@Return:
 ****************************************************/
+ (NSDate *)dateWithYear:(NSUInteger)year
                   Month:(NSUInteger)month
                     Day:(NSUInteger)day
                    Hour:(NSUInteger)hour
                  Minute:(NSUInteger)minute
                  Second:(NSUInteger)second
{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
    dateComponents.year = year;
    dateComponents.month = month;
    dateComponents.day = day;
    dateComponents.hour = hour;
    dateComponents.minute = minute;
    dateComponents.second = second;
    
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}


/****************************************************
 *@Description:实现dateFormatter单例方法
 *@Params:nil
 *Return:相应格式的NSDataFormatter对象
 ****************************************************/
+ (NSDateFormatter *)defaultDateFormatterWithFormatYYYYMMddHHmmss
{
    static NSDateFormatter *staticDateFormatterWithFormatYYYYMMddHHmmss;
    if (!staticDateFormatterWithFormatYYYYMMddHHmmss) {
        staticDateFormatterWithFormatYYYYMMddHHmmss = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatYYYYMMddHHmmss setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    }
    
    return staticDateFormatterWithFormatYYYYMMddHHmmss;
}

+ (NSDateFormatter *)defaultDateFormatterWithFormatYYYYMMdd
{
    static NSDateFormatter *staticDateFormatterWithFormatYYYYMMddHHmmss;
    if (!staticDateFormatterWithFormatYYYYMMddHHmmss) {
        staticDateFormatterWithFormatYYYYMMddHHmmss = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatYYYYMMddHHmmss setDateFormat:@"YYYY.MM.dd"];
    }
    
    return staticDateFormatterWithFormatYYYYMMddHHmmss;
}


+ (NSDateFormatter *)defaultDateFormatterWithFormatMMddHHmm
{
    static NSDateFormatter *staticDateFormatterWithFormatMMddHHmm;
    if (!staticDateFormatterWithFormatMMddHHmm) {
        staticDateFormatterWithFormatMMddHHmm = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatMMddHHmm setDateFormat:@"MM-dd HH:mm"];
    }
    
    return staticDateFormatterWithFormatMMddHHmm;
}

+ (NSDateFormatter *)defaultDateFormatterWithFormatYYYYMMddHHmmInChinese
{
    static NSDateFormatter *staticDateFormatterWithFormatYYYYMMddHHmmssInChines;
    if (!staticDateFormatterWithFormatYYYYMMddHHmmssInChines) {
        staticDateFormatterWithFormatYYYYMMddHHmmssInChines = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatYYYYMMddHHmmssInChines setDateFormat:@"YYYY年MM月dd日 HH:mm"];
    }
    
    return staticDateFormatterWithFormatYYYYMMddHHmmssInChines;
}

+ (NSDateFormatter *)defaultDateFormatterWithFormatMMddHHmmInChinese
{
    static NSDateFormatter *staticDateFormatterWithFormatMMddHHmmInChinese;
    if (!staticDateFormatterWithFormatMMddHHmmInChinese) {
        staticDateFormatterWithFormatMMddHHmmInChinese = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatMMddHHmmInChinese setDateFormat:@"MM月dd日 HH:mm"];
    }
    
    return staticDateFormatterWithFormatMMddHHmmInChinese;
}


/**********************************************************
 *@Description:获取当天的包括“年”，“月”，“日”，“周”，“时”，“分”，“秒”的NSDateComponents
 *@Params:nil
 *@Return:当天的包括“年”，“月”，“日”，“周”，“时”，“分”，“秒”的NSDateComponents
 ***********************************************************/
- (NSDateComponents *)componentsOfDay
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
}


//  --------------------------NSDate---------------------------
/****************************************************
 *@Description:获得NSDate对应的年份
 *@Params:nil
 *@Return:NSDate对应的年份
 ****************************************************/
- (NSUInteger)year
{
    return [self componentsOfDay].year;
}

/****************************************************
 *@Description:获得NSDate对应的月份
 *@Params:nil
 *@Return:NSDate对应的月份
 ****************************************************/
- (NSUInteger)month
{
    return [self componentsOfDay].month;
}


/****************************************************
 *@Description:获得NSDate对应的日期
 *@Params:nil
 *@Return:NSDate对应的日期
 ****************************************************/
- (NSUInteger)day
{
    return [self componentsOfDay].day;
}


/****************************************************
 *@Description:获得NSDate对应的小时数
 *@Params:nil
 *@Return:NSDate对应的小时数
 ****************************************************/
- (NSUInteger)hour
{
    return [self componentsOfDay].hour;
}


/****************************************************
 *@Description:获得NSDate对应的分钟数
 *@Params:nil
 *@Return:NSDate对应的分钟数
 ****************************************************/
- (NSUInteger)minute
{
    return [self componentsOfDay].minute;
}


/****************************************************
 *@Description:获得NSDate对应的秒数
 *@Params:nil
 *@Return:NSDate对应的秒数
 ****************************************************/
- (NSUInteger)second
{
    return [self componentsOfDay].second;
}

/****************************************************
 *@Description:获得NSDate对应的星期
 *@Params:nil
 *@Return:NSDate对应的星期
 ****************************************************/
- (NSUInteger)weekday
{
    return [self componentsOfDay].weekday;
}

/******************************************
 *@Description:获取当天是当年的第几周
 *@Params:nil
 *@Return:当天是当年的第几周
 ******************************************/
- (NSUInteger)weekOfDayInYear
{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitYear forDate:self];
}


/****************************************************
 *@Description:获得一般当天的工作开始时间
 *@Params:nil
 *@Return:一般当天的工作开始时间
 ****************************************************/
- (NSDate *)workBeginTime
{
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:flags fromDate:self];
    [components setHour:9];
    [components setMinute:30];
    [components setSecond:0];
    
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

/****************************************************
 *@Description:获得一般当天的工作结束时间
 *@Params:nil
 *@Return:一般当天的工作结束时间
 ****************************************************/
- (NSDate *)workEndTime
{
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:flags fromDate:self];
    [components setHour:18];
    [components setMinute:0];
    [components setSecond:0];
    
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}


/****************************************************
 *@Description:获取一小时后的时间
 *@Params:nil
 *@Return:一小时后的时间
 ****************************************************/
- (NSDate *)oneHourLater
{
    return [NSDate dateWithTimeInterval:3600 sinceDate:self];
}

/****************************************************
 *@Description:获得某一天的这个时刻
 *@Params:nil
 *@Return:某一天的这个时刻
 ****************************************************/
- (NSDate *)sameTimeOfDate
{
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:flags fromDate:self];
    [components setHour:[[NSDate date] hour]];
    [components setMinute:[[NSDate date] minute]];
    [components setSecond:[[NSDate date] second]];
    
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

/******************************************
 *@Description:判断与某一天是否为同一天
 *@Params:
 *  otherDate:某一天
 *@Return:YES-同一天；NO-不同一天
 ******************************************/
- (BOOL)sameDayWithDate:(NSDate *)otherDate
{
    if (self.year == otherDate.year && self.month == otherDate.month && self.day == otherDate.day) {
        return YES;
    } else {
        return NO;
    }
}


/******************************************
 *@Description:判断与某一天是否为同一周
 *@Params:
 *  otherDate:某一天
 *@Return:YES-同一周；NO-不同一周
 ******************************************/
- (BOOL)sameWeekWithDate:(NSDate *)otherDate
{
    if (self.year == otherDate.year  && self.month == otherDate.month && self.weekOfDayInYear == otherDate.weekOfDayInYear) {
        return YES;
    } else {
        return NO;
    }
}

/******************************************
 *@Description:判断与某一天是否为同一月
 *@Params:
 *  otherDate:某一天
 *@Return:YES-同一月；NO-不同一月
 ******************************************/
- (BOOL)sameMonthWithDate:(NSDate *)otherDate
{
    if (self.year == otherDate.year && self.month == otherDate.month) {
        return YES;
    } else {
        return NO;
    }
}

/****************************************************
 *@Description:获取时间的字符串格式
 *@Params:nil
 *@Return:时间的字符串格式
 ****************************************************/
- (NSString *)stringOfDateWithFormatYYYYMMddHHmmss
{
    return [[NSDate defaultDateFormatterWithFormatYYYYMMddHHmmss] stringFromDate:self];
}

- (NSString *)stringOfDateWithFormatYYYYMMdd
{
    return [[NSDate defaultDateFormatterWithFormatYYYYMMdd] stringFromDate:self];
}

- (NSString *)stringOfDateWithFormatMMddHHmm
{
    return [[NSDate defaultDateFormatterWithFormatMMddHHmm] stringFromDate:self];
}

- (NSString *)stringOfDateWithFormatYYYYMMddHHmmInChinese
{
    return [[NSDate defaultDateFormatterWithFormatYYYYMMddHHmmInChinese] stringFromDate:self];
}

- (NSString *)stringOfDateWithFormatMMddHHmmInChinese
{
    return [[NSDate defaultDateFormatterWithFormatMMddHHmmInChinese] stringFromDate:self];
}


/**
 *  是否为今天
 */
- (BOOL)isToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return
    (selfCmps.year == nowCmps.year) &&
    (selfCmps.month == nowCmps.month) &&
    (selfCmps.day == nowCmps.day);
}

/**
 *  是否为昨天
 */
- (BOOL)isYesterday
{
    // 2014-05-01
    NSDate *nowDate = [[NSDate date] dateWithYMD];
    
    // 2014-04-30
    NSDate *selfDate = [self dateWithYMD];
    
    // 获得nowDate和selfDate的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
}

/**
 *  返回一个只有年月日的时间
 */
- (NSDate *)dateWithYMD
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}

/**
 *  是否为今年
 */
- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return nowCmps.year == selfCmps.year;
}




/**
 *  获得与当前时间的差距
 */
- (NSDateComponents *)deltaWithNow
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitHour | NSCalendarUnitMinute;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
}


/**
 字符串时间格式转换

 @param format format description
 @param dateStr 时间串
 @param fromFormat fromFormat description
 @return 返回格式化好的字符串
 */
+ (NSString *)dateToFomatter:(NSString *)format fromDateStr:(NSString *)dateStr fomatter:(NSString *)fromFormat {
    
    NSDate *date = [self dateFromString:dateStr fomatter:fromFormat];
    NSDateFormatter* formate=[[NSDateFormatter alloc]init];
    [formate setDateFormat:format];
    [formate setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    return [formate stringFromDate:date];
}

#pragma mark 字符串转日期
+ (NSDate *)dateFromString:(NSString *)dateString fomatter:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: format];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

/**
 获取当前周的周一日期
 
 @return yyyyMMdd
 */
+ (NSString *)getCurrentWeekMonday{
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:now];
    
    NSInteger weekday = [cmp weekday];  //今天是周几
    NSInteger day = [cmp day];  //今天是几号
    long firstday,lastday;
    
    if (weekday == 1) {
        firstday = -6;
        lastday = 0;
    }else {
        firstday = [calendar firstWeekday] - weekday + 1;
        lastday = 8 - weekday;
    }
    
    NSDateComponents *firstDaycmp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay  fromDate:now];
    [firstDaycmp setDay:day + firstday];
    NSDate *firstDayOfWeek = [calendar dateFromComponents:firstDaycmp];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *firstDay = [formatter stringFromDate:firstDayOfWeek];
    
    return firstDay;
}

// Courtesy of Lukasz Margielewski
// Updated via Holger Haenisch
+ (NSCalendar *) currentCalendar
{
    static NSCalendar *sharedCalendar = nil;
    if (!sharedCalendar)
        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
    return sharedCalendar;
}

#pragma mark - Relative Dates

+ (NSDate *) dateWithDaysFromNow: (NSInteger) days
{
    // Thanks, Jim Morrison
    return [[NSDate date] dateByAddingDays:days];
}

+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days
{
    // Thanks, Jim Morrison
    return [[NSDate date] dateBySubtractingDays:days];
}

+ (NSDate *) dateTomorrow
{
    return [NSDate dateWithDaysFromNow:1];
}

+ (NSDate *) dateYesterday
{
    return [NSDate dateWithDaysBeforeNow:1];
}

+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

#pragma mark - String Properties
- (NSString *) stringWithFormat: (NSString *) format
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    //    formatter.locale = [NSLocale currentLocale]; // Necessary?
    formatter.dateFormat = format;
    return [formatter stringFromDate:self];
}

- (NSString *) stringWithDateStyle: (NSDateFormatterStyle) dateStyle timeStyle: (NSDateFormatterStyle) timeStyle
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateStyle = dateStyle;
    formatter.timeStyle = timeStyle;
    //    formatter.locale = [NSLocale currentLocale]; // Necessary?
    return [formatter stringFromDate:self];
}

- (NSString *) shortString
{
    return [self stringWithDateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
}

- (NSString *) shortTimeString
{
    return [self stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
}

- (NSString *) shortDateString
{
    return [self stringWithDateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
}

- (NSString *) mediumString
{
    return [self stringWithDateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle ];
}

- (NSString *) mediumTimeString
{
    return [self stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterMediumStyle ];
}

- (NSString *) mediumDateString
{
    return [self stringWithDateStyle:NSDateFormatterMediumStyle  timeStyle:NSDateFormatterNoStyle];
}

- (NSString *) longString
{
    return [self stringWithDateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterLongStyle ];
}

- (NSString *) longTimeString
{
    return [self stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterLongStyle ];
}

- (NSString *) longDateString
{
    return [self stringWithDateStyle:NSDateFormatterLongStyle  timeStyle:NSDateFormatterNoStyle];
}

#pragma mark - Comparing Dates

- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate
{
    NSDateComponents *components1 = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:componentFlags fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}

// This hard codes the assumption that a week is 7 days
- (BOOL) isSameWeekAsDate: (NSDate *) aDate
{
    NSDateComponents *components1 = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:componentFlags fromDate:aDate];
    
    // Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
    if (components1.weekOfMonth != components2.weekOfMonth) return NO;
    
    // Must have a time interval under 1 week. Thanks @aclark
    return (fabs([self timeIntervalSinceDate:aDate]) < D_WEEK);
}

- (BOOL) isThisWeek
{
    return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL) isNextWeek
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}

- (BOOL) isLastWeek
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}

// Thanks, mspasov
- (BOOL) isSameMonthAsDate: (NSDate *) aDate
{
    NSDateComponents *components1 = [[NSDate currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:aDate];
    return ((components1.month == components2.month) &&
            (components1.year == components2.year));
}

- (BOOL) isThisMonth
{
    return [self isSameMonthAsDate:[NSDate date]];
}

// Thanks Marcin Krzyzanowski, also for adding/subtracting years and months
- (BOOL) isLastMonth
{
    return [self isSameMonthAsDate:[[NSDate date] dateBySubtractingMonths:1]];
}

- (BOOL) isNextMonth
{
    return [self isSameMonthAsDate:[[NSDate date] dateByAddingMonths:1]];
}

- (BOOL) isSameYearAsDate: (NSDate *) aDate
{
    NSDateComponents *components1 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:aDate];
    return (components1.year == components2.year);
}

- (BOOL) isNextYear
{
    NSDateComponents *components1 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return (components1.year == (components2.year + 1));
}

- (BOOL) isLastYear
{
    NSDateComponents *components1 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return (components1.year == (components2.year - 1));
}

- (BOOL) isEarlierThanDate: (NSDate *) aDate
{
    return ([self compare:aDate] == NSOrderedAscending);
}

- (BOOL) isLaterThanDate: (NSDate *) aDate
{
    return ([self compare:aDate] == NSOrderedDescending);
}

// Thanks, markrickert
- (BOOL) isInFuture
{
    return ([self isLaterThanDate:[NSDate date]]);
}

// Thanks, markrickert
- (BOOL) isInPast
{
    return ([self isEarlierThanDate:[NSDate date]]);
}


#pragma mark - Roles
- (BOOL) isTypicallyWeekend
{
    NSDateComponents *components = [[NSDate currentCalendar] components:NSCalendarUnitWeekday fromDate:self];
    if ((components.weekday == 1) ||
        (components.weekday == 7))
        return YES;
    return NO;
}

- (BOOL) isTypicallyWorkday
{
    return ![self isTypicallyWeekend];
}

#pragma mark - Adjusting Dates

// Thaks, rsjohnson
- (NSDate *) dateByAddingYears: (NSInteger) dYears
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:dYears];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *) dateBySubtractingYears: (NSInteger) dYears
{
    return [self dateByAddingYears:-dYears];
}

- (NSDate *) dateByAddingMonths: (NSInteger) dMonths
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:dMonths];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *) dateBySubtractingMonths: (NSInteger) dMonths
{
    return [self dateByAddingMonths:-dMonths];
}

// Courtesy of dedan who mentions issues with Daylight Savings
- (NSDate *) dateByAddingDays: (NSInteger) dDays
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:dDays];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *) dateBySubtractingDays: (NSInteger) dDays
{
    return [self dateByAddingDays: (dDays * -1)];
}

- (NSDate *) dateByAddingHours: (NSInteger) dHours
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *) dateBySubtractingHours: (NSInteger) dHours
{
    return [self dateByAddingHours: (dHours * -1)];
}

- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes
{
    return [self dateByAddingMinutes: (dMinutes * -1)];
}

- (NSDateComponents *) componentsWithOffsetFromDate: (NSDate *) aDate
{
    NSDateComponents *dTime = [[NSDate currentCalendar] components:componentFlags fromDate:aDate toDate:self options:0];
    return dTime;
}

#pragma mark - Extremes

- (NSDate *) dateAtStartOfDay
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [[NSDate currentCalendar] dateFromComponents:components];
}

// Thanks gsempe & mteece
- (NSDate *) dateAtEndOfDay
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    components.hour = 23; // Thanks Aleksey Kononov
    components.minute = 59;
    components.second = 59;
    return [[NSDate currentCalendar] dateFromComponents:components];
}

#pragma mark - Retrieving Intervals

- (NSInteger) minutesAfterDate: (NSDate *) aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger) minutesBeforeDate: (NSDate *) aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger) hoursAfterDate: (NSDate *) aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_HOUR);
}

- (NSInteger) hoursBeforeDate: (NSDate *) aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_HOUR);
}

- (NSInteger) daysAfterDate: (NSDate *) aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_DAY);
}

- (NSInteger) daysBeforeDate: (NSDate *) aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_DAY);
}

+ (NSDate *)date:(NSString *)datestr WithFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:datestr];
#if ! __has_feature(objc_arc)
    [dateFormatter release];
#endif
    return date;
}

// Thanks, dmitrydims
// I have not yet thoroughly tested this
- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:self toDate:anotherDate options:0];
    return components.day;
}

#pragma mark - Decomposing Dates

- (NSInteger) nearestHour
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * 30;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    NSDateComponents *components = [[NSDate currentCalendar] components:NSCalendarUnitHour fromDate:newDate];
    return components.hour;
}

-(NSDate *)dateWithFormatter:(NSString *)formatter {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = formatter;
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}

@end
