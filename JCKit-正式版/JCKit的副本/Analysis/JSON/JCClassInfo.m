//
//  JCClassInfo.m
//  JCMVPDemo
//
//  Created by molin.JC on 2017/4/21.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCClassInfo.h"
#import <libkern/OSAtomic.h>

JCEncodingType JCEncodingGetType(const char *typeEncoding) {
    char *type = (char *)typeEncoding;
    if (!type) return JCEncodingTypeUnknown;
    size_t len = strlen(type);
    if (len == 0) return JCEncodingTypeUnknown;
    
    JCEncodingType qualifier = 0;
    bool prefix = true;
    while (prefix) {
        switch (*type) {
            case 'r': {
                qualifier |= JCEncodingTypeQualifierConst;
                type++;
            } break;
            case 'n': {
                qualifier |= JCEncodingTypeQualifierIn;
                type++;
            } break;
            case 'N': {
                qualifier |= JCEncodingTypeQualifierInout;
                type++;
            } break;
            case 'o': {
                qualifier |= JCEncodingTypeQualifierOut;
                type++;
            } break;
            case 'O': {
                qualifier |= JCEncodingTypeQualifierBycopy;
                type++;
            } break;
            case 'R': {
                qualifier |= JCEncodingTypeQualifierByref;
                type++;
            } break;
            case 'V': {
                qualifier |= JCEncodingTypeQualifierOneway;
                type++;
            } break;
            default: { prefix = false; } break;
        }
    }
    
    len = strlen(type);
    if (len == 0) return JCEncodingTypeUnknown | qualifier;
    
    switch (*type) {
        case 'v': return JCEncodingTypeVoid | qualifier;
        case 'B': return JCEncodingTypeBool | qualifier;
        case 'c': return JCEncodingTypeInt8 | qualifier;
        case 'C': return JCEncodingTypeUInt8 | qualifier;
        case 's': return JCEncodingTypeInt16 | qualifier;
        case 'S': return JCEncodingTypeUInt16 | qualifier;
        case 'i': return JCEncodingTypeInt32 | qualifier;
        case 'I': return JCEncodingTypeUInt32 | qualifier;
        case 'l': return JCEncodingTypeInt32 | qualifier;
        case 'L': return JCEncodingTypeUInt32 | qualifier;
        case 'q': return JCEncodingTypeInt64 | qualifier;
        case 'Q': return JCEncodingTypeUInt64 | qualifier;
        case 'f': return JCEncodingTypeFloat | qualifier;
        case 'd': return JCEncodingTypeDouble | qualifier;
        case 'D': return JCEncodingTypeLongDouble | qualifier;
        case '#': return JCEncodingTypeClass | qualifier;
        case ':': return JCEncodingTypeSEL | qualifier;
        case '*': return JCEncodingTypeCString | qualifier;
        case '^': return JCEncodingTypePointer | qualifier;
        case '[': return JCEncodingTypeCArray | qualifier;
        case '(': return JCEncodingTypeUnion | qualifier;
        case '{': return JCEncodingTypeStruct | qualifier;
        case '@': {
            if (len == 2 && *(type + 1) == '?')
                return JCEncodingTypeBlock | qualifier;
            else
                return JCEncodingTypeObject | qualifier;
        }
        default: return JCEncodingTypeUnknown | qualifier;
    }
}

static inline JCEncodingNSType JCClassGetNSType(Class cls) {
    if (!cls) {
        return JCEncodingTypeNSUnknown;
    }
    if ([cls isSubclassOfClass:[NSMutableString class]]) {
        return JCEncodingTypeNSMutableString;
    }
    if ([cls isSubclassOfClass:[NSString class]]) {
        return JCEncodingTypeNSString;
    }
    if ([cls isSubclassOfClass:[NSDecimalNumber class]]) {
        return JCEncodingTypeNSDecimalNumber;
    }
    if ([cls isSubclassOfClass:[NSNumber class]]) {
        return JCEncodingTypeNSNumber;
    }
    if ([cls isSubclassOfClass:[NSValue class]]) {
        return JCEncodingTypeNSValue;
    }
    if ([cls isSubclassOfClass:[NSMutableData class]]){
        return JCEncodingTypeNSMutableData;
    }
    if ([cls isSubclassOfClass:[NSData class]]) {
        return JCEncodingTypeNSData;
    }
    if ([cls isSubclassOfClass:[NSDate class]]) {
        return JCEncodingTypeNSDate;
    }
    if ([cls isSubclassOfClass:[NSURL class]]) {
        return JCEncodingTypeNSURL;
    }
    if ([cls isSubclassOfClass:[NSMutableArray class]]) {
        return JCEncodingTypeNSMutableArray;
    }
    if ([cls isSubclassOfClass:[NSArray class]]) {
        return JCEncodingTypeNSArray;
    }
    if ([cls isSubclassOfClass:[NSMutableDictionary class]]) {
        return JCEncodingTypeNSMutableDictionary;
    }
    if ([cls isSubclassOfClass:[NSDictionary class]]) {
        return JCEncodingTypeNSDictionary;
    }
    if ([cls isSubclassOfClass:[NSMutableSet class]]) {
        return JCEncodingTypeNSMutableSet;
    }
    if ([cls isSubclassOfClass:[NSSet class]]) {
        return JCEncodingTypeNSSet;
    }
    return JCEncodingTypeNSUnknown;
}

