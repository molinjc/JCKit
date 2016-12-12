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

#pragma mark - 修剪字符串

/**
 去掉头尾的空格
 */
- (NSString *)stringByTrimSpace {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

/**
 替换掉某个字符串
 */
- (NSString *)stringReplacement:(NSString *)replacement target:(NSString *)target , ... {
    if (!replacement) {
        return nil;
    }
    if (!target) {
        return nil;
    }
    NSString *complete = [self stringByReplacingOccurrencesOfString:target withString:replacement];
    va_list arglist;
    va_start(arglist, target);
    NSString *nextTarget;
    while ((nextTarget = va_arg(arglist, NSString *))) {
        complete = [complete stringByReplacingOccurrencesOfString:nextTarget withString:replacement];
    }
    va_end(arglist);
    return complete;
}

#pragma mark - 正则表达式

/**
 *  根据正则表达式判断
 *  @param format 正则表达式的样式
 *  @return YES or NO
 */
- (BOOL)evaluateWithFormat:(NSString *)format {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",format] ;
    return [predicate evaluateWithObject:self];
}

/**
 邮箱的正则表达式
 */
- (NSString *)regexpEmailFormat {
    return @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
}

/**
 IP地址的正则表达式
 */
- (NSString *)regexpIpFormat {
    return @"((2[0-4]\\\\d|25[0-5]|[01]?\\\\d\\\\d?)\\.){3}(2[0-4]\\\\d|25[0-5]|[01]?\\\\d\\\\d?)";
}

/**
 HTTP链接 (例如 http://www.baidu.com )
 */
- (NSString *)regexpHTTPFormat {
    return @"([hH]ttp[s]{0,1})://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\-~!@#$%^&*+?:_/=<>.\',;]*)?";
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

#pragma mark - UUID

+ (NSString *)stringWithUUID {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}

#pragma mark - ASCII码比较

/**
 根据每个字符的ASCII码总和相减来比较大小
 >0:self大; =0:相等(一样); <0:string大
 */
- (int)compareASCII:(NSString *)string {
    int ascii1 = self.stringASCIISum;
    int ascii2 = string.stringASCIISum;
    return ascii1 - ascii2;
}

/**
 字符串每个字符的ASCII码总和
 */
- (int)stringASCIISum {
    int sum = 0;
    for (int i=0; i<self.length; i++) {
        sum += [self characterAtIndex:i];
    }
    return sum;
}

#pragma mark - 字符串内容判断

/**
 判断字符串是否为空,为空的话返回 @""
 */
+ (NSString *)isNotNull:(id)string {
    if ([self isBlankString:string]){
        string = @"";
    }
    return string;
}

/**
 判断字符串是否为空字符的方法
 */
+ (BOOL)isBlankString:(id)string {
    NSString * str = (NSString*)string;
    if ([str isEqualToString:@"(null)"]) {
        return YES;
    }
    if (str == nil || str == NULL) {
        return YES;
    }
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

/**
 是否包含某字符串
 @param contain 被包含的字符串
 @return NO：没包含 YES：包含
 */
- (BOOL)containOfString:(NSString *)contain {
    return [self rangeOfString:contain].location != NSNotFound;
}

/**
 判断是否是为整数
 */
- (BOOL)isPureInteger {
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSInteger integerValue;
    return [scanner scanInteger:&integerValue] && [scanner isAtEnd];
}

/**
 判断是否为浮点数，可做小数判断
 */
- (BOOL)isPureFloat {
    NSScanner *scanner = [NSScanner scannerWithString:self];
    float floatValue;
    return [scanner scanFloat:&floatValue] && [scanner isAtEnd];
}

/**
 判断字符串内是否含有中文
 */
- (BOOL)isChinese {
    for (int i=0; i<self.length; i++) {
        unichar ch = [self characterAtIndex:i];
        if (0x4E00 <= ch && ch <= 0x9FA5) {
            return YES;
        }
    }
    return NO;
}

#pragma mark -  separate

/**
 从start处开始截取到end处结束，不包含start和end的字符串
 */
- (NSString *)separateStart:(NSString *)start end:(NSString *)end {
    if (self.length == 0) {
        return nil;
    }
    NSRange startRange = [self rangeOfString:start];
    NSRange endRange = [self rangeOfString:end];
    if (startRange.length && end.length) {
        NSRange separateRange = NSMakeRange(startRange.length + startRange.location, endRange.location - (startRange.length + startRange.location));
        return [self substringWithRange:separateRange];
    }
    return nil;
}

/**
 多次从start处开始截取到end处结束，不包含start和end的字符串
 @return 返回的是个数组
 */
- (NSArray *)multiSeparateStart:(NSString *)start end:(NSString *)end {
    NSMutableArray *array = @[].mutableCopy;
    NSString *separate = [self separateStart:start end:end];
    while (separate) {
        [array addObject:separate];
        [separate separateStart:start end:end];
    }
    return array;
}

#pragma mark - reverse

/**
 反转字符串
 */
- (NSString *)reverseString {
    NSMutableString *reverseString = [NSMutableString stringWithCapacity:self.length];
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        [reverseString appendString:substring];
    }];
    return reverseString;
}

#pragma mark - 转换

/**
 汉字转换成拼音
 */
- (NSString *)trans {
    NSMutableString *pinyin = self.mutableCopy;
    
    // 将汉字转换为拼音
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    
    // 去掉拼音的音标
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    return pinyin;
}

/**
 阿拉伯数字转中文格式
 */
- (NSString *)translation {
    if (self.length > 13) {
        return nil;
    }
    
    // 这里需要判断是不是全数字
    if (!self.isPureInteger) {
        return nil;
    }
    return [NSString stringFormatter:NSNumberFormatterSpellOutStyle number:[NSNumber numberWithInteger:[self integerValue]]];
}

/**
 驼峰转下划线（loveYou -> love_you）
 */
- (NSString *)underlineFromCamel {
    if (self.length == 0) return self;
    NSMutableString *string = [NSMutableString string];
    for (NSUInteger i = 0; i<self.length; i++) {
        unichar c = [self characterAtIndex:i];
        NSString *cString = [NSString stringWithFormat:@"%c", c];
        NSString *cStringLower = [cString lowercaseString];
        if ([cString isEqualToString:cStringLower]) {
            [string appendString:cStringLower];
        } else {
            [string appendString:@"_"];
            [string appendString:cStringLower];
        }
    }
    return string;
}

/**
 下划线转驼峰（love_you -> loveYou）
 */
- (NSString *)camelFromUnderline {
    if (self.length == 0) return self;
    NSMutableString *string = [NSMutableString string];
    NSArray *cmps = [self componentsSeparatedByString:@"_"];
    for (NSUInteger i = 0; i<cmps.count; i++) {
        NSString *cmp = cmps[i];
        if (i && cmp.length) {
            [string appendString:[NSString stringWithFormat:@"%c", [cmp characterAtIndex:0]].uppercaseString];
            if (cmp.length >= 2) [string appendString:[cmp substringFromIndex:1]];
        } else {
            [string appendString:cmp];
        }
    }
    return string;
}

/**
 首字母变大写
 */
- (NSString *)firstCharUpper {
    if (self.length == 0) return self;
    NSMutableString *string = [NSMutableString string];
    [string appendString:[NSString stringWithFormat:@"%c", [self characterAtIndex:0]].uppercaseString];
    if (self.length >= 2) [string appendString:[self substringFromIndex:1]];
    return string;
}

/**
 首字母变小写
 */
- (NSString *)firstCharLower {
    if (self.length == 0) return self;
    NSMutableString *string = [NSMutableString string];
    [string appendString:[NSString stringWithFormat:@"%c", [self characterAtIndex:0]].lowercaseString];
    if (self.length >= 2) [string appendString:[self substringFromIndex:1]];
    return string;
}

#pragma mark - 格式化

/**
 输出格式：123,456；每隔三个就有,
 */
+ (NSString *)stringFormatterWithDecimal:(NSNumber *)number {
    return [NSString stringFormatter:NSNumberFormatterDecimalStyle number:number];
}

/**
 number转换百分比： 12,345,600%
 */
+ (NSString *)stringFormatterWithPercent:(NSNumber *)number {
    return [NSString stringFormatter:NSNumberFormatterPercentStyle number:number];
}

/**
 设置NSNumber输出的格式
 @param style  格式
 @param number NSNumber数据
 */
+ (NSString *)stringFormatter:(NSNumberFormatterStyle)style number:(NSNumber *)number {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle  = style;
    return [formatter stringFromNumber:number];
}

@end
