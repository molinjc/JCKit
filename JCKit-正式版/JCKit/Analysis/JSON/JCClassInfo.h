//
//  JCClassInfo.h
//  JCMVPDemo
//
//  Created by molin.JC on 2017/4/21.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef NS_ENUM (NSUInteger, JCEncodingNSType) {
    JCEncodingTypeNSUnknown = 0,
    JCEncodingTypeNSString,
    JCEncodingTypeNSMutableString,
    JCEncodingTypeNSValue,
    JCEncodingTypeNSNumber,
    JCEncodingTypeNSDecimalNumber,
    JCEncodingTypeNSData,
    JCEncodingTypeNSMutableData,
    JCEncodingTypeNSDate,
    JCEncodingTypeNSURL,
    JCEncodingTypeNSArray,
    JCEncodingTypeNSMutableArray,
    JCEncodingTypeNSDictionary,
    JCEncodingTypeNSMutableDictionary,
    JCEncodingTypeNSSet,
    JCEncodingTypeNSMutableSet,
};

typedef NS_OPTIONS(NSUInteger, JCEncodingType) {
    JCEncodingTypeMask       = 0xFF, ///< mask of type value
    JCEncodingTypeUnknown    = 0, ///< unknown
    JCEncodingTypeVoid       = 1, ///< void
    JCEncodingTypeBool       = 2, ///< bool
    JCEncodingTypeInt8       = 3, ///< char / BOOL
    JCEncodingTypeUInt8      = 4, ///< unsigned char
    JCEncodingTypeInt16      = 5, ///< short
    JCEncodingTypeUInt16     = 6, ///< unsigned short
    JCEncodingTypeInt32      = 7, ///< int
    JCEncodingTypeUInt32     = 8, ///< unsigned int
    JCEncodingTypeInt64      = 9, ///< long long
    JCEncodingTypeUInt64     = 10, ///< unsigned long long
    JCEncodingTypeFloat      = 11, ///< float
    JCEncodingTypeDouble     = 12, ///< double
    JCEncodingTypeLongDouble = 13, ///< long double
    JCEncodingTypeObject     = 14, ///< id
    JCEncodingTypeClass      = 15, ///< Class
    JCEncodingTypeSEL        = 16, ///< SEL
    JCEncodingTypeBlock      = 17, ///< block
    JCEncodingTypePointer    = 18, ///< void*
    JCEncodingTypeStruct     = 19, ///< struct
    JCEncodingTypeUnion      = 20, ///< union
    JCEncodingTypeCString    = 21, ///< char*
    JCEncodingTypeCArray     = 22, ///< char[10] (for example)
    
    JCEncodingTypeQualifierMask   = 0xFF00,   ///< mask of qualifier
    JCEncodingTypeQualifierConst  = 1 << 8,  ///< const
    JCEncodingTypeQualifierIn     = 1 << 9,  ///< in
    JCEncodingTypeQualifierInout  = 1 << 10, ///< inout
    JCEncodingTypeQualifierOut    = 1 << 11, ///< out
    JCEncodingTypeQualifierBycopy = 1 << 12, ///< bycopy
    JCEncodingTypeQualifierByref  = 1 << 13, ///< byref
    JCEncodingTypeQualifierOneway = 1 << 14, ///< oneway
    
    JCEncodingTypePropertyMask         = 0xFF0000, ///< mask of property
    JCEncodingTypePropertyReadonly     = 1 << 16, ///< readonly
    JCEncodingTypePropertyCopy         = 1 << 17, ///< copy
    JCEncodingTypePropertyRetain       = 1 << 18, ///< retain
    JCEncodingTypePropertyNonatomic    = 1 << 19, ///< nonatomic
    JCEncodingTypePropertyWeak         = 1 << 20, ///< weak
    JCEncodingTypePropertyCustomGetter = 1 << 21, ///< getter=
    JCEncodingTypePropertyCustomSetter = 1 << 22, ///< setter=
    JCEncodingTypePropertyDynamic      = 1 << 23, ///< @dynamic
};

/** Ivar的实例(Ivar表示成员变量, (所有变量)) */
@interface JCClassIvarInfo : NSObject
@property (nonatomic, assign, readonly) Ivar ivar;
/** 成员变量的名字 */
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, assign, readonly) ptrdiff_t offset;
@property (nonatomic, copy, readonly) NSString *typeEncoding;