static inline BOOL JCEncodingTypeIsCNumber(JCEncodingType type) {
    switch (type & JCEncodingTypeMask) {
        case JCEncodingTypeBool:
        case JCEncodingTypeInt8:
        case JCEncodingTypeUInt8:
        case JCEncodingTypeInt16:
        case JCEncodingTypeUInt16:
        case JCEncodingTypeInt32:
        case JCEncodingTypeUInt32:
        case JCEncodingTypeInt64:
        case JCEncodingTypeUInt64:
        case JCEncodingTypeFloat:
        case JCEncodingTypeDouble:
        case JCEncodingTypeLongDouble: return YES;
        default: return NO;
    }
}

@implementation JCClassIvarInfo

- (instancetype)initWithIvar:(Ivar)ivar {
    if (!ivar) {
        return nil;
    }
    
    if (self = [super init]) {
        _ivar = ivar;
        
        const char *name = ivar_getName(ivar);
        if (name) {
            _name = [NSString stringWithUTF8String:name];
        }
        
        _offset = ivar_getOffset(ivar);
        
        const char *typeEncoding = ivar_getTypeEncoding(ivar);
        if (typeEncoding) {
            _typeEncoding = [NSString stringWithUTF8String:typeEncoding];
        }
    }
    return self;
}

@end

@implementation JCClassPropertyInfo

- (instancetype)initWithProperty:(objc_property_t)property {
    if (!property) {
        return nil;
    }
    
    if (self = [super init]) {
        _property = property;
        const char *name = property_getName(property);
        
        if (name) {
             _name = [NSString stringWithUTF8String:name];
        }
        
        JCEncodingType type = 0;
        unsigned int attrCount;
        objc_property_attribute_t *attrs = property_copyAttributeList(property, &attrCount);
        for (unsigned int i = 0; i < attrCount; i++) {
            switch (attrs[i].name[0]) {
                case 'T': { // Type encoding
                    if (attrs[i].value) {
                        _typeEncoding = [NSString stringWithUTF8String:attrs[i].value];
                        type = JCEncodingGetType(attrs[i].value);
                        if (type & JCEncodingTypeObject) {
                            size_t len = strlen(attrs[i].value);
                            if (len > 3) {
                                char name[len - 2];
                                name[len - 3] = '\0';
                                memcpy(name, attrs[i].value + 2, len - 3);
                                _cls = objc_getClass(name);
                            }
                        }
                    }
                } break;
                case 'V': { // Instance variable
                    if (attrs[i].value) {
                        _ivarName = [NSString stringWithUTF8String:attrs[i].value];
                    }
                } break;
                case 'R': {
                    type |= JCEncodingTypePropertyReadonly;
                } break;
                case 'C': {
                    type |= JCEncodingTypePropertyCopy;
                } break;
                case '&': {
                    type |= JCEncodingTypePropertyRetain;
                } break;
                case 'N': {
                    type |= JCEncodingTypePropertyNonatomic;
                } break;
                case 'D': {
                    type |= JCEncodingTypePropertyDynamic;
                } break;
                case 'W': {
                    type |= JCEncodingTypePropertyWeak;
                } break;
                case 'G': {
                    type |= JCEncodingTypePropertyCustomGetter;
                    if (attrs[i].value) {
                        _getter = [NSString stringWithUTF8String:attrs[i].value];
                    }
                } break;
                case 'S': {
                    type |= JCEncodingTypePropertyCustomSetter;
                    if (attrs[i].value) {
                        _setter = [NSString stringWithUTF8String:attrs[i].value];
                    }
                } break;
                default: break;
            }
        }
        
        if (attrs) {
            free(attrs);
            attrs = NULL;
        }
        
        _type = type;
        _isCNumber = JCEncodingTypeIsCNumber(_type);
        if (_name.length) {
            if (!_getter) {
                _getter = _name;
            }
            if (!_setter) {
                _setter = [NSString stringWithFormat:@"set%@%@:", [_name substringToIndex:1].uppercaseString, [_name substringFromIndex:1]];
            }
        }
    }
    return self;
}

