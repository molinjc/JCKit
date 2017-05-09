//
//  NSObject+JCModel.m
//  JCMVPDemo
//
//  Created by molin.JC on 2017/4/21.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "NSObject+JCModel.h"
#import "JCClassInfo.h"
#import <libkern/OSAtomic.h>
#import <objc/message.h>

#pragma mark - _JCModelPropertyMeta

@interface _JCModelPropertyMeta : NSObject {
    @public
    SEL _setter;
    SEL _getter;
    NSString * _name;
    NSString * _mappedToKey;     /** 关联的字段 */
    NSArray  * _mappedToKeyPath; /** 关联的字段路径 */
    BOOL _isCNumber;
    JCEncodingNSType _nsType;
    JCEncodingType _type;
    JCClassPropertyInfo * _info;
    Class _propertyClass;
    Class _arrayClass;
    Class _metaClass;
}

@end

@implementation _JCModelPropertyMeta

+ (instancetype)metaWithPropertyInfo:(JCClassPropertyInfo *)info {
    _JCModelPropertyMeta *meta = [self new];
    meta -> _setter = NSSelectorFromString(info.setter);
    meta -> _getter = NSSelectorFromString(info.getter);
    meta -> _name = info.name;
    meta -> _isCNumber = info.isCNumber;
    meta -> _nsType = info.nsType;
    meta -> _type = info.type;
    meta -> _propertyClass = info.cls;
    return meta;
}

@end

#pragma mark - _JCModelMeta

/** model的信息类 */
@interface _JCModelMeta : NSObject {
    @public
    JCClassInfo  *   _classInfo;
    NSDictionary *   _mapper;
    NSArray      *   _allPropertyMetas;
    NSUInteger       _keyMappedCount;
    JCEncodingNSType _nsType;
}

@end

@implementation _JCModelMeta

- (instancetype)initWithClass:(Class)cls {
    JCClassInfo *info = [JCClassInfo classInfoWithClass:cls];
    if (!info) {
        return nil;
    }
    
    if (self = [super init]) {
        NSMutableDictionary *allPropertyMetas = [NSMutableDictionary new];
        JCClassInfo *curClassInfo = info;
        
        while (curClassInfo && curClassInfo.superCls != nil) {
            for (JCClassPropertyInfo *propertyInfo in curClassInfo.propertyInfos.allValues) {
                if (!propertyInfo.name) {
                    continue;
                }
                
                _JCModelPropertyMeta *meta = [_JCModelPropertyMeta metaWithPropertyInfo:propertyInfo];
                
                if (!meta -> _setter || !meta -> _getter) {
                    continue;
                }
                if (allPropertyMetas[meta -> _name]) {
                    continue;
                }
                
                allPropertyMetas[meta -> _name] = meta;
            }
            curClassInfo = curClassInfo.superClassInfo;
        }
        
        if (allPropertyMetas.count) {
            _allPropertyMetas = allPropertyMetas.allValues.copy;
        }
        
        NSMutableDictionary *mapper = [NSMutableDictionary new];

        if ([cls respondsToSelector:@selector(modelArrayRelation)]) {
            NSDictionary *relationMapper = [(id <JCModel>)cls modelArrayRelation];
            [relationMapper enumerateKeysAndObjectsUsingBlock:^(NSString *propertyName, id obj, BOOL *stop) {
                if ([propertyName isKindOfClass:[NSString class]] && propertyName) {
                    _JCModelPropertyMeta *propertyMeta = allPropertyMetas[propertyName];
                    if ([obj isKindOfClass:[NSString class]]) {
                        Class cls = NSClassFromString(obj);
                        if (cls) {
                            propertyMeta -> _arrayClass = cls;
                        }
                    }else {
                        Class cls = obj;
                        if (cls) {
                            propertyMeta -> _arrayClass = cls;
                        }
                    }
                }
            }];
        }
        
        if ([cls respondsToSelector:@selector(modelFieldRelation)]) {
            NSDictionary *relationMapper = [(id <JCModel>)cls modelFieldRelation];
            [relationMapper enumerateKeysAndObjectsUsingBlock:^(NSString *propertyName, NSString *mappedToKey, BOOL *stop) {
                _JCModelPropertyMeta *propertyMeta = allPropertyMetas[propertyName];
                if (propertyMeta) {
                    NSArray *keyPath = [mappedToKey componentsSeparatedByString:@"."];
                    if (keyPath.count > 1) {
                        propertyMeta -> _mappedToKeyPath = keyPath;
                        propertyMeta -> _mappedToKey = keyPath.firstObject;
                        mapper[keyPath.firstObject] = propertyMeta;
                    }else {
                        propertyMeta -> _mappedToKey = mappedToKey;
                        mapper[mappedToKey] = propertyMeta;
                    }
                    
                    [allPropertyMetas removeObjectForKey:propertyName];
                }
            }];
        }
        
        [allPropertyMetas enumerateKeysAndObjectsUsingBlock:^(NSString *name, _JCModelPropertyMeta *meta, BOOL *stop) {
            meta -> _metaClass = cls;
            meta -> _mappedToKey = name;
            mapper[name] = meta;
        }];
        
        if (mapper.count) {
            _mapper = mapper;
        }
        
        _classInfo = info;
        _keyMappedCount = _allPropertyMetas.count;
    }
    return self;
}

