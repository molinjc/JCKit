//
//  JCArchiveTool.h
//  JCRunTimeTest
//
//  Created by 林建川 on 16/7/23.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCEncodeModel.h"

@interface JCArchiveTool : NSObject

/**
 *  保存
 */
- (void)saveModel:(id)model key:(NSString *)key;

/**
 *  保存所有的
 */
- (void)saveAllModel;

/**
 *  清除所有
 */
- (void)clearAllModel;

@end
