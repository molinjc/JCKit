//
//  JCSQLite3.h
//
//  Created by molin.JC on 2017/5/8.
//  Copyright © 2017年 molin. All rights reserved.
//  v2.0

#import <Foundation/Foundation.h>
#import <sqlite3.h>

/** 查询结果排序 */
typedef NS_ENUM(NSUInteger, JCSQLiteSelectOrder) {
    JCSQLiteSelectOrderNot = 0,
    JCSQLiteSelectOrderDESC,
    JCSQLiteSelectOrderASC,
};

@interface JCSQLite3 : NSObject
/** 数据库名 */
@property (nonatomic, readonly) NSString *name;
/** 数据库的路径 */
@property (nonatomic, readonly) NSString *path;
/** 数据库 */
@property (nonatomic, readonly) sqlite3 *sqlite;

#pragma mark - init

/** 根据数据库名创建 */
- (instancetype)initWithName:(NSString *)name;
/** 根据路径创建数据库 */
- (instancetype)initWithPath:(NSString *)path;

#pragma mark - sqlite operation

/** 打开数据库 */
- (BOOL)open;
/** 关闭数据库 */
- (BOOL)close;
/** 执行SQL语句 */
- (BOOL)execute:(NSString *)sql;
/** 执行查询语句 */
- (NSArray *)query:(NSString *)sql;
/** 执行语句获取sqlite3_stmt */
- (sqlite3_stmt *)prepareStmt:(NSString *)sql;

#pragma mark - table operation

/**
 创建数据库表
 @param table 表名
 @param fields 字段名
 @param types 字段的数据(库)类型
 */
- (BOOL)createTable:(NSString *)table fields:(NSArray <NSString *> *)fields types:(NSArray <NSString *> *)types;
/** 删除数据库表 */
- (BOOL)deleteTable:(NSString *)table;

#pragma mark - data operation - insert

/** 插入数据 */
- (BOOL)insertWithTable:(NSString *)table values:(NSDictionary *)values;
/** 替换数据 */
- (BOOL)replaceWithTable:(NSString *)table values:(NSDictionary *)values;

#pragma mark - data operation - select

/** 查询所有数据 */
- (NSArray *)selectWithTable:(NSString *)table;
/** 查询指定字段的数据 */
- (NSArray *)selectWithTable:(NSString *)table fields:(NSArray <NSString *> *)fields;
/** 查询符合条件的数据 */
- (NSArray *)selectWithTable:(NSString *)table fields:(NSArray <NSString *> *)fields where:(NSString *)where;
/** 查询符合条件的数据并根据根据要求排序 */
- (NSArray *)selectWithTable:(NSString *)table fields:(NSArray <NSString *> *)fields where:(NSString *)where orderBy:(NSArray <NSString *> *)orderBy order:(JCSQLiteSelectOrder)type;

#pragma mark - data operation - update

/** 更新数据 */
- (BOOL)updateWithTable:(NSString *)table values:(NSDictionary *)values where:(NSString *)where;

#pragma mark - data operation - delete

/** 删除数据 */
- (BOOL)deleteWithTable:(NSString *)table where:(NSDictionary *)wheres;
@end