- (instancetype)initWithIvar:(Ivar)ivar;
@end

/** objc_property_t的实例(带@property的变量) */
@interface JCClassPropertyInfo : NSObject
@property (nonatomic, assign, readonly) objc_property_t property;
/** 属性名 */
@property (nonatomic, copy, readonly) NSString *name;
/** 属性的类型 */
@property (nonatomic, assign, readonly) JCEncodingType type;
@property (nonatomic, assign, readonly) JCEncodingNSType nsType;
@property (nonatomic, assign, readonly) BOOL isCNumber;
@property (nonatomic, copy, readonly) NSString *typeEncoding;
@property (nonatomic, copy, readonly) NSString *ivarName;
@property (nonatomic, assign, readonly) Class cls;
@property (nonatomic, copy, readonly) NSString *getter;
@property (nonatomic, copy, readonly) NSString *setter;

- (instancetype)initWithProperty:(objc_property_t)property;
@end

/** Method的实例(Method表示方法) */
@interface JCClassMethodInfo : NSObject
@property (nonatomic, assign, readonly) Method method;
/** 方法名 */
@property (nonatomic, copy, readonly) NSString *name;
/** 方法的选择器 */
@property (nonatomic, assign, readonly) SEL sel;
/** 方法的实现(实际上是一个指针) */
@property (nonatomic, assign, readonly) IMP imp;
/** 参数和返回值的类型, 也就是方法的类型 */
@property (nonatomic, copy, readonly) NSString *typeEncoding;
/** 返回值的类型 */
@property (nonatomic, copy, readonly) NSString *returnTypeEncoding;
/** 参数的类型集合 */
@property (nonatomic, strong, readonly) NSArray *argumentTypeEncodings;

- (instancetype)initWithMethod:(Method)method;
@end

@interface JCClassInfo : NSObject
/** 类 */
@property (nonatomic, assign, readonly) Class cls;
/** 父类 */
@property (nonatomic, assign, readonly) Class superCls;
@property (nonatomic, strong, readonly) JCClassInfo *superClassInfo;
@property (nonatomic, assign, readonly) Class metaCls;
@property (nonatomic, assign, readonly) BOOL isMeta;
/** 类名 */
@property (nonatomic, copy, readonly) NSString *name;
/** 成员变量的集合<key:JCClassIvarInfo, ...> */
@property (nonatomic, strong, readonly) NSDictionary *ivarInfos;
/** 方法的集合<key:JCClassMethodInfo, ...> */
@property (nonatomic, strong, readonly) NSDictionary *methodInfos;
/** 属性的集合<key:JCClassPropertyInfo, ...> */
@property (nonatomic, strong, readonly) NSDictionary *propertyInfos;
/** 协议的集合<key:JCClassProtocolInfo, ...> */
@property (nonatomic, strong, readonly) NSDictionary *protocolInfos;
+ (instancetype)classInfoWithClass:(Class)cls;

+ (instancetype)classInfoWithClassName:(NSString *)className;
@end

@interface JCClassProtocolInfo : NSObject
@property (nonatomic, assign, readonly) Protocol *protocol;
@property (nonatomic, copy, readonly) NSString *name;
/** 协议的属性集合<key:JCClassPropertyInfo, ...> */
@property (nonatomic, strong, readonly) NSDictionary *propertyInfos;
/** 协议的方法集合<key:JCProtocolMethodInfo, ...> */
@property (nonatomic, strong, readonly) NSDictionary *methodInfos;
/** 协议采用的协议的集合 */
@property (nonatomic, assign, readonly) NSDictionary *protocoInfos;
- (instancetype)initWithProtocol:(Protocol *)protocol;
/** 是否采用了另一个协议 */
- (BOOL)conformsToProtocol:(JCClassProtocolInfo *)info;
@end

typedef struct objc_method_description ProtocolMethod;

@interface JCProtocolMethodInfo : NSObject
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, assign, readonly) SEL sel;
@property (nonatomic, copy, readonly) NSString *typeEncoding;
/** 返回值的类型 */
@property (nonatomic, copy, readonly) NSString *returnTypeEncoding;
/** 参数的类型集合 */
@property (nonatomic, strong, readonly) NSArray *argumentTypeEncodings;

- (instancetype)initWithProtocolMethod:(ProtocolMethod)protocolMethod;
@end
