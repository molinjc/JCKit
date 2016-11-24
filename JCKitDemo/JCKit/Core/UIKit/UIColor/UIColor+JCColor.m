//
//  UIColor+JCColor.m
//  JCKit
//
//  Created by 林建川 on 16/9/28.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UIColor+JCColor.h"

#define MaxRGB 255.0

@implementation UIColor (JCColor)

// 十六进制
+ (UIColor *)colorWithRGB16:(uint32_t)value {
    return [UIColor colorWithRGB16:value alphe:1.0];
}

+ (UIColor *)colorWithRGB16:(uint32_t)value alphe:(CGFloat)alpha {
    return [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0
                           green:((float)((value & 0xFF00) >> 8))/255.0
                            blue:((float)(value & 0xFF))/255.0
                           alpha:alpha];
}

- (CGFloat)RGB_red {
    // YYKit的UIColor+YYAdd.m -red方法的做法
    CGFloat r = 0, g,b,a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return r;
    
    /**************  Wonderful的UIColor+Separate -red方法的做法 *******************
    const CGFloat *r = CGColorGetComponents(self.CGColor);
    return r[0];
     ****************************************************************************/
}

- (CGFloat)RGB_green {
    // YYKit的UIColor+YYAdd.m -green方法的做法
    CGFloat g = 0, r,b,a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return g;
    
    /*************  Wonderful的UIColor+Separate -green方法的做法  *******************
    const CGFloat *g = CGColorGetComponents(self.CGColor);
    if (CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor)) == kCGColorSpaceModelMonochrome) {
        return g[0];
    }
    return g[1];
     ****************************************************************************/
}

- (CGFloat)RGB_blue {
    // YYKit的UIColor+YYAdd.m -blue方法的做法
    CGFloat b = 0, r,g,a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return b;
    
    /*************  Wonderful的UIColor+Separate -blue方法的做法 *******************
    const CGFloat *b = CGColorGetComponents(self.CGColor);
    if (CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor)) == kCGColorSpaceModelMonochrome) {
        return b[0];
    }
    return b[2];
    ****************************************************************************/
}

- (CGFloat)alpha {
    return CGColorGetAlpha(self.CGColor);
}

- (NSString *)colorSpaceString {
    CGColorSpaceModel model =  CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
    switch (model) {
        case kCGColorSpaceModelUnknown:
            return @"kCGColorSpaceModelUnknown";
            
        case kCGColorSpaceModelMonochrome:
            return @"kCGColorSpaceModelMonochrome";
            
        case kCGColorSpaceModelRGB:
            return @"kCGColorSpaceModelRGB";
            
        case kCGColorSpaceModelCMYK:
            return @"kCGColorSpaceModelCMYK";
            
        case kCGColorSpaceModelLab:
            return @"kCGColorSpaceModelLab";
            
        case kCGColorSpaceModelDeviceN:
            return @"kCGColorSpaceModelDeviceN";
            
        case kCGColorSpaceModelIndexed:
            return @"kCGColorSpaceModelIndexed";
            
        case kCGColorSpaceModelPattern:
            return @"kCGColorSpaceModelPattern";
            
        default:
            return @"ColorSpaceInvalid";
    }
}

/**
 整数的RGB值转换成颜色类
 */
+ (UIColor *)colorWithIntRed:(int)red green:(int)green blue:(int)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:red/MaxRGB green:green/MaxRGB blue:blue/MaxRGB alpha:alpha];
}

@end