- (JCEncodingNSType)nsType {
    return JCClassGetNSType(_cls);
}

@end

@implementation JCClassMethodInfo

- (instancetype)initWithMethod:(Method)method {
    if (!method) {
        return nil;
    }
    
    if (self = [super init]) {
        _method = method;
        _sel = method_getName(method);
        _imp = method_getImplementation(method);
        const char *name = sel_getName(_sel);
        if (name) {
            _name = [NSString stringWithUTF8String:name];
        }
        
        const char *typeEncoding = method_getTypeEncoding(method);
        if (typeEncoding) {
            _typeEncoding = [NSString stringWithUTF8String:typeEncoding];
        }
        
        char *returnType = method_copyReturnType(method);
        if (returnType) {
            _returnTypeEncoding = [NSString stringWithUTF8String:returnType];
            free(returnType);
        }
        
        unsigned int argumentCount = method_getNumberOfArguments(method);
        if (argumentCount > 0) {
            NSMutableArray *argumentTypes = [NSMutableArray new];
            for (unsigned int i = 0; i < argumentCount; i++) {
                char *argumentType = method_copyArgumentType(method, i);
                NSString *type = argumentType ? [NSString stringWithUTF8String:argumentType] : nil;
                [argumentTypes addObject:type ? type : @""];
                if (argumentType) {
                    free(argumentType);
                }
            }
            _argumentTypeEncodings = argumentTypes;
        }
    }
    return self;
}

@end

@implementation JCClassInfo

+ (instancetype)classInfoWithClassName:(NSString *)className {
    Class cls = NSClassFromString(className);
    return [self classInfoWithClass:cls];
}

+ (instancetype)classInfoWithClass:(Class)cls {
    if (!cls) {
        return nil;
    }
    static CFMutableDictionaryRef classCache;
    static CFMutableDictionaryRef metaCache;
    static OSSpinLock lock;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        classCache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        metaCache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        lock = OS_SPINLOCK_INIT;
    });
    
    OSSpinLockLock(&lock);
    JCClassInfo *info = CFDictionaryGetValue(class_isMetaClass(cls) ? metaCache : classCache, (__bridge const void *)(cls));
    if (info) {
        [info _update];
    }
    OSSpinLockUnlock(&lock);
    
    if (!info) {
        info = [[JCClassInfo alloc] initWithClass:cls];
        if (info) {
            OSSpinLockLock(&lock);
            CFDictionarySetValue(info.isMeta ? metaCache : classCache, (__bridge const void *)(cls), (__bridge const void *)(info));
            OSSpinLockUnlock(&lock);
        }
    }
    return info;
}

- (instancetype)initWithClass:(Class)cls {
    if (!cls) {
        return nil;
    }
    
    if (self = [super init]) {
        _cls = cls;
        _superCls = class_getSuperclass(cls);
        _isMeta = class_isMetaClass(cls);
        if (!_isMeta) {
            _metaCls = objc_getMetaClass(class_getName(cls));
        }
        
        _name = NSStringFromClass(cls);
        [self _update];
        
        _superClassInfo = [self.class classInfoWithClass:_superCls];
    }
    return self;
}

