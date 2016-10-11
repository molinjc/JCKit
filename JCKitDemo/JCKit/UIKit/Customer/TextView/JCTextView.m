//
//  JCTextView.m
//  JianShu
//
//  Created by molin on 16/4/27.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCTextView.h"

@interface JCTextView ()

@property (nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation JCTextView

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.placeholderLabel];
        [self addObserver];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.placeholderLabel];
        [self addObserver];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.placeholderLabel.frame = CGRectMake(3, 8, frame.size.width-3, 22);
    [self updatePlaceholderLabelHeight];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    self.placeholderLabel.font = font;
    [self updatePlaceholderLabelHeight];
}

-(void)addObserver {
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChange:) name:UITextViewTextDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEndEditing:) name:UITextViewTextDidEndEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(terminate:) name:UIApplicationWillTerminateNotification object:[UIApplication sharedApplication]];
}

- (void)terminate:(NSNotification *)notification {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didBeginEditing:(NSNotification *)notification {
    if (self.text.length) {
        self.placeholderLabel.hidden = YES;
    }
}

- (void)didChange:(NSNotification *)notification {
    if (self.text.length == 0) {
        self.placeholderLabel.hidden = NO;
    }else if(!self.placeholderLabel.hidden) {
        self.placeholderLabel.hidden = YES;
    }
}

- (void)didEndEditing:(NSNotification *)notification {
    if (self.text.length == 0) {
        self.placeholderLabel.hidden = NO;
    }else if(!self.placeholderLabel.hidden) {
        self.placeholderLabel.hidden = YES;
    }
}

- (void)updatePlaceholderLabelHeight {
    NSString *string = @"";
    if (self.placeholderLabel.text.length) {
        string = self.placeholderLabel.text;
    }else if (self.placeholderLabel.attributedText.string.length) {
        string = self.placeholderLabel.attributedText.string;
    }
    
    CGSize size = [string boundingRectWithSize:CGSizeMake(self.placeholderLabel.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.placeholderLabel.font} context:nil].size;
    CGFloat height = 22;
    if (size.height >= self.frame.size.height) {
        height = self.frame.size.height;
    }else {
        height = size.height;
    }
    CGRect rect = self.placeholderLabel.frame;
    rect.size.height = height;
    self.placeholderLabel.frame = rect;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
    [self updatePlaceholderLabelHeight];
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    _attributedPlaceholder = attributedPlaceholder;
    self.placeholderLabel.attributedText = attributedPlaceholder;
    [self updatePlaceholderLabelHeight];
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.7];
        _placeholderLabel.numberOfLines = 0;
        _placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [_placeholderLabel sizeToFit];
    }
    return _placeholderLabel;
}

@end
