//
//  UIButton+JCWebImage.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/1.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UIButton+JCWebImage.h"
#import "JCCache.h"
#import "UIImage+JCImage.h"

@implementation UIButton (JCWebImage)

#pragma mark -

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state {
    [self setImageWithURL:url placeholderImage:nil forState:state];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(void (^)(UIImage *image))completedBlock {
    [self setImageWithURL:url placeholderImage:nil forState:state completed:completedBlock];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state {
    [self setImageWithURL:url placeholderImage:placeholder forState:state completed:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state completed:(void (^)(UIImage *image))completedBlock {
    if (placeholder) {
        [self setImage:placeholder forState:state];
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
                [self setImage:image forState:state];
                if (completedBlock) {
                    completedBlock(image);
                }
            });
        } fail:^(NSError *error) {
            
        }];
    }else {
        [self setImage:image forState:state];
        if (completedBlock) {
            completedBlock(image);
        }
    }
}

#pragma mark - GIF

- (void)setImageGIFWithURL:(NSURL *)url forState:(UIControlState)state {
    [self setImageGIFWithURL:url forState:state completed:nil];
}

- (void)setImageGIFWithURL:(NSURL *)url forState:(UIControlState)state completed:(void (^)(UIImage *image))completedBlock {
    [self setImageGIFWithURL:url placeholderImage:nil forState:state completed:completedBlock];
}

- (void)setImageGIFWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state {
    [self setImageGIFWithURL:url placeholderImage:placeholder forState:state completed:nil];
}

- (void)setImageGIFWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state completed:(void (^)(UIImage *image))completedBlock {
    if (placeholder) {
        [self setImage:placeholder forState:state];
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
                [self setImage:image forState:state];
                if (completedBlock) {
                    completedBlock(image);
                }
            });
        } fail:^(NSError *error) {
            
        }];
    }else {
        [self setImage:image forState:state];
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