+ (instancetype)metaWithClass:(Class)cls {
    if (!cls) return nil;
    static CFMutableDictionaryRef cache;
    static dispatch_once_t onceToken;
    static OSSpinLock lock;
    dispatch_once(&onceToken, ^{
        cache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        lock = OS_SPINLOCK_INIT;
    });
    OSSpinLockLock(&lock);
    _JCModelMeta *meta = CFDictionaryGetValue(cache, (__bridge const void *)(cls));
    OSSpinLockUnlock(&lock);
    if (!meta) {
        meta = [[_JCModelMeta alloc] initWithClass:cls];
        if (meta) {
            OSSpinLockLock(&lock);
            CFDictionarySetValue(cache, (__bridge const void *)(cls), (__bridge const void *)(meta));
            OSSpinLockUnlock(&lock);
        }
    }
    return meta;
}

@end

#pragma mark - inline

/** runtime发送信息(调用方法) */
static inline void messageSend(__unsafe_unretained id model,  SEL setter, id value){
    if (setter) {
        ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, setter, value);
    }
}

/** 获取NSBlock class */
static inline Class JCNSBlockClass() {
    static Class cls;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        void (^block)(void) = ^{};
        cls = ((NSObject *)block).class;
        while (class_getSuperclass(cls) != [NSObject class]) {
            cls = class_getSuperclass(cls);
        }
    });
    return cls; // current is "NSBlock"
}

#pragma mark - Handle

static inline NSNumber *JCNSNumberCreateFromID(__unsafe_unretained id value) {
    static NSCharacterSet *dot;
    static NSDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dot = [NSCharacterSet characterSetWithRange:NSMakeRange('.', 1)];
        dic = @{@"TRUE" :   @(YES),
                @"True" :   @(YES),
                @"true" :   @(YES),
                @"FALSE" :  @(NO),
                @"False" :  @(NO),
                @"false" :  @(NO),
                @"YES" :    @(YES),
                @"Yes" :    @(YES),
                @"yes" :    @(YES),
                @"NO" :     @(NO),
                @"No" :     @(NO),
                @"no" :     @(NO),
                @"NIL" :    (id)kCFNull,
                @"Nil" :    (id)kCFNull,
                @"nil" :    (id)kCFNull,
                @"NULL" :   (id)kCFNull,
                @"Null" :   (id)kCFNull,
                @"null" :   (id)kCFNull,
                @"(NULL)" : (id)kCFNull,
                @"(Null)" : (id)kCFNull,
                @"(null)" : (id)kCFNull,
                @"<NULL>" : (id)kCFNull,
                @"<Null>" : (id)kCFNull,
                @"<null>" : (id)kCFNull};
    });
    
    if (!value || value == (id)kCFNull) return nil;
    if ([value isKindOfClass:[NSNumber class]]) return value;
    if ([value isKindOfClass:[NSString class]]) {
        NSNumber *num = dic[value];
        if (num) {
            if (num == (id)kCFNull) return nil;
            return num;
        }
        if ([(NSString *)value rangeOfCharacterFromSet:dot].location != NSNotFound) {
            const char *cstring = ((NSString *)value).UTF8String;
            if (!cstring) return nil;
            double num = atof(cstring);
            if (isnan(num) || isinf(num)) return nil;
            return @(num);
        } else {
            const char *cstring = ((NSString *)value).UTF8String;
            if (!cstring) return nil;
            return @(atoll(cstring));
        }
    }
    return nil;
}

