//
//  JCLogTextView.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/27.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCLogTextView.h"

@implementation JCLogTextView

- (void)logText:(NSString *)string, ... {
    if (!string) {
        return;
    }
    
    NSString *last = self.text;
    
    va_list arglist;
    va_start(arglist, string);
    NSString *outString = [[NSString alloc] initWithFormat:string arguments:arglist];
    va_end(arglist);
    
    self.text = [NSString stringWithFormat:@"%@\n\n🛠 行号:%d\n🛠 类与方法:%s\n🛠 内容:%@",last, __LINE__, __func__, outString];
}

@end
