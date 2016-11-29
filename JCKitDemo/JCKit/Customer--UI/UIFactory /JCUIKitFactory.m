//
//  JCUILabelFactory.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/11/28.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCUIKitFactory.h"

@implementation JCUIKitFactory

#pragma mark - UILabel

+ (UILabel *)labelTextColor:(UIColor *)textColor fontSize:(CGFloat)fontSize {
    UILabel *label = [JCUIKitFactory labelWithBackgroundColor:nil textColor:textColor fontSize:fontSize textAlignment:-1 numberOfLines:1 text:nil];
    return label;
}

+ (UILabel *)labelText:(NSString *)text fontSize:(CGFloat)fontSize {
    UILabel *label = [JCUIKitFactory labelWithBackgroundColor:nil textColor:nil fontSize:fontSize textAlignment:-1 numberOfLines:1 text:text];
    return label;
}

+ (UILabel *)labelWithBackgroundColor:(UIColor *)backgroundColor
                            textColor:(UIColor *)textColor
                             fontSize:(CGFloat)fontSize
                        textAlignment:(NSTextAlignment)textAlignment
                        numberOfLines:(NSInteger)numberOfLines
                                 text:(NSString *)text {
    
    UILabel *label = [[UILabel alloc] init];
    
    if (backgroundColor) {
        label.backgroundColor = backgroundColor;
    }
    
    if (textColor) {
        label.textColor = textColor;
    }
    
    if (fontSize > 0) {
        label.font = [UIFont systemFontOfSize:fontSize];
    }
    
    if (textAlignment >= 0) {
        label.textAlignment = textAlignment;
    }
    
    label.numberOfLines = numberOfLines;
    label.text = text;
    return label;
}

#pragma mark - UITextField

+ (UITextField *)textFieldWithBackground:(UIColor *)backgroundColor
                               textColor:(UIColor *)textColor
                                fontSize:(CGFloat)fontSize
                           textAlignment:(NSTextAlignment)textAlignment
                                    text:(NSString *)text
                          attributedText:(NSAttributedString *)attributedText
                             placeholder:(NSString *)placeholder
                   attributedPlaceholder:(NSAttributedString *)attributedPlaceholder
                                delegate:(id)dalegate {
    
    UITextField *textField = [[UITextField alloc] init];
    
    if (backgroundColor) {
        textField.backgroundColor = backgroundColor;
    }
    
    if (textColor) {
        textField.textColor = textColor;
    }
    
    if (fontSize > 0) {
        textField.font = [UIFont systemFontOfSize:fontSize];
    }
    
    if (textAlignment >= 0) {
        textField.textAlignment = textAlignment;
    }
    
    if (attributedText) {
        textField.attributedText = attributedText;
    }else {
        textField.text = text;
    }
    
    if (attributedPlaceholder) {
        textField.attributedPlaceholder = attributedPlaceholder;
    }else {
        textField.placeholder = placeholder;
    }
    
    if (dalegate) {
        textField.delegate = dalegate;
    }
    
    return textField;
}

#pragma mark - UIButton

+ (UIButton *)buttonWithBackground:(UIColor *)backgroundColor
                         titleColor:(UIColor *)titleColor
                          fontSize:(CGFloat)fontSize
                        imageNamed:(NSString *)imageNamed
                             title:(NSString *)title
                   attributedTitle:(NSAttributedString *)attributedTitle {
    
    return [JCUIKitFactory buttonWithType:UIButtonTypeRoundedRect Background:backgroundColor titleColor:titleColor fontSize:fontSize imageNamed:imageNamed title:title attributedTitle:attributedTitle];
}

+ (UIButton *)buttonWithType:(UIButtonType)buttonType
                  Background:(UIColor *)backgroundColor
                  titleColor:(UIColor *)titleColor
                    fontSize:(CGFloat)fontSize
                  imageNamed:(NSString *)imageNamed
                       title:(NSString *)title
             attributedTitle:(NSAttributedString *)attributedTitle {
    
    UIButton *button = [UIButton buttonWithType:buttonType];
    
    if (backgroundColor) {
        button.backgroundColor = backgroundColor;
    }
    
    if (titleColor) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    
    if (fontSize > 0) {
        button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    }
    
    if (imageNamed) {
        [button setImage:[[UIImage imageNamed:imageNamed] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
    
    if (attributedTitle) {
        [button setAttributedTitle:attributedTitle forState:UIControlStateNormal];
    }else {
        [button setTitle:title forState:UIControlStateNormal];
    }
    
    return button;
}

#pragma mark - UIView 

+ (UIView *)viewWithBackground:(UIColor *)backgroundColor {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = backgroundColor;
    return view;
}

#pragma mark - UIImageView

+ (UIImageView *)imageViewWithBackground:(UIColor *)backgroundColor
                              imageNamed:(NSString *)imageNamed {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:imageNamed];
    
    if (backgroundColor) {
        imageView.backgroundColor = backgroundColor;
    }
    return imageView;
}

#pragma mark - UIScrollView

+ (UIScrollView *)scrollViewWithBackground:(UIColor *)backgroundColor
                               contentSize:(CGSize)contentSize
                             scrollEnabled:(BOOL)scrollEnabled
                             pagingEnabled:(BOOL)pagingEnabled       // 设置滚动视图是否整页翻动,default NO
                                   bounces:(BOOL)bounces             // 反弹效果,default YES
            showsHorizontalScrollIndicator:(BOOL)showsHorizontalScrollIndicator  // 水平滚动条,default YES
              showsVerticalScrollIndicator:(BOOL)showsVerticalScrollIndicator    // 垂直滚动条,default YES
                                  delegate:(id)delegate {
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    
    if (backgroundColor) {
        scrollView.backgroundColor = backgroundColor;
    }
    
    scrollView.contentSize = contentSize;
    scrollView.scrollEnabled = scrollEnabled;
    scrollView.pagingEnabled = pagingEnabled;
    scrollView.bounces = bounces;
    scrollView.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator;
    scrollView.showsVerticalScrollIndicator = showsVerticalScrollIndicator;
    scrollView.delegate = delegate;
    return scrollView;
}

@end