/** 处理数据类型 */
static inline void JCModelSetNumberToProperty(__unsafe_unretained id model,
                                                  __unsafe_unretained NSNumber *num,
                                            __unsafe_unretained _JCModelPropertyMeta *meta) {
    switch (meta -> _type & JCEncodingTypeMask) {
        case JCEncodingTypeBool: {
             ((void (*)(id, SEL, bool))(void *) objc_msgSend)((id)model, meta->_setter, num.boolValue);
        } break;
        case JCEncodingTypeInt8: {
            ((void (*)(id, SEL, int8_t))(void *) objc_msgSend)((id)model, meta->_setter, (int8_t)num.charValue);
        }
        case JCEncodingTypeUInt8: {
            ((void (*)(id, SEL, uint8_t))(void *) objc_msgSend)((id)model, meta->_setter, (uint8_t)num.unsignedCharValue);
        } break;
        case JCEncodingTypeInt16: {
            ((void (*)(id, SEL, int16_t))(void *) objc_msgSend)((id)model, meta->_setter, (int16_t)num.shortValue);
        } break;
        case JCEncodingTypeUInt16: {
            ((void (*)(id, SEL, uint16_t))(void *) objc_msgSend)((id)model, meta->_setter, (uint16_t)num.unsignedShortValue);
        } break;
        case JCEncodingTypeInt32: {
            ((void (*)(id, SEL, int32_t))(void *) objc_msgSend)((id)model, meta->_setter, (int32_t)num.intValue);
        }
        case JCEncodingTypeUInt32: {
            ((void (*)(id, SEL, uint32_t))(void *) objc_msgSend)((id)model, meta->_setter, (uint32_t)num.unsignedIntValue);
        } break;
        case JCEncodingTypeInt64: {
            if ([num isKindOfClass:[NSDecimalNumber class]]) {
                ((void (*)(id, SEL, int64_t))(void *) objc_msgSend)((id)model, meta->_setter, (int64_t)num.stringValue.longLongValue);
            } else {
                ((void (*)(id, SEL, uint64_t))(void *) objc_msgSend)((id)model, meta->_setter, (uint64_t)num.longLongValue);
            }
        } break;
        case JCEncodingTypeUInt64: {
            if ([num isKindOfClass:[NSDecimalNumber class]]) {
                ((void (*)(id, SEL, int64_t))(void *) objc_msgSend)((id)model, meta->_setter, (int64_t)num.stringValue.longLongValue);
            } else {
                ((void (*)(id, SEL, uint64_t))(void *) objc_msgSend)((id)model, meta->_setter, (uint64_t)num.unsignedLongLongValue);
            }
        } break;
        case JCEncodingTypeFloat: {
            float f = num.floatValue;
            if (isnan(f) || isinf(f)) f = 0;
            ((void (*)(id, SEL, float))(void *) objc_msgSend)((id)model, meta->_setter, f);
        } break;
        case JCEncodingTypeDouble: {
            double d = num.doubleValue;
            if (isnan(d) || isinf(d)) d = 0;
            ((void (*)(id, SEL, double))(void *) objc_msgSend)((id)model, meta->_setter, d);
        } break;
        case JCEncodingTypeLongDouble: {
            long double d = num.doubleValue;
            if (isnan(d) || isinf(d)) d = 0;
            ((void (*)(id, SEL, long double))(void *) objc_msgSend)((id)model, meta->_setter, (long double)d);
        } break;
        default: break;
    }
}

/** 处理类型要为字符串 */
static NSString * JCStringHandle(__unsafe_unretained id value) {
    if ([value isKindOfClass:[NSNumber class]]) {
        return ((NSNumber *)value).stringValue;
    }
    if ([value isKindOfClass:[NSData class]]) {
         NSMutableString *string = [[NSMutableString alloc] initWithData:value encoding:NSUTF8StringEncoding];
        return string;
    }
    if ([value isKindOfClass:[NSURL class]]) {
        return ((NSURL *)value).absoluteString;
    }
    if ([value isKindOfClass:[NSAttributedString class]]) {
        return ((NSAttributedString *)value).string;
    }else if ([value isKindOfClass:[NSString class]]) {
        return value;
    }
    return (id)nil;
}

/** 处理类型为NSDecimalNumber的数据 */
static NSDecimalNumber *JCDecimalNumberHandle(__unsafe_unretained id value) {
    if ([value isKindOfClass:[NSDecimalNumber class]]) {
        return value;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
         return [NSDecimalNumber decimalNumberWithDecimal:[((NSNumber *)value) decimalValue]];
    }
    if ([value isKindOfClass:[NSString class]]) {
        NSDecimalNumber *decNum = [NSDecimalNumber decimalNumberWithString:value];
        NSDecimal dec = decNum.decimalValue;
        if (dec._length == 0 && dec._isNegative) {
            decNum = nil; // NaN
        }
        return decNum;
    }
    return (id)nil;
}

