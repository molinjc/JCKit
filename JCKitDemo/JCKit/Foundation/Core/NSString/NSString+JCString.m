//
//  NSString+JCString.m
//  JCKitDemo
//
//  Created by 林建川 on 16/9/28.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "NSString+JCString.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSDate+JCDate.h"

@implementation NSString (JCString)

#pragma mark - MD2、MD4、MD5加密

// ****************** 32位加密 *******************

- (NSString *)md2_32 {
    const char *cstring = [self UTF8String];
    unsigned char result[CC_MD2_DIGEST_LENGTH];
    CC_MD2(cstring, (CC_LONG)strlen(cstring), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)md4_32 {
    const char *cstring = [self UTF8String];
    unsigned char result[CC_MD4_DIGEST_LENGTH];
    CC_MD4(cstring, (CC_LONG)strlen(cstring), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)md5_32 {
    const char *cstring = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cstring, (CC_LONG)strlen(cstring), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

// ****************** 16位加密 *******************

- (NSString *)md2_16 {
    return [[self.md2_32 substringToIndex:24] substringFromIndex:8];
}

- (NSString *)md4_16 {
    return [[self.md4_32 substringToIndex:24] substringFromIndex:8];
}

- (NSString *)md5_16 {
    return [[self.md5_32 substringToIndex:24] substringFromIndex:8];
}

#pragma mark - SHA加密

- (NSString *)sha1 {
    const char *cstring = [self UTF8String];
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(cstring, (CC_LONG)strlen(cstring), result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

- (NSString *)sha224 {
    const char *cstring = [self UTF8String];
    unsigned char result[CC_SHA224_DIGEST_LENGTH];
    CC_SHA1(cstring, (CC_LONG)strlen(cstring), result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA224_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA224_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

- (NSString *)sha256 {
    const char *cstring = [self UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA1(cstring, (CC_LONG)strlen(cstring), result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

- (NSString *)sha384 {
    const char *cstring = [self UTF8String];
    unsigned char result[CC_SHA384_DIGEST_LENGTH];
    CC_SHA1(cstring, (CC_LONG)strlen(cstring), result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA384_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA384_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

- (NSString *)sha512 {
    const char *cstring = [self UTF8String];
    unsigned char result[CC_SHA512_DIGEST_LENGTH];
    CC_SHA1(cstring, (CC_LONG)strlen(cstring), result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

#pragma mark - NSData

/**
 *  UTF8StringEncoding编码转换成Data
 */
- (NSData *)dataUsingUTF8StringEncoding {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - NSDate

/**
 *  获取当前的日期，格式为：yyyy-MM-dd HH:mm:ss
 */
+ (NSString *)dateString {
    return [NSDate date].string;
}

+ (NSString *)dateStringWithFormat:(NSString *)format {
    return [[NSDate date] stringWithFormat:format];
}

#pragma mark - UI Size

/**
 根据字体大小计算文本的Size
 @ MAXFLOAT 表示最大的浮点数
 */
- (CGFloat)widthForFont:(UIFont *)font {
    return [self sizeForFont:font size:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
}

- (CGFloat)heightForFont:(UIFont *)font {
    return [self heightForFont:font width:MAXFLOAT];
}

- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width {
    return [self sizeForFont:font size:CGSizeMake(width, MAXFLOAT)].height;
}

- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size {
    return [self sizeForFont:font size:size mode:NSLineBreakByWordWrapping];
}

/**
 *  根据字体大小，所要显示的size，以及字段样式来计算文本的size
 *  上面四个方法，最终也是调用这个方法
 *  @param font          字体
 *  @param size          所要显示的size
 *  @param lineBreakMode 字段样式
 */
- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    if (!font) {
        font = [UIFont systemFontOfSize:15];
    }
    NSMutableDictionary *attr = [NSMutableDictionary new];
    attr[NSFontAttributeName] = font;
    if (lineBreakMode != NSLineBreakByWordWrapping) {
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineBreakMode = lineBreakMode;
        attr[NSParagraphStyleAttributeName] = paragraphStyle;
    }
    CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attr context:nil];
    return rect.size;
}

#pragma mark - 正则表达式

/**
 *  正则表达式
 *  @param format 正则表达式的样式
 *  @return YES or NO
 */
- (BOOL)evaluateWithFormat:(NSString *)format {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",format] ;
    return [predicate evaluateWithObject:self];
}

#pragma mark - 沙盒路径

+ (NSString *)pathDocument {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
}

+ (NSString *)pathCaches {
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES).firstObject;
}

+ (NSString *)pathLibrary {
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES).firstObject;
}

#pragma mark - 

+ (NSString *)stringWithUUID {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}

@end
