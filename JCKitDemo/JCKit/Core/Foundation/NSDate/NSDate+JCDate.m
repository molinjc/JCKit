//
//  NSDate+JCDate.m
//  JCKit
//
//  Created by 林建川 on 16/9/27.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "NSDate+JCDate.h"

@implementation NSDate (JCDate)

- (NSInteger)year {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self] year];
}

- (NSInteger)month {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self] month];
}

- (NSInteger)day {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] day];
}

- (NSInteger)hour {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self] hour];
}

- (NSInteger)minute {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self] minute];
}

- (NSInteger)second {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] second];
}

- (NSInteger)nanosecond {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] nanosecond];
}

- (NSInteger)weekday {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self] weekday];
}

- (NSInteger)weekdayOrdinal {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekdayOrdinal fromDate:self] weekdayOrdinal];
}

- (NSInteger)weekOfMonth {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfMonth fromDate:self] weekOfMonth];
}

- (NSInteger)weekOfYear {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfYear fromDate:self] weekOfYear];
}

- (NSInteger)yearForWeekOfYear {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYearForWeekOfYear fromDate:self] yearForWeekOfYear];
}

// 季度
- (NSInteger)quarter {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] quarter];
}

// 闰月
- (BOOL)isLeapMonth {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] isLeapMonth];
}

// 闰年
- (BOOL)isLeapYear {
    NSUInteger year = self.year;
    return ((year % 400 == 0) || (year % 100 == 0) || (year % 4 == 0));
}

// 今天
- (BOOL)isToday {
    if (fabs(self.timeIntervalSinceNow) >= 60 * 60 * 24) return NO;
    return [NSDate new].day == self.day;
}

// *****************  时间转换 ****************************

#define DATEFORMAT @"yyyy-MM-dd HH:mm:ss"

+ (NSDate *)dateWithString:(NSString *)stringDate {
    return [NSDate dateWithString:stringDate format:DATEFORMAT];
}

+ (NSDate *)dateWithString:(NSString *)stringDate format:(NSString *)format {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale currentLocale]];
    });
    formatter.dateFormat = format;
    // 将字符串按formatter转成nsdate
    return [formatter dateFromString:stringDate];
}

- (NSString *)string {
    return [self stringWithFormat:DATEFORMAT];
}

- (NSString *)stringWithFormat:(NSString *)format {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale currentLocale]];
    });
    formatter.dateFormat = format;
    return [formatter stringFromDate:self];
}

#pragma mark ---- 从当前日期相对日期时间

/**
 明天
 */
+ (NSDate *)dateTomorrow {
    return [NSDate dateWithDaysFromNow:1];
}

/**
 后几天
 */
+ (NSDate *)dateWithDaysFromNow:(NSInteger)days {
    return [[NSDate date] dateByAddingDays:days];
}

/**
 昨天
 */
+ (NSDate *)dateYesterday {
    return [NSDate dateWithDaysFromNow:1];
}

/**
 前几天
 */
+ (NSDate *)dateWithDaysBeforeNow:(NSInteger)days {
    return [[NSDate date] dateByAddingDays:-days];
}

/**
 当前小时后hours个小时
 */
+ (NSDate *)dateWithHoursFromNow:(NSInteger)hours {
    return [NSDate dateByAddingTimeInterval:kDATE_HOURS_SEC * hours];
}

/**
 当前小时前hours个小时
 */
+ (NSDate *)dateWithHoursBeforeNow:(NSInteger)hours {
    return [NSDate dateByAddingTimeInterval:-(kDATE_HOURS_SEC * hours)];
}

/**
 当前分钟后minutes个分钟
 */
+ (NSDate *)dateWithMinutesFromNow:(NSInteger)minutes {
    return [NSDate dateByAddingTimeInterval:kDATE_MINUTE_SEC * minutes];
}

/**
 当前分钟前minutes个分钟
 */
+ (NSDate *)dateWithMinutesBeforeNow:(NSInteger)minutes {
    return [NSDate dateByAddingTimeInterval:-(kDATE_MINUTE_SEC * minutes)];
}

/**
 追加天数，生成新的NSDate
 */
- (NSDate *)dateByAddingDays:(NSInteger)days {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:days];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

/**
 追加秒数，生成新的NSDate
 */
+ (NSDate *)dateByAddingTimeInterval:(NSTimeInterval)ti {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + ti;
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return date;
}

@end
