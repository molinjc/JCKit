//
//  JCSQLite3.m
//
//  Created by molin.JC on 2017/5/8.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCSQLite3.h"

@interface JCSQLite3 () {
    /** 数据库 */
    sqlite3 * _db;
    /** 数据库名 */
    NSString * _name;
    /** 数据库路径 */
    NSString * _path;
}

@end

@implementation JCSQLite3

- (instancetype)initWithName:(NSString *)name {
    if (!name || !name.length) {
        return nil;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@",@".*(.sqlite$)"];
    if (![predicate evaluateWithObject:name]) {
        name = [name stringByAppendingString:@".sqlite"];
    }
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:name];
    return [self initWithPath:path];
}

- (instancetype)initWithPath:(NSString *)path {
    if (!path || !path.length) {
        return nil;
    }
    
    if (self = [super init]) {
        assert(sqlite3_threadsafe());
        _path = [path copy];
        _name = path.lastPathComponent;
        _db = NULL;
        
        if (![self open]) {
            [self close];
            if (![self open]) {
                NSLog(@"fail to open sqlite db. (无法打开数据库)");
                return nil;
            }
        }
    }
    return self;
}

#pragma mark - open and close

/** 打开数据库 */
- (BOOL)open {
    if (_db) { return YES; }
    int err = sqlite3_open(_path.UTF8String, &_db );
    return err == SQLITE_OK;
}

/** 关闭数据库 */
- (BOOL)close {
    if (!_db) { return YES; }
    int  result = 0;
    BOOL retry = NO;
    BOOL stmtFinalized = NO;
    
    do {
        retry = NO;
        result = sqlite3_close(_db);
        if (result == SQLITE_BUSY || result == SQLITE_LOCKED) {
            if (!stmtFinalized) {
                stmtFinalized = YES;
                sqlite3_stmt *stmt;
                while ((stmt = sqlite3_next_stmt(_db, nil)) != 0) {
                    sqlite3_finalize(stmt);
                    retry = YES;
                }
            }
        } else if (result != SQLITE_OK) {
            NSLog(@"%s line:%d sqlite close failed (%d).", __FUNCTION__, __LINE__, result);
        }
    } while (retry);
    _db = NULL;
    return YES;
}

#pragma mark - bottom sql

- (BOOL)execute:(NSString *)sql {
    if (!sql || !sql.length) { return NO; }
    char *error = nil;
    int result = sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &error);
    if (error) {
        NSLog(@"sqlite exec error (%d): %s", result, error);
        sqlite3_free(error);
    }
    return result == SQLITE_OK;
}

- (sqlite3_stmt *)prepareStmt:(NSString *)sql {
    if (!sql || !sql.length) { return NULL; }
    sqlite3_stmt *stmt = 0x00;
    int result = sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL);
    if (result != SQLITE_OK) {
        return NULL;
    }
    return stmt;
}

- (NSArray *)query:(NSString *)sql {
    sqlite3_stmt *stmt = [self prepareStmt:sql];
    if (!stmt) {
        return nil;
    }
    
    NSMutableArray *dataArray = [NSMutableArray new];
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        int columnCount = sqlite3_column_count(stmt);
        NSMutableDictionary *dataDic = [NSMutableDictionary new];
        
        for (int i = 0; i<columnCount; i++) {
            NSString *key = [NSString stringWithUTF8String:sqlite3_column_name(stmt,i)];
            
            switch (sqlite3_column_type(stmt,i)) {
                case SQLITE_INTEGER:
                    dataDic[key] = @(sqlite3_column_int(stmt,i));
                    break;
                case SQLITE_FLOAT:
                    dataDic[key] = @(sqlite3_column_double(stmt,i));
                    break;
                case SQLITE_BLOB:
                    dataDic[key] = [self _sqliteColumnBlob:stmt index:i];
                    break;
                case SQLITE_TEXT:
                    dataDic[key] = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, i)];
                    break;
                default: break;
            }
        }
        [dataArray addObject:dataDic];
    }
    sqlite3_finalize(stmt);
    
    if (dataArray.count == 0) {
        return nil;
    }
    return dataArray.mutableCopy;
}

#pragma mark - table

- (BOOL)createTable:(NSString *)table fields:(NSArray <NSString *> *)fields types:(NSArray <NSString *> *)types {
    if (!table || !table.length) { return NO;}
    if (!fields || !types || !fields.count || !types.count) { return NO; }
    if (fields.count != types.count) { return NO; }
    
    NSMutableString *sql = [[NSMutableString alloc] initWithFormat:@"CREATE TABLE \"%@\" (", table];
    for (int i = 0; i < fields.count; i++) {
        if (i == fields.count - 1) {
            [sql appendFormat:@"\"%@\" %@)", fields[i], types[i]];
        }else {
            [sql appendFormat:@"\"%@\" %@,", fields[i], types[i]];
        }
    }
    return [self execute:sql.copy];
}

- (BOOL)deleteTable:(NSString *)table {
    if (!table || !table.length) { return NO; }
    return [self execute:[NSString stringWithFormat:@"DROP TABLE \"%@\"", table]];
}

#pragma mark - data insert

- (BOOL)insertWithTable:(NSString *)table values:(NSDictionary *)values {
    return [self _insertOrReplace:YES table:table values:values];
}