/** 处理类型为NSData的数据 */
static NSData *JCDataHandle(__unsafe_unretained id value) {
    if ([value isKindOfClass:[NSDate class]]) {
        return value;
    }
    if ([value isKindOfClass:[NSString class]]) {
        return [(NSString *)value dataUsingEncoding:NSUTF8StringEncoding];
    }
    if ([value isKindOfClass:[NSDictionary class]]) {
        return  [NSJSONSerialization dataWithJSONObject:(NSDictionary *)value options:NSJSONWritingPrettyPrinted error:nil];
    }
    return (id)nil;
}

/** 处理类型为NSDate的数据 */
static NSDate *JCDateHandle(__unsafe_unretained id value) {
    if ([value isKindOfClass:[NSDate class]]) {
        return value;
    }
    if ([value isKindOfClass:[NSString class]]) {
        NSString *string = (NSString *)value;
        typedef NSDate* (^JCNSDateParseBlock)(NSString *string);
        #define kParserNum 32
        static JCNSDateParseBlock blocks[kParserNum + 1] = {0};
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            {
                /*
                 2014-01-20  // Google
                 */
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                formatter.dateFormat = @"yyyy-MM-dd";
                blocks[10] = ^(NSString *string) { return [formatter dateFromString:string]; };
            }
            
            {
                /*
                 2014-01-20 12:24:48
                 2014-01-20T12:24:48   // Google
                 */
                NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
                formatter1.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                formatter1.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                formatter1.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
                
                NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
                formatter2.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                formatter2.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                formatter2.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                
                blocks[19] = ^(NSString *string) {
                    if ([string characterAtIndex:10] == 'T') {
                        return [formatter1 dateFromString:string];
                    } else {
                        time_t t = 0;
                        struct tm tm = {0};
                        strptime([string cStringUsingEncoding:NSUTF8StringEncoding], "%Y-%m-%d %H:%M:%S", &tm);
                        tm.tm_isdst = -1;
                        t = mktime(&tm);
                        if (t >= 0) {
                            NSDate *date = [NSDate dateWithTimeIntervalSince1970:t + [[NSTimeZone localTimeZone] secondsFromGMT]];
                            if (date) return date;
                        }
                        return [formatter2 dateFromString:string];
                    }
                };
            }
            
            {
                /*
                 2014-01-20T12:24:48Z        // Github, Apple
                 2014-01-20T12:24:48+0800    // Facebook
                 2014-01-20T12:24:48+12:00   // Google
                 */
                NSDateFormatter *formatter = [NSDateFormatter new];
                formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
                blocks[20] = ^(NSString *string) {
                    time_t t = 0;
                    struct tm tm = {0};
                    strptime([string cStringUsingEncoding:NSUTF8StringEncoding], "%Y-%m-%dT%H:%M:%S%z", &tm);
                    tm.tm_isdst = -1;
                    t = mktime(&tm);
                    if (t >= 0) {
                        NSDate *date = [NSDate dateWithTimeIntervalSince1970:t + [[NSTimeZone localTimeZone] secondsFromGMT]];
                        if (date) return date;
                    }
                    return [formatter dateFromString:string];
                };
                blocks[24] = ^(NSString *string) { return [formatter dateFromString:string]; };
                blocks[25] = ^(NSString *string) { return [formatter dateFromString:string]; };
            }
            
            {
                /*
                 Fri Sep 04 00:12:21 +0800 2015 // Weibo, Twitter
                 */
                NSDateFormatter *formatter = [NSDateFormatter new];
                formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                formatter.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
                blocks[30] = ^(NSString *string) { return [formatter dateFromString:string]; };
            }
        });
        if (!string) return nil;
        if (string.length > kParserNum) return nil;
        JCNSDateParseBlock parser = blocks[string.length];
        if (!parser) return nil;
        return parser(string);
        #undef kParserNum
    }
    return (id)nil;
}

/** 处理NSURL */
static NSURL *JCURLHandle(__unsafe_unretained id value) {
    if ([value isKindOfClass:[NSURL class]]) {
        return value;
    }
    if ([value isKindOfClass:[NSString class]]) {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *str = [value stringByTrimmingCharactersInSet:set];
        if (str.length == 0) {
            return nil;
        }else {
            return [[NSURL alloc] initWithString:str];
        }
    }
    return nil;
}

