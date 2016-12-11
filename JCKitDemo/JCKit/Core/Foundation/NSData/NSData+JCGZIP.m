//
//  NSData+JCGZIP.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/11.
//  Copyright © 2016年 molin. All rights reserved.
//
// 需要导入libz.tbd库

#import "NSData+JCGZIP.h"
#import <zlib.h>

@implementation NSData (JCGZIP)

/**
 GZIP压缩
 */
- (NSData *)gzippedDataWithCompressionLevel:(float)level {
    if (self.length) {
        z_stream stream;
        stream.zalloc = Z_NULL;
        stream.zfree = Z_NULL;
        stream.opaque = Z_NULL;
        stream.avail_in = (uint)self.length;
        stream.next_in = (Bytef *)self.bytes;
        stream.total_out = 0;
        stream.avail_out = 0;
        
        int compression = (level < 0.0f) ? Z_DEFAULT_COMPRESSION : (int)roundf(level * 9);
        if (deflateInit2(&stream, compression, Z_DEFLATED, 31, 8, Z_DEFAULT_STRATEGY) == Z_OK) {
            NSMutableData *data = [NSMutableData dataWithLength:16384];
            
            while (stream.avail_out == 0) {
                
                if (stream.total_out >= data.length) {
                    data.length += 16384;
                }
                stream.next_out = data.mutableBytes + stream.total_out;
                stream.avail_out = (uint)(data.length - stream.total_out);
                deflate(&stream, Z_FINISH);
            }
            
            deflateEnd(&stream);
            data.length = stream.total_out;
            return data;
        }
    }
    return nil;
}

/**
 GZIP压缩, 压缩等级默认-1
 */
- (NSData *)gzippedData {
    return [self gzippedDataWithCompressionLevel:-1.0f];
}

/**
 GZIP解压
 */
- (NSData *)gunzippedData {
    if (self.length) {
        z_stream stream;
        stream.zalloc = Z_NULL;
        stream.zfree = Z_NULL;
        stream.avail_in = (uint)self.length;
        stream.next_in = (Bytef *)self.bytes;
        stream.total_out = 0;
        stream.avail_out = 0;
        
        NSMutableData *data = [NSMutableData dataWithLength:self.length * 1.5];
        if (inflateInit2(&stream, 47) == Z_OK) {
            int status = Z_OK;
            
            while (status == Z_OK) {
                
                if (stream.total_out >= [data length]) {
                    data.length += [self length] * 0.5;
                }
                stream.next_out = [data mutableBytes] + stream.total_out;
                stream.avail_out = (uint)([data length] - stream.total_out);
                status = inflate (&stream, Z_SYNC_FLUSH);
            }
            
            if (inflateEnd(&stream) == Z_OK) {
                
                if (status == Z_STREAM_END) {
                    data.length = stream.total_out;
                    return data;
                }
            }
        }
    }
    return nil;
}
@end