- (BOOL)replaceWithTable:(NSString *)table values:(NSDictionary *)values {
    return [self _insertOrReplace:NO table:table values:values];
}

#pragma mark - data select

- (NSArray *)selectWithTable:(NSString *)table {
    return [self selectWithTable:table fields:nil where:nil];
}

- (NSArray *)selectWithTable:(NSString *)table fields:(NSArray <NSString *> *)fields {
    return [self selectWithTable:table fields:fields where:nil];
}

- (NSArray *)selectWithTable:(NSString *)table fields:(NSArray <NSString *> *)fields where:(NSString *)where {
    return [self selectWithTable:table fields:fields where:where orderBy:nil order:0];
}

- (NSArray *)selectWithTable:(NSString *)table fields:(NSArray <NSString *> *)fields where:(NSString *)where orderBy:(NSArray <NSString *> *)orderBy order:(JCSQLiteSelectOrder)type {
    if (!table || !table.length) { return nil; }
    NSMutableString *sql;
    if (fields) {
        sql = [NSMutableString stringWithFormat:@"SELECT "];
        for (int i = 0; i < fields.count; i++) {
            if (i == fields.count - 1) {
                [sql appendString:fields[i]];
            }else {
                [sql appendFormat:@"%@,", fields[i]];
            }
        }
    }else {
        sql = [NSMutableString stringWithFormat:@"SELECT * "];
    }
    
    if (where && where.length) {
        [sql appendFormat:@" FROM \"%@\" WHERE %@", table, where];
    }else {
        [sql appendFormat:@" FROM \"%@\"", table];
    }
    
    if (orderBy) {
        [sql appendFormat:@"ORDER BY "];
        for (int i = 0; i < orderBy.count; i++) {
            if (i == orderBy.count - 1) {
                [sql appendString:orderBy[i]];
            }else {
                [sql appendFormat:@"%@,", orderBy[i]];
            }
        }
        [sql appendFormat:@" %@", type == JCSQLiteSelectOrderNot ? @"" : type == JCSQLiteSelectOrderDESC ? @"DESC" : @"ASC"];
    }
    return [self query:sql.copy];
}

#pragma mark - data updata

- (BOOL)updateWithTable:(NSString *)table values:(NSDictionary *)values where:(NSString *)where {
    if (!table || !table.length) { return NO; }
    if (!values || !values.count) { return NO; }
    
    NSMutableString *sql = [[NSMutableString alloc] initWithFormat:@"UPDATE \"%@\" SET", table];
    [values enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        [sql appendFormat:@" '%@'='%@',", key, obj];
    }];
    [sql deleteCharactersInRange:NSMakeRange(sql.length - 1, 1)];
    
    if (where && where.length) {
        [sql appendFormat:@" WHERE %@", where];
    }
    return [self execute:sql.copy];
}

#pragma mark - data delete

- (BOOL)deleteWithTable:(NSString *)table where:(NSDictionary *)wheres {
    if (!table || !table.length) { return NO; }
    if (!wheres || !wheres.count) {
        return [self execute:[NSString stringWithFormat:@"DELETE FROM \"%@\"", table]];
    }
    
    NSMutableString *sql = [[NSMutableString alloc] initWithFormat:@"DELETE FROM \"%@\" WHERE", table];
    [wheres enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        [sql appendFormat:@" '%@'='%@' AND", key, obj];
    }];
    [sql deleteCharactersInRange:NSMakeRange(sql.length - 3, 3)];
    return [self execute:sql.copy];
}

#pragma mark - Get

- (NSString *)name {
    return _name;
}

- (NSString *)path {
    return _path;
}

- (sqlite3 *)sqlite {
    return _db;
}

#pragma mark - private

/** 处理数据是data型 */
- (NSData *)_sqliteColumnBlob:(sqlite3_stmt *)stmt index:(int)i {
    const char *dataBuffer = sqlite3_column_blob(stmt,i);
    int dataSize = sqlite3_column_bytes(stmt,i);
    if (dataBuffer == NULL) {
        return nil;
    }
    return [NSData dataWithBytes:(const void *)dataBuffer length:(NSUInteger)dataSize];
}

/** 插入(Yes)或替换(No) */
- (BOOL)_insertOrReplace:(BOOL)isInsert table:(NSString *)table values:(NSDictionary *)values {
    if (!table || !table.length) { return NO; }
    if (!values || !values.count) { return NO; }
    
    NSMutableString *sql;
    if (isInsert) {
        sql = [[NSMutableString alloc] initWithFormat:@"INSERT INTO \"%@\" ", table];
    }else {
        sql = [[NSMutableString alloc] initWithFormat:@"REPLACE INTO \"%@\" ", table];
    }
    
    NSMutableString *sql_keys = [[NSMutableString alloc] initWithString:@"("];
    NSMutableString *sql_values = [[NSMutableString alloc] initWithString:@"("];
    
    [values enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        [sql_keys appendFormat:@"'%@',", key];
        [sql_values appendFormat:@"'%@',", obj];
    }];
    
    [sql_keys replaceCharactersInRange:NSMakeRange(sql_keys.length - 1, 1) withString:@")"];
    [sql_values replaceCharactersInRange:NSMakeRange(sql_values.length - 1, 1) withString:@")"];
    [sql appendFormat:@"%@ values %@;", sql_keys, sql_values];
    return [self execute:sql.copy];
}

@end
