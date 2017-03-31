//
//  JCSQLite3.h
//  Created by molin on 16/5/11.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

/** SQLite(数据库)的操作类 */
@interface JCSQLite3 : NSObject

/** 数据库名, 设置才可获取到数据库 */
@property (nonatomic, copy) NSString *sqliteName; 

/** 单例方法 */
+ (JCSQLite3 *)sharedSQLite3;

/**
 数据库是否存在这个数据库名
 @param name 数据库名
 @return YES 存在 ， NO 不存在
 */
- (BOOL)sqlite3ExistsAtName:(NSString *)name;

/**
 打开数据库
 @return YES 打开成功， NO 打开失败
 */
- (BOOL)openSQLite3;

/**
 关闭数据库
 @return YES 关闭成功， NO 关闭失败
 */
- (BOOL)closeSQLite3;

/**
 执行SQL语句
 @param statement   SQL语句
 @return 错误信息
 */
- (NSError *)executeSQLite3Statement:(NSString *)statement;

/**
 执行SQL语句
 @param statement   SQL语句
 @param consequence 查询结果回调（会多次回调）
 @return 错误信息
 */
- (NSError *)executeSQLite3Statement:(NSString *)statement consequence:(void (^)(id))consequence;

@end
