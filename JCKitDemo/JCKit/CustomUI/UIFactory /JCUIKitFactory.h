//
//  JCUILabelFactory.h
//  JCKitDemo
//
//  Created by molin.JC on 2016/11/28.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCUIKitFactory : NSObject

#pragma mark - UILabel

+ (UILabel *)labelTextColor:(UIColor *)textColor fontSize:(CGFloat)fontSize;
+ (UILabel *)labelText:(NSString *)text fontSize:(CGFloat)fontSize;
+ (UILabel *)labelWithBackgroundColor:(UIColor *)backgroundColor
                            textColor:(UIColor *)textColor
                             fontSize:(CGFloat)fontSize
                        textAlignment:(NSTextAlignment)textAlignment
                        numberOfLines:(NSInteger)numberOfLines
                                 text:(NSString *)text;

#pragma mark - UITextField

+ (UITextField *)textFieldWithBackground:(UIColor *)backgroundColor
                               textColor:(UIColor *)textColor
                                fontSize:(CGFloat)fontSize
                           textAlignment:(NSTextAlignment)textAlignment
                                    text:(NSString *)text
                          attributedText:(NSAttributedString *)attributedText
                             placeholder:(NSString *)placeholder
                   attributedPlaceholder:(NSAttributedString *)attributedPlaceholder
                                delegate:(id)dalegate;

#pragma mark - UIButton

+ (UIButton *)buttonWithBackground:(UIColor *)backgroundColor
                        titleColor:(UIColor *)titleColor
                          fontSize:(CGFloat)fontSize
                        imageNamed:(NSString *)imageNamed
                             title:(NSString *)title
                   attributedTitle:(NSAttributedString *)attributedTitle;

+ (UIButton *)buttonWithType:(UIButtonType)buttonType
                  Background:(UIColor *)backgroundColor
                  titleColor:(UIColor *)titleColor
                    fontSize:(CGFloat)fontSize
                  imageNamed:(NSString *)imageNamed
                       title:(NSString *)title
             attributedTitle:(NSAttributedString *)attributedTitle;

#pragma mark - UIView

+ (UIView *)viewWithBackground:(UIColor *)backgroundColor;

#pragma mark - UIImageView

+ (UIImageView *)imageViewWithBackground:(UIColor *)backgroundColor
                              imageNamed:(NSString *)imageNamed;

#pragma mark - UIScrollView

+ (UIScrollView *)scrollViewWithBackground:(UIColor *)backgroundColor
                               contentSize:(CGSize)contentSize
                             scrollEnabled:(BOOL)scrollEnabled
                             pagingEnabled:(BOOL)pagingEnabled       // 设置滚动视图是否整页翻动,default NO
                                   bounces:(BOOL)bounces             // 反弹效果,default YES
            showsHorizontalScrollIndicator:(BOOL)showsHorizontalScrollIndicator  // 水平滚动条,default YES
              showsVerticalScrollIndicator:(BOOL)showsVerticalScrollIndicator    // 垂直滚动条,default YES
                                  delegate:(id)delegate;

@end