/** 处理数组, 这里要注意两个方法:modelArrayRelation和modelArrayMultiRelationForDictionary: */
static NSArray *JCArrayHandle(__unsafe_unretained id value, _JCModelPropertyMeta *meta) {
    NSArray *array = nil;
    if ([value isKindOfClass:[NSArray class]]) {
        array = value;
    }else if ([value isKindOfClass:[NSSet class]]) {
        array = ((NSSet *)value).allObjects;
    }
    
    if (meta -> _arrayClass) {
        NSMutableArray *objectArr = [NSMutableArray new];
        for (id _value in array) {
            if ([_value isKindOfClass:meta -> _arrayClass]) {
                [objectArr addObject:_value];
            }else {
                NSDictionary *dic = nil;
                if ([_value isKindOfClass:[NSDictionary class]]) {
                    dic = (NSDictionary *)_value;
                }else if ([_value isKindOfClass:[NSString class]]) {
                    dic = [NSDictionary dictionaryWithJSON:_value];
                }
                Class cls = meta -> _arrayClass;
                if (dic && cls) {
                    NSObject *one = [cls new];
                    [one modelSetWithDictionary:_value];
                    [objectArr addObject:one];
                }
            }
        }
        
        if (objectArr.count) {
            array = objectArr.mutableCopy;
        }
    } else {
        Class cls = meta -> _metaClass;
        if (cls && [cls respondsToSelector:@selector(modelArrayMultiRelationForDictionary:)]) {
            NSMutableArray *objectArr = [NSMutableArray new];
            for (id _value in array) {
                if ([_value isKindOfClass:[NSDictionary class]]) {
                    NSObject *one = [[(id <JCModel>)cls modelArrayMultiRelationForDictionary:_value] new];
                    [one modelSetWithDictionary:_value];
                    one ? [objectArr addObject:one] : nil;
                }else {
                    [objectArr addObject:_value];
                }
            }
            if (objectArr.count) {
                array = objectArr.mutableCopy;
            }
        }
    }
    
    return array;
}

/** 处理NSDictionary, 这里要注意modelDictionaryRelationForKey:方法 */
static NSDictionary *JCDictionaryHandle(__unsafe_unretained id value, _JCModelPropertyMeta *meta) {
    NSDictionary *dic = nil;
    if ([value isKindOfClass:[NSDictionary class]]) {
        dic = value;
    }else if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSData class]]) {
        dic = [NSObject dictionaryWithJSON:value];
    }
    
    Class cls = meta -> _metaClass;
    if (cls && [cls respondsToSelector:@selector(modelDictionaryRelationForKey:)]) {
        NSMutableDictionary *newDic = [NSMutableDictionary new];
        
        [dic enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
            NSObject *one = [[(id <JCModel>)cls modelDictionaryRelationForKey:key] new];
            if (one && [obj isKindOfClass:[NSDictionary class]]) {
                [one modelSetWithDictionary:obj];
                newDic[key] = one;
            }else {
                newDic[key] = obj;
            }
        }];
        
        if (newDic.count) {
            dic = newDic;
        }
    }
    
    return dic;
}
/** 处理NSSet, 若元素是字典类型就解析, 其他类型直接添加到Set里 */
static NSSet *JCSetHandle(__unsafe_unretained id value, _JCModelPropertyMeta *meta) {
    NSSet *set = nil;
    if ([value isKindOfClass:[NSArray class]]) {
        set = [NSMutableSet setWithArray:value];
    }else if ([value isKindOfClass:[NSSet class]]) {
        set = value;
    }
    
    Class cls = meta -> _metaClass;
    if (cls) {
        NSMutableSet *setM = [NSMutableSet new];
        for (id _v in set) {
            if ([_v isKindOfClass:[NSDictionary class]]) {
                if ([cls respondsToSelector:@selector(modelArrayMultiRelationForDictionary:)]) {
                    NSObject *one = [[(id <JCModel>)cls modelArrayMultiRelationForDictionary:_v] new];
                    [one modelSetWithDictionary:_v];
                    one ? [setM addObject:one] : nil ;
                }else {
                    [setM addObject:_v];
                }
            }else {
                [setM addObject:_v];
            }
        }
        
        if (setM.count) {
            set = setM;
        }
    }
    
    return set;
}
/** 处理JCEncodingTypeObject */
static void JCTypeObjectHandel(__unsafe_unretained id _value, _JCModelPropertyMeta *meta, __unsafe_unretained id model) {
    id value = nil;
    if ([_value isKindOfClass:meta-> _propertyClass]) {
        value = _value;
    }else if ([_value isKindOfClass:[NSDictionary class]]) {
        NSObject *one = nil;
        if (meta -> _getter) {
            one = ((id (*)(id, SEL))(void *) objc_msgSend)((id)model, meta->_getter);
        }
        if (one) {
            [one modelSetWithDictionary:_value];
        }else {
            Class cls = meta -> _propertyClass;
            one = [cls new];
            [one modelSetWithDictionary:_value];
            value = one;
        }
    }
    messageSend(model, meta->_setter, value);
}

