//
//  JCSQLite3.h
//  JCSQLiteTest
//
//  Created by molin on 16/5/11.
//  ( https://github.com/molinjc/JCKit )
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface JCSQLite3 : NSObject

@property (nonatomic, copy) NSString *sqliteName; // 数据库名

/**
 *  单例方法
 *
 *  @return 对象
 */
+ (JCSQLite3 *)sharedSQLite3;

/**
 *  数据库是否存在这个数据库名
 *
 *  @param name 数据库名
 *
 *  @return YES 存在 ， NO 不存在
 */
- (BOOL)sqlite3ExistsAtName:(NSString *)name;

/**
 这里把开启/关闭数据库的方法写出来，而不在执行一条SQL语句的代码里开启/关闭，
 是因为一但大量数据读取，频繁开启关闭数据库，很容易会有意外发生，导致程序崩溃。
 把开启/关闭数据库的方法写出来，按情况来开启/关闭数据库，避免意外。
 */

/**
 *  打开数据库
 *
 *  @return YES 打开成功， NO 打开失败
 */
- (BOOL)openSQLite3;

/**
 *  关闭数据库
 *
 *  @return YES 关闭成功， NO 关闭失败
 */
- (BOOL)closeSQLite3;

/**
 *  执行SQL语句
 *
 *  @param statement   SQL语句
 *
 *  @return 错误信息
 */
- (NSError *)executeSQLite3Statement:(NSString *)statement;

/**
 *  执行SQL语句
 *  错误信息里有21，那么表示数据库是关闭状态，无法取数据，需要开启数据库
 *  @param statement   SQL语句
 *  @param consequence 查询结果回调（会多次回调）
 *
 *  @return 错误信息
 */
- (NSError *)executeSQLite3Statement:(NSString *)statement consequence:(void (^)(id))consequence;

/**
 *  创建表：CREATE TABLE "表名" ("字段1" 类型, ....);
 *  查询：SELECT * FROM "表名"
 *  插入：INSERT INTO 表名(字段1,字段2,...) values(值1,值2,...)
 *  删除：delete from 表名 where 范围
 *  更新：update 表名 set 字段=值 where 范围
 */


@end