- (void)_update {
    _ivarInfos = nil;
    _methodInfos = nil;
    _propertyInfos = nil;
    
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(self.cls, &methodCount);
    if (methodCount) {
        NSMutableDictionary *methodInfos = [NSMutableDictionary new];
        for (unsigned int i = 0; i < methodCount; i++) {
            JCClassMethodInfo *info = [[JCClassMethodInfo alloc] initWithMethod:methods[i]];
            if (info.name) {
                methodInfos[info.name] = info;
            }
        }
        free(methods);
        _methodInfos = methodInfos;
    }
    
    unsigned int propertyCount = 0;
    objc_property_t *propertys = class_copyPropertyList(self.cls, &propertyCount);
    if (propertyCount) {
        NSMutableDictionary *propertyInfos = [NSMutableDictionary new];
        for (unsigned int i = 0; i < propertyCount; i++) {
            JCClassPropertyInfo *info = [[JCClassPropertyInfo alloc] initWithProperty:propertys[i]];
            if (info.name) {
                propertyInfos[info.name] = info;
            }
        }
        free(propertys);
        _propertyInfos = propertyInfos;
    }
    
    unsigned int ivarCount = 0;
    Ivar *ivars = class_copyIvarList(self.cls, &ivarCount);
    if (ivarCount) {
        NSMutableDictionary *ivarInfos = [NSMutableDictionary new];
        for (unsigned int i = 0; i < ivarCount; i++) {
            JCClassIvarInfo *info = [[JCClassIvarInfo alloc] initWithIvar:ivars[i]];
            if (info.name) {
                ivarInfos[info.name] = info;
            }
        }
        free(ivars);
        _ivarInfos = ivarInfos;
    }
}

- (NSDictionary *)protocolInfos {
    if (!_propertyInfos) {
        unsigned int protocolCount = 0;
        __unsafe_unretained Protocol **protocol = class_copyProtocolList(self.cls, &protocolCount);
        if (protocolCount) {
            NSMutableDictionary *protocolInfos = [NSMutableDictionary new];
            for (unsigned int i = 0; i < protocolCount; i++) {
                JCClassProtocolInfo *info = [[JCClassProtocolInfo alloc] initWithProtocol:protocol[i]];
                if (info.name) {
                    protocolInfos[info.name] = info;
                }
            }
            free(protocol);
            _propertyInfos = protocolInfos;
        }
    }
    return _propertyInfos;
}

@end

@implementation JCClassProtocolInfo

- (instancetype)initWithProtocol:(Protocol *)protocol {
    if (!protocol) {
        return nil;
    }
    
    if (self = [super init]) {
        _protocol = protocol;
        const char *name = protocol_getName(protocol);
        _name = [NSString stringWithUTF8String:name];
        
        unsigned int propertyCount = 0;
        objc_property_t *propertys = protocol_copyPropertyList(protocol, &propertyCount);
        NSMutableDictionary *propertyInfos = [NSMutableDictionary new];
        for (unsigned int i = 0; i < propertyCount; i++) {
            JCClassPropertyInfo *info = [[JCClassPropertyInfo alloc] initWithProperty:propertys[i]];
            if (info.name) {
                propertyInfos[info.name] = info;
            }
        }
        free(propertys);
        _propertyInfos = propertyInfos;
        
        unsigned int methodCount = 0;
        ProtocolMethod *methods = protocol_copyMethodDescriptionList(protocol,YES, YES, &methodCount);
        if (methodCount) {
            NSMutableDictionary *methodInfos = [NSMutableDictionary new];
            for (unsigned int i = 0; i < methodCount; i++) {
                JCProtocolMethodInfo *info = [[JCProtocolMethodInfo alloc] initWithProtocolMethod:methods[i]];
                if (info.name) {
                    methodInfos[info.name] = info;
                }
            }
            _methodInfos = methodInfos;
        }
        
        unsigned int protocolCount = 0;
        Protocol *__unsafe_unretained *protocols =  protocol_copyProtocolList(protocol, &protocolCount);
        if (protocolCount) {
            NSMutableDictionary *protocolInfos = [NSMutableDictionary new];
            for (unsigned int i = 0; i < protocolCount; i++) {
                JCClassProtocolInfo *info = [[JCClassProtocolInfo alloc] initWithProtocol:protocols[i]];
                if (info.name) {
                    protocolInfos[info.name] = info;
                }
            }
            free(protocols);
            _propertyInfos = protocolInfos;
        }
    }
    return self;
}

- (BOOL)conformsToProtocol:(JCClassProtocolInfo *)info {
    return protocol_conformsToProtocol(_protocol, info.protocol);
}

@end

@implementation JCProtocolMethodInfo

- (instancetype)initWithProtocolMethod:(ProtocolMethod)protocolMethod {
    if (!protocolMethod.name) {
        return nil;
    }
    
    if (self = [super init]) {
        _sel = protocolMethod.name;
        _name = NSStringFromSelector(_sel);
        _typeEncoding = [NSString stringWithUTF8String:protocolMethod.types];
    }
    return self;
}

@end