/** 处理JCEncodingTypeClass */
static void JCTypeClassHandle(__unsafe_unretained id value, _JCModelPropertyMeta *meta, __unsafe_unretained id model) {
    if (value == (id)kCFNull) {
        ((void (*)(id, SEL, Class))(void *) objc_msgSend)((id)model, meta->_setter, (Class)NULL);
    } else {
        Class cls = nil;
        if ([value isKindOfClass:[NSString class]]) {
            cls = NSClassFromString(value);
            if (cls) {
                ((void (*)(id, SEL, Class))(void *) objc_msgSend)((id)model, meta->_setter, (Class)cls);
            }
        } else {
            cls = object_getClass(value);
            if (cls) {
                if (class_isMetaClass(cls)) {
                    ((void (*)(id, SEL, Class))(void *) objc_msgSend)((id)model, meta->_setter, (Class)value);
                } else {
                    ((void (*)(id, SEL, Class))(void *) objc_msgSend)((id)model, meta->_setter, (Class)cls);
                }
            }
        }
    }
}

/** 处理JCEncodingTypeSEL */
static void JCTypeSELHandle(__unsafe_unretained id value, _JCModelPropertyMeta *meta, __unsafe_unretained id model) {
    if (value == (id)kCFNull) {
        ((void (*)(id, SEL, SEL))(void *) objc_msgSend)((id)model, meta->_setter, (SEL)NULL);
    } else if ([value isKindOfClass:[NSString class]]) {
        SEL sel = NSSelectorFromString(value);
        if (sel) ((void (*)(id, SEL, SEL))(void *) objc_msgSend)((id)model, meta->_setter, (SEL)sel);
    }
}

/** 处理JCEncodingTypeBlock */
static void JCTypeBlockHandle(__unsafe_unretained id value, _JCModelPropertyMeta *meta, __unsafe_unretained id model) {
    if (value == (id)kCFNull) {
        ((void (*)(id, SEL, void (^)()))(void *) objc_msgSend)((id)model, meta->_setter, (void (^)())NULL);
    } else if ([value isKindOfClass:JCNSBlockClass()]) {
        ((void (*)(id, SEL, void (^)()))(void *) objc_msgSend)((id)model, meta->_setter, (void (^)())value);
    }

}

/** 处理JCEncodingTypeStruct、JCEncodingTypeUnion、JCEncodingTypeCArray */
static void JCTypeValueHandle(__unsafe_unretained id value, _JCModelPropertyMeta *meta, __unsafe_unretained id model) {
    if ([value isKindOfClass:[NSValue class]]) {
        const char *valueType = ((NSValue *)value).objCType;
        const char *metaType = meta->_info.typeEncoding.UTF8String;
        if (valueType && metaType && strcmp(valueType, metaType) == 0) {
            [model setValue:value forKey:meta->_name];
        }
    }
}

/** 处理JCEncodingTypePointer、JCEncodingTypeCString */
static void JCTypePointerHandle(__unsafe_unretained id value, _JCModelPropertyMeta *meta, __unsafe_unretained id model) {
    if (value == (id)kCFNull) {
        ((void (*)(id, SEL, void *))(void *) objc_msgSend)((id)model, meta->_setter, (void *)NULL);
    } else if ([value isKindOfClass:[NSValue class]]) {
        NSValue *nsValue = value;
        if (nsValue.objCType && strcmp(nsValue.objCType, "^v") == 0) {
            ((void (*)(id, SEL, void *))(void *) objc_msgSend)((id)model, meta->_setter, nsValue.pointerValue);
        }
    }
}

/** 从路径获取value */
static id JCValueForKeyPath(__unsafe_unretained id _value, NSArray *keyPath) {
    if ([_value isKindOfClass:[NSDictionary class]]) {
        id value = nil;
        NSDictionary *dic = _value;
        
        for (NSUInteger i = 1, max = keyPath.count; i < max; i++) {
            value = dic[keyPath[i]];
            if (i + 1 < max) {
                if ([value isKindOfClass:[NSDictionary class]]) {
                    dic = value;
                } else {
                    return nil;
                }
            }
        }
        return value;
    }
    return nil;
}

#pragma mark - Set

typedef struct {
    void *modelMeta;  ///< _JCModelMeta
    void *model;      ///< id (self)
    void *dictionary; ///< NSDictionary (json)
} JCModelSetContext;

