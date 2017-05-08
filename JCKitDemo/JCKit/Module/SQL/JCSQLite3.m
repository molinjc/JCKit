//
//  JCSQLite3.m
//  JCSQLiteTest
//
//  Created by molin on 16/5/11.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCSQLite3.h"
#import <libkern/OSAtomic.h>

#define kSQLITE3ERROR @"SQLite3Error"
#define kTernary(condition, valueTrue, valueFalse) condition ? valueTrue : valueFalse

@interface JCSQLite3 () {
    sqlite3 *_db;  // 定义数据库对象
//    OSSpinLock _dbStateLock;
}

@property (nonatomic, copy) NSString *sqlite3Path;

@property (nonatomic, copy) void (^consequence)(id);

@end

@implementation JCSQLite3
@synthesize sqlite3Path;


/**
 *  单例方法
 *
 *  @return 对象
 */
+ (JCSQLite3 *)sharedSQLite3 {
    static JCSQLite3 *sqlite3 = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sqlite3 = [[JCSQLite3 alloc] init];
    });
    return sqlite3;
}

/**
 *  初始化方法
 *
 *  @return 对象
 */
- (instancetype)init {
    if (self = [super init]) {
//        _dbStateLock = OS_SPINLOCK_INIT;
    }
    return self;
}

/**
 *  数据库是否存在这个数据库名
 *
 *  @param name 数据库名
 *
 *  @return YES 存在 ， NO 不存在
 */
- (BOOL)sqlite3ExistsAtName:(NSString *)name {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    self.sqlite3Path = [NSString stringWithFormat:@"%@/%@",path,name];
    // 创建文件管理器
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:self.sqlite3Path]) {
        return YES;
    }
    return NO;
}

/**
 *  打开数据库
 *
 *  @return YES 打开成功， NO 打开失败
 */
- (BOOL)openSQLite3 {
//    OSSpinLockLock(&_dbStateLock);
    int rst = sqlite3_open([self.sqlite3Path UTF8String], &_db);
    if (rst == SQLITE_OK) {
        return YES;
    }
    return NO;
}

/**
 *  关闭数据库
 *
 *  @return YES 关闭成功， NO 关闭失败
 */
- (BOOL)closeSQLite3 {
    int rst = sqlite3_close(_db);
    if (rst == SQLITE_OK) {
        return YES;
    }
    return NO;
}

/**
 *  执行SQL语句
 *
 *  @param statement   SQL语句
 *
 *  @return 错误信息
 */
- (NSError *)executeSQLite3Statement:(NSString *)statement {
    NSError *error;
    NSDictionary *userInfo;
    
    if (!statement) {
        userInfo = @{NSLocalizedDescriptionKey:@"SQLite语句为空"};
        error = [NSError errorWithDomain:kSQLITE3ERROR code:-1 userInfo:userInfo];
        return error;
    }
    NSRange range = [statement rangeOfString:@"select"];
    NSRange range1 = [statement rangeOfString:@"SELECT"];
    
    char *errorChar;
    if (!kTernary(range.length, kTernary(range1.length, YES, NO), NO)) {
//        OSSpinLockLock(&_dbStateLock);
        int result = sqlite3_exec(_db, [statement UTF8String], NULL, NULL, &errorChar);
        if (result != SQLITE_OK) {
            userInfo = @{NSLocalizedDescriptionKey:[NSString stringWithUTF8String:errorChar]};
            error = [NSError errorWithDomain:kSQLITE3ERROR code:-1 userInfo:userInfo];
//            OSSpinLockUnlock(&_dbStateLock);
            return error;
        }
//        OSSpinLockUnlock(&_dbStateLock);
    }else {
//        OSSpinLockLock(&_dbStateLock);
        sqlite3_stmt  *stmt;
        int result = sqlite3_prepare_v2(_db, [statement UTF8String], -1, &stmt, nil);
        if (result == SQLITE_OK) {
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
                            dataDic[key] = [self sqlite3ColumnBlob:stmt index:i];
                            break;
                        case SQLITE_TEXT:
                            dataDic[key] = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, i)];
                            break;
                        default:
                            break;
                    }
                }
                [dataArray addObject:dataDic];
            }
            
            sqlite3_finalize(stmt);
            
            id data = nil;
            if (dataArray.count == 1) {
                data = dataArray[0];
            }else if (dataArray.count > 1) {
                data = dataArray;
            }
            if (self.consequence) {
                self.consequence(data);
            }
//            OSSpinLockUnlock(&_dbStateLock);
        }else {
            userInfo = @{NSLocalizedDescriptionKey:@"SQLite语句执行失败"};
            error = [NSError errorWithDomain:kSQLITE3ERROR code:-1 userInfo:userInfo];
            return error;
        }
    }
    return nil;
}

/**
 *  执行SQL语句
 *
 *  @param statement   SQL语句
 *  @param consequence 查询结果回调（会多次回调）
 *
 *  @return 错误信息
 */
- (NSError *)executeSQLite3Statement:(NSString *)statement consequence:(void (^)(id))consequence {
    self.consequence = consequence;
    NSError *error = [self executeSQLite3Statement:statement];
    return error;
}

/**
 *  处理数据是data型
 *  @return NSData对象
 */
- (NSData *)sqlite3ColumnBlob:(sqlite3_stmt *)stmt index:(int)i {
    const char *dataBuffer = sqlite3_column_blob(stmt,i);
    int dataSize = sqlite3_column_bytes(stmt,i);
    if (dataBuffer == NULL) {
        return nil;
    }
    return [NSData dataWithBytes:(const void *)dataBuffer length:(NSUInteger)dataSize];
}

#pragma mark - set/get

- (void)setSqliteName:(NSString *)sqliteName {
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@",@".*(.sqlite$)"];
    if (![predicate evaluateWithObject:sqliteName]) {
        sqliteName = [sqliteName stringByAppendingString:@".sqlite"];
    }
    
    if (![self sqlite3ExistsAtName:sqliteName]) {
        sqlite3_open([self.sqlite3Path UTF8String], &_db);
    }
    _sqliteName = sqliteName;
}

@end
