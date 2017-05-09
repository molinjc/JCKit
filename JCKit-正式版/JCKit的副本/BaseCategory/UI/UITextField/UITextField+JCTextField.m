//
//  UITextField+JCTextField.m
//
//  Created by 林建川 on 16/10/2.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UITextField+JCTextField.h"
#import <objc/runtime.h>

#define kPredicate @"Predicate"

@interface _JCTextPredicateTarget : NSObject

@property (nonatomic, strong) NSPredicate *predicate;
@property (nonatomic, copy) void (^predicateBlock)(BOOL);
@property (nonatomic, copy) NSString *notificationName;

- (instancetype)initWithPredicate:(NSString *)predicate;
- (void)setPredicateFormat:(NSString *)predicate;
- (void)addPredicateBlock:(void (^)(BOOL))block;
- (void)invoke:(UITextField *)sender;

@end
@implementation _JCTextPredicateTarget

- (instancetype)initWithPredicate:(NSString *)predicate {
    if (self = [super init]) {
        _predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",predicate];
    }
    return self;
}

- (void)setPredicateFormat:(NSString *)predicate {
    _predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",predicate];
}

- (void)addPredicateBlock:(void (^)(BOOL))block {
    _predicateBlock = [block copy];
}

- (void)addNotificationName:(NSString *)notificationName {
    _notificationName = notificationName;
}

- (void)invoke:(UITextField *)sender {
    if (_predicateBlock) {
        _predicateBlock([_predicate evaluateWithObject:sender.text]);
    }else if (_notificationName.length) {
        [[NSNotificationCenter defaultCenter] postNotificationName:_notificationName object:nil userInfo:@{@"kPredicate":@([_predicate evaluateWithObject:sender.text])}];
    }
}

@end


@implementation UITextField (JCTextField)

/**
 设置Placeholder占位符的颜色
 */
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    [self setValue:placeholderColor forKey:@"_placeholderLabel.textColor"];
}

- (void)addPredicate:(NSString *)predicate action:(void (^)(BOOL))block {
    _JCTextPredicateTarget *_target = [self _actionTargets][kPredicate];
    if (!_target) {
        _target = [[_JCTextPredicateTarget alloc] init];
        NSMutableDictionary *targets = [self _actionTargets];
        targets[kPredicate] = _target;
    }
    
    [_target setPredicateFormat:predicate];
    [_target addPredicateBlock:block];
    [self addTarget:_target action:@selector(invoke:) forControlEvents:UIControlEventEditingChanged];
}

- (void)addPredicate:(NSString *)predicate notificationName:(NSString *)notificationName {
    _JCTextPredicateTarget *_target = [self _actionTargets][kPredicate];
    if (!_target) {
        _target = [[_JCTextPredicateTarget alloc] init];
        NSMutableDictionary *targets = [self _actionTargets];
        targets[kPredicate] = _target;
    }
    [_target setPredicateFormat:predicate];
    [_target addPredicateBlock:nil];
    [_target addNotificationName:notificationName];
    [self addTarget:_target action:@selector(invoke:) forControlEvents:UIControlEventEditingChanged];
}

- (void)removePredicateTarget {
    NSMutableDictionary *targets = [self _actionTargets];
    [targets enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self removeTarget:obj action:@selector(invoke:) forControlEvents:UIControlEventEditingChanged];
    }];
}

- (NSMutableDictionary *)_actionTargets {
    NSMutableDictionary *targets = objc_getAssociatedObject(self, _cmd);
    if (!targets) {
        targets = [NSMutableDictionary new];
        objc_setAssociatedObject(self, _cmd, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}

/**
 设置文字左边留出的空白宽度
 */
- (void)setContentPaddingLeft:(CGFloat)width {
    self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, self.frame.size.height)];
    self.leftViewMode = UITextFieldViewModeAlways;
}

/**
 设置文字右边留出的空白宽度
 */
- (void)setContentPaddingRight:(CGFloat)width {
    self.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, self.frame.size.height)];
    self.rightViewMode = UITextFieldViewModeAlways;
}

/**
 选中所有文字
 */
- (void)selectAllText {
    UITextRange *range = [self textRangeFromPosition:self.beginningOfDocument toPosition:self.endOfDocument];
    [self setSelectedTextRange:range];
}

/**
 当前选中的字符串范围
 */
- (NSRange)currentSelectedRange {
    UITextPosition* beginning = self.beginningOfDocument;
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    return NSMakeRange(location, length);
}

/**
 选中指定范围的文字
 */
- (void)setSelectedRange:(NSRange)range {
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:NSMaxRange(range)];
    UITextRange *selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    [self setSelectedTextRange:selectionRange];
}

@end