static void JCModelSetValueForProperty(__unsafe_unretained id model, __unsafe_unretained id _value, __unsafe_unretained _JCModelPropertyMeta *meta) {
    if (meta -> _isCNumber) {
        NSNumber *num = JCNSNumberCreateFromID(_value);
        JCModelSetNumberToProperty(model, num, meta);
    }else {
        if (meta -> _nsType) {
            id value = nil;
            
            switch (meta -> _nsType) {
                case JCEncodingTypeNSString: {
                    value = JCStringHandle(_value);
                } break;
                case JCEncodingTypeNSMutableString: {
                    value = JCStringHandle(_value).mutableCopy;
                } break;
                case JCEncodingTypeNSValue: {
                    value = _value;
                } break;
                case JCEncodingTypeNSNumber: {
                    value = JCNSNumberCreateFromID(_value);
                } break;
                case JCEncodingTypeNSDecimalNumber: {
                    value = JCDecimalNumberHandle(_value);
                } break;
                case JCEncodingTypeNSData: {
                    value = JCDataHandle(_value);
                } break;
                case JCEncodingTypeNSMutableData: {
                    value = JCDataHandle(_value).mutableCopy;
                } break;
                case JCEncodingTypeNSDate: {
                    value = JCDateHandle(_value);
                } break;
                case JCEncodingTypeNSURL: {
                    value = JCURLHandle(_value);
                } break;
                case JCEncodingTypeNSArray: {
                    value = JCArrayHandle(_value, meta);
                } break;
                case JCEncodingTypeNSMutableArray: {
                    value = JCArrayHandle(_value, meta).mutableCopy;
                } break;
                case JCEncodingTypeNSDictionary: {
                    value = JCDictionaryHandle(_value, meta);
                } break;
                case JCEncodingTypeNSMutableDictionary: {
                    value = JCDictionaryHandle(_value, meta).mutableCopy;
                } break;
                case JCEncodingTypeNSSet: {
                    value = JCSetHandle(_value, meta);
                } break;
                case JCEncodingTypeNSMutableSet: {
                    value = JCSetHandle(_value, meta).mutableCopy;
                } break;
                default: break;
            }
            
            messageSend(model, meta->_setter, value);
            
        }else {
            switch (meta -> _type & JCEncodingTypeMask) {
                case JCEncodingTypeObject: {
                    JCTypeObjectHandel(_value, meta, model);
                } break;
                case JCEncodingTypeClass: {
                    JCTypeClassHandle(_value, meta, model);
                } break;
                case JCEncodingTypeSEL: {
                    JCTypeSELHandle(_value, meta, model);
                } break;
                case JCEncodingTypeBlock: {
                    JCTypeBlockHandle(_value, meta, model);
                } break;
                case JCEncodingTypeStruct:
                case JCEncodingTypeUnion:
                case JCEncodingTypeCArray: {
                    JCTypeValueHandle(_value, meta, model);
                } break;
                case JCEncodingTypePointer:
                case JCEncodingTypeCString: {
                    JCTypePointerHandle(_value, meta, model);
                } break;
                default: break;
            }
        }
    }
}

static void JCModelSetWithDictionaryFunction(const void *_key, const void *_value, void *_context) {
    JCModelSetContext *context = _context;
    __unsafe_unretained _JCModelMeta *_modelMeta = (__bridge _JCModelMeta *)(context -> modelMeta);
    __unsafe_unretained _JCModelPropertyMeta *propertyMeta = [_modelMeta -> _mapper objectForKey:(__bridge id)(_key)];
    __unsafe_unretained id model = (__bridge id)(context -> model);
    if (!propertyMeta -> _mappedToKeyPath) {
        NSLog(@"_key:%@, _value:%@, propertyMeta -> _setter:%@, model:%@", _key, _value, NSStringFromSelector(propertyMeta -> _setter), [model class]);
        JCModelSetValueForProperty(model, (__bridge __unsafe_unretained id)_value, propertyMeta);
    }else {
        id v = JCValueForKeyPath((__bridge id)(_value), propertyMeta -> _mappedToKeyPath);
        JCModelSetValueForProperty(model, v , propertyMeta);
    }
}

static void JCModelSetWithPropertyMetaArrayFunction(const void *_propertyMeta, void *_context) {
    JCModelSetContext *context = _context;
    __unsafe_unretained NSDictionary *dictionary = (__bridge NSDictionary *)(context -> dictionary);
    __unsafe_unretained _JCModelPropertyMeta *propertyMeta = (__bridge _JCModelPropertyMeta *)(_propertyMeta);
    if (!propertyMeta -> _setter) {
        return;
    }
    
    id value = [dictionary objectForKey:propertyMeta -> _mappedToKey];;
    if (value) {
        if (propertyMeta -> _mappedToKeyPath) {
            value = JCValueForKeyPath(value, propertyMeta -> _mappedToKeyPath);
        }
        __unsafe_unretained id model = (__bridge id)(context -> model);
        JCModelSetValueForProperty(model, value, propertyMeta);
    }
}

