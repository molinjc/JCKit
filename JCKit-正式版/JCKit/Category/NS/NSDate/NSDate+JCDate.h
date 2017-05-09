//
//  NSDate+JCDate.h
//  JCKit
//
//  Created by 林建川 on 16/9/27.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDATE_MINUTE_SEC 60           // 一分 = 60秒
#define kDATE_HOURS_SEC  3600         // 一小时 = 60分 = 3600秒
#define kDATE_DAY_SEC    86400        // 一天 = 24小时 = 86400秒
#define kDATE_WEEK_SEC   604800       // 一周 = 7天 =  604800秒

@interface NSDate (JCDate)

@property (nonatomic, readonly) NSInteger year; ///< Year component
@property (nonatomic, readonly) NSInteger month; ///< Month component (1~12)
@property (nonatomic, readonly) NSInteger day; ///< Day component (1~31)
@property (nonatomic, readonly) NSInteger hour; ///< Hour component (0~23)
@property (nonatomic, readonly) NSInteger minute; ///< Minute component (0~59)
@property (nonatomic, readonly) NSInteger second; ///< Second component (0~59)
@property (nonatomic, readonly) NSInteger nanosecond; ///< Nanosecond component
@property (nonatomic, readonly) NSInteger weekday; ///< Weekday component (1~7, first day is based on user setting)
@property (nonatomic, readonly) NSInteger weekdayOrdinal; ///< WeekdayOrdinal component
@property (nonatomic, readonly) NSInteger weekOfMonth; ///< WeekOfMonth component (1~5)
@property (nonatomic, readonly) NSInteger weekOfYear; ///< WeekOfYear component (1~53)
@property (nonatomic, readonly) NSInteger yearForWeekOfYear; ///< YearForWeekOfYear component
@property (nonatomic, readonly) NSInteger quarter; ///< Quarter component
@property (nonatomic, readonly) BOOL isLeapMonth; ///< whether the month is leap month
@property (nonatomic, readonly) BOOL isLeapYear;  /// 闰年

// *****************  时间转换 ****************************
+ (NSDate *)dateWithString:(NSString *)stringDate;
+ (NSDate *)dateWithString:(NSString *)stringDate format:(NSString *)format;

- (NSString *)string;
- (NSString *)stringWithFormat:(NSString *)format;

#pragma mark ---- 从当前日期相对日期时间

/**
 明天
 */
+ (NSDate *)dateTomorrow;

/**
 后几天
 */
+ (NSDate *)dateWithDaysFromNow:(NSInteger)days;

/**
 昨天
 */
+ (NSDate *)dateYesterday;

/**
 前几天
 */
+ (NSDate *)dateWithDaysBeforeNow:(NSInteger)days;

/**
 当前小时后hours个小时
 */
+ (NSDate *)dateWithHoursFromNow:(NSInteger)hours;

/**
 当前小时前hours个小时
 */
+ (NSDate *)dateWithHoursBeforeNow:(NSInteger)hours;

/**
 当前分钟后minutes个分钟
 */
+ (NSDate *)dateWithMinutesFromNow:(NSInteger)minutes;

/**
 当前分钟前minutes个分钟
 */
+ (NSDate *)dateWithMinutesBeforeNow:(NSInteger)minutes;

/**
 追加天数，生成新的NSDate
 */
- (NSDate *)dateByAddingDays:(NSInteger)days;

/**
 追加秒数，生成新的NSDate
 */
+ (NSDate *)dateByAddingTimeInterval:(NSTimeInterval)ti;

@end
