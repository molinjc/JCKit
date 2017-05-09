//
//  JCAttributed.m
//  JCAttributed
//
//  Created by molin.JC on 2017/4/26.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCAttributed.h"
#import "NSMutableAttributedString+JCAttributedString.h"
#import <objc/runtime.h>

@interface JCAttributed () {
    NSMutableAttributedString * _attributed;
}
@property (nonatomic, readonly) NSRange range;
@end

@implementation JCAttributed

#pragma mark - init(初始化)

- (instancetype)initWithString:(NSString *)string {
    if (self = [super init]) {
        _attributed = [[NSMutableAttributedString alloc] initWithString:string];
    }
    return self;
}

- (instancetype)initWithAttributed:(JCAttributed *)attributed {
    if (self = [super init]) {
        NSAttributedString *att = attributed.attributedString;
        if (!att) {
            NSDictionary *dic = [attributed attributedDictionary];
            att = [[NSMutableAttributedString alloc] initWithString:(attributed.string ? attributed.string : @"") attributes:dic];
        }
        _attributed = [[NSMutableAttributedString alloc] initWithAttributedString:att];
    }
    return self;
}

#pragma mark - Private Methods(自定义方法，只有自己调用)

#pragma mark - System Methods(系统方法)
#pragma mark - Custom Methods(自定义方法，外部可调用)

- (NSDictionary *)attributedDictionary {
    static NSDictionary *keys = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keys = @{NSFontAttributeName: @"font",
                 NSForegroundColorAttributeName: @"textColor",
                 NSParagraphStyleAttributeName: @"paragraphStyle",
                 NSUnderlineStyleAttributeName: @"underlineStyle",
                 NSUnderlineColorAttributeName: @"underlineColor",
                 NSLinkAttributeName: @"linkAddress",
                 NSBackgroundColorAttributeName: @"backgroundColor",
                 NSShadowAttributeName: @"shadow"};
    });
    
    NSMutableDictionary *attributedDictionary = [NSMutableDictionary new];
    for (NSString *key in keys.allKeys) {
        id value = [self valueForKey:keys[key]];
        if (value) {
            attributedDictionary[key] = value;
        }
    }
    return attributedDictionary.mutableCopy;
}

- (void)appendAttributed:(JCAttributed *)attributed {
    if (_attributed) {
        [_attributed appendAttributedString:attributed.attributedString];
    }
}

- (void)insertAttributed:(JCAttributed *)attributed atIndex:(NSUInteger)loc {
    if (_attributed) {
        [_attributed insertAttributedString:attributed.attributedString atIndex:loc];
    }
}

- (void)replaceCharactersInRange:(NSRange)range withAttributed:(JCAttributed *)attributed {
    if (_attributed) {
        [_attributed replaceCharactersInRange:range withAttributedString:attributed.attributedString];
    }
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str {
    if (_attributed) {
        [_attributed replaceCharactersInRange:range withString:str];
    }
}

- (void)setTextAttachment:(NSTextAttachment *)textAttachment {
    NSAttributedString *subAttributedString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [_attributed appendAttributedString:subAttributedString];
}


- (NSDictionary<NSString *,id> *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range {
    return [_attributed attributesAtIndex:location effectiveRange:range];
}

- (id)attribute:(NSString *)attrName atIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range {
    return [_attributed attribute:attrName atIndex:location effectiveRange:range];
}


#pragma mark - Setter/Getter(懒加载)

- (void)setFont:(UIFont *)font {
    _font = font;
    if (_attributed) {
        [_attributed addFont:font];
    }
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    if (_attributed) {
        [_attributed addTextColor:textColor];
    }
}

- (void)setParagraphStyle:(NSParagraphStyle *)paragraphStyle {
    _paragraphStyle = paragraphStyle;
    if (_attributed) {
        [_attributed addParagraphStyle:paragraphStyle];
    }
}

- (void)setUnderlineStyle:(NSNumber *)underlineStyle {
    _underlineStyle = underlineStyle;
    if (_attributed) {
        [_attributed addUnderlineStyle:underlineStyle];
    }
}

- (void)setUnderlineColor:(UIColor *)underlineColor {
    _underlineColor = underlineColor;
    if (_attributed) {
        [_attributed addUnderlineColor:underlineColor];
    }
}

- (void)setLinkAddress:(NSString *)linkAddress {
    _linkAddress = linkAddress;
    if (_attributed) {
        [_attributed addLinkAddress:linkAddress];
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    if (_attributed) {
        [_attributed addBackgroundColor:backgroundColor];
    }
}

- (void)setShadow:(NSShadow *)shadow {
    _shadow = shadow;
    if (_attributed) {
        [_attributed addShadow:shadow];
    }
}

- (NSAttributedString *)attributedString {
    return _attributed;
}

- (NSRange)range {
    return NSMakeRange(0, self.length);
}

- (NSString *)string {
    return _attributed.string;
}

- (NSUInteger)length {
    return _attributed.length;
}

@end