#pragma mark - Model

@implementation NSObject (JCModel)

#pragma mark - 使用系统方法

+ (instancetype)setValuesForKeysWithJSON:(id)json {
    NSDictionary *dic = [self dictionaryWithJSON:json];
    NSObject *model = [[self class] new];
    @try {
        [model setValuesForKeysWithDictionary:dic];
    } @catch (NSException *exception) {
        
    }
    return model;
}

#pragma mark - Model解析

+ (NSDictionary *)dictionaryWithJSON:(id)json {
    if (!json || json == (id)kCFNull) return nil;
    NSDictionary *dic = nil;
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        dic = json;
    } else if ([json isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)json dataUsingEncoding : NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    if (jsonData) {
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if (![dic isKindOfClass:[NSDictionary class]]) dic = nil;
    }
    return dic;
}

+ (instancetype)modelWithJSON:(id)json {
    NSDictionary *dic = [self dictionaryWithJSON:json];
    return [self modelWithDictionary:dic];
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    Class cls = [self class];
    NSObject *one = [cls new];
    [one modelSetWithDictionary:dictionary];
    return one;
}

- (void)modelSetWithDictionary:(NSDictionary *)dictionary {
    if (!dictionary || dictionary == (id)kCFNull) {
        return;
    }
    
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    _JCModelMeta *meta = [_JCModelMeta metaWithClass:object_getClass(self)];
    if (meta -> _keyMappedCount == 0) {
        return;
    }
    
    JCModelSetContext context = {0};
    context.modelMeta = (__bridge void *)(meta);
    context.model = (__bridge void *)(self);
    context.dictionary = (__bridge void *)(dictionary);
    
    if (meta ->_keyMappedCount >= CFDictionaryGetCount((CFDictionaryRef)dictionary)) {
        CFDictionaryApplyFunction((CFDictionaryRef)dictionary, JCModelSetWithDictionaryFunction, &context);
    }else {
        CFArrayApplyFunction((CFArrayRef)meta -> _allPropertyMetas,  CFRangeMake(0, meta -> _keyMappedCount), JCModelSetWithPropertyMetaArrayFunction, &context);
    }
}

@end

#pragma mark - NSArray Category

@implementation NSArray (JCModel)

+ (NSArray *)arrayWithModelClass:(Class)cls JSON:(id)json {
    if (!json) {
        return nil;
    }
    NSArray *array = nil;
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSArray class]]) {
        array = json;
    }else if ([json isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)json dataUsingEncoding:NSUTF8StringEncoding];
    }else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    
    if (jsonData) {
        array = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if (![array isKindOfClass:[NSArray class]]) {
            array = nil;
        }
    }
    
    return [self arrayWithModelClass:cls array:array];
}

+ (NSArray *)arrayWithModelClass:(Class)cls array:(NSArray *)array {
    if (!cls || !array) {
        return nil;
    }
    NSMutableArray *result = [NSMutableArray new];
    for (NSDictionary *dic in array) {
        if (![dic isKindOfClass:[NSDictionary class]]) continue;
        NSObject *obj = [cls modelWithDictionary:dic];
        if (obj) [result addObject:obj];
    }
    return result;
}

@end

#pragma mark - NSDictionary Category

@implementation NSDictionary (JCModel)

+ (NSDictionary *)dictionaryWithModelClass:(Class)cls JSON:(id)json {
    if (!json) return nil;
    NSDictionary *dic = nil;
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        dic = json;
    } else if ([json isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)json dataUsingEncoding : NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    if (jsonData) {
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if (![dic isKindOfClass:[NSDictionary class]]) dic = nil;
    }
    return [self dictionaryWithModelClass:cls dictionary:dic];
}

+ (NSDictionary *)dictionaryWithModelClass:(Class)cls dictionary:(NSDictionary *)dic {
    if (!cls || !dic) return nil;
    NSMutableDictionary *result = [NSMutableDictionary new];
    for (NSString *key in dic.allKeys) {
        if (![key isKindOfClass:[NSString class]]) continue;
        NSObject *obj = [cls modelWithDictionary:dic[key]];
        if (obj) result[key] = obj;
    }
    return result;
}

@end
