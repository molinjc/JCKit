//
//  UIImageView+JCWebImage.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/1.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UIImageView+JCWebImage.h"
#import "JCCache.h"
#import "UIImage+JCImage.h"

@implementation UIImageView (JCWebImage)

- (void)setImageWithURL:(NSURL *)url {
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url completed:(void (^)(UIImage *image))completedBlock {
    [self setImageWithURL:url placeholderImage:nil completed:completedBlock];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self setImageWithURL:url placeholderImage:placeholder completed:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(void (^)(UIImage *image))completedBlock {
    if (placeholder) {
        self.image = placeholder;
    }
    
    if ([url isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:(NSString *)url];
    }
    
    if (![url isKindOfClass:[NSURL class]]) {
        return;
    }
    
    __block UIImage *image = [[JCCache sharedCache] imageGIFFromCacheForKey:url.absoluteString];
    if (!image) {
        [self imageRequestWithURL:url success:^(NSData *data) {
            image = [UIImage imageWithData:data];
            [[JCCache sharedCache] saveImage:image key:url.absoluteString];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = image;
                if (completedBlock) {
                    completedBlock(image);
                }
            });
        } fail:^(NSError *error) {
            
        }];
    }else {
        self.image = image;
        if (completedBlock) {
            completedBlock(image);
        }
    }
}

- (void)setImageGIFWithURL:(NSURL *)url {
    [self setImageGIFWithURL:url placeholderImage:nil];
}

- (void)setImageGIFWithURL:(NSURL *)url completed:(void (^)(UIImage *image))completedBlock {
    [self setImageGIFWithURL:url placeholderImage:nil completed:completedBlock];
}

- (void)setImageGIFWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self setImageGIFWithURL:url placeholderImage:placeholder completed:nil];
}

- (void)setImageGIFWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(void (^)(UIImage *image))completedBlock {
    if (placeholder) {
        self.image = placeholder;
    }
    
    if ([url isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:(NSString *)url];
    }
    
    if (![url isKindOfClass:[NSURL class]]) {
        return;
    }
    
    __block UIImage *image = [[JCCache sharedCache] imageGIFFromCacheForKey:url.absoluteString];
    if (!image) {
        [self imageRequestWithURL:url success:^(NSData *data) {
            image = [UIImage animatedGIFWithData:data];
            [[JCCache sharedCache] saveImage:image key:url.absoluteString];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = image;
                if (completedBlock) {
                    completedBlock(image);
                }
            });
        } fail:^(NSError *error) {
            
        }];
    }else {
        self.image = image;
        if (completedBlock) {
            completedBlock(image);
        }
    }
}

- (void)imageRequestWithURL:(NSURL *)url success:(void (^)(NSData *data))success fail:(void (^)(NSError *error))fail {
    //创建请求对象
    NSURLRequest *req=[NSURLRequest  requestWithURL:url];
    //发送请求连接
    [NSURLConnection  sendAsynchronousRequest:req queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError==nil) {
            if (success) {
                success(data);
            }
        } else if (fail) {
            fail(connectionError);
        }
    }];
}

@end
