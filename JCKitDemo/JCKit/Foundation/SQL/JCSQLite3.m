//
//  JCSQLite3.m
//  JCSQLiteTest
//
//  Created by molin on 16/5/11.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCSQLite3.h"

#define kSQLITE3ERROR @"SQLite3Error"

@interface JCSQLite3 () {
    sqlite3 *_db;  // 定义数据库对象
}

@property (nonatomic, copy) NSString *sqlite3Path;

@property (nonatomic, weak) void (^consequence)(sqlite3_stmt *stmt, int count);

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
    dispatch_once_t once;
    dispatch_once(&once, ^{
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
    int rst = sqlite3_close_v2(_db);
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
    
    char *errorChar;
    if (!range.length) {
        int result = sqlite3_exec(_db, [statement UTF8String], NULL, NULL, &errorChar);
        if (result != SQLITE_OK) {
            userInfo = @{NSLocalizedDescriptionKey:[NSString stringWithUTF8String:errorChar]};
            error = [NSError errorWithDomain:kSQLITE3ERROR code:-1 userInfo:userInfo];
            return error;
        }
    }else {
        sqlite3_stmt  *stmt;
        int result = sqlite3_prepare_v2(_db, [statement UTF8String], -1, &stmt, nil);
        if (result == SQLITE_OK) {
            int count = 0;
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                if (self.consequence) {
                    self.consequence(stmt,count);
                }
                count++;
            }
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
- (NSError *)executeSQLite3Statement:(NSString *)statement consequence:(void (^)(sqlite3_stmt *stmt, int count))consequence {
    self.consequence = consequence;
    NSError *error = [self executeSQLite3Statement:statement];
    return error;
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
