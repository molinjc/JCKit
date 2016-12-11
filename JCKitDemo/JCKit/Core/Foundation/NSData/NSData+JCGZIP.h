//
//  NSData+JCGZIP.h
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/11.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (JCGZIP)

/**
 GZIP压缩
 @param level 压缩等级
 @return NSData
 */
- (NSData *)gzippedDataWithCompressionLevel:(float)level;

/**
 GZIP压缩, 压缩等级默认-1
 */
- (NSData *)gzippedData;

/**
 GZIP解压
 */
- (NSData *)gunzippedData;

@end
