//
//  UIImageView+JCImageView.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/22.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UIImageView+JCImageView.h"

@implementation UIImageView (JCImageView)

/**
 设置图片名
 */
- (void)setImageNamed:(NSString *)named {
    self.image = [UIImage imageNamed:named];
}

/**
 倒影
 */
- (void)imageReflect {
    CGRect frame = self.frame;
    frame.origin.y += (frame.size.height + 1);
    
    UIImageView *reflectionImageView = [[UIImageView alloc] initWithFrame:frame];
    self.clipsToBounds = TRUE;
    reflectionImageView.contentMode = self.contentMode;
    [reflectionImageView setImage:self.image];
    reflectionImageView.transform = CGAffineTransformMakeScale(1.0, -1.0);
    
    CALayer *reflectionLayer = [reflectionImageView layer];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.bounds = reflectionLayer.bounds;
    gradientLayer.position = CGPointMake(reflectionLayer.bounds.size.width / 2, reflectionLayer.bounds.size.height * 0.5);
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[[UIColor clearColor] CGColor],
                            (id)[[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3] CGColor], nil];
    
    gradientLayer.startPoint = CGPointMake(0.5,0.5);
    gradientLayer.endPoint = CGPointMake(0.5,1.0);
    reflectionLayer.mask = gradientLayer;
    
    [self.superview addSubview:reflectionImageView];
}

/**
 画水印
 @param watermark 水印图
 @param rect 水印图的位置
 */
- (void)watermark:(UIImage *)watermark inRect:(CGRect)rect {
    if (!self.image) {
        self.image = watermark;
        return;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    //原图
    [self.image drawInRect:self.bounds];
    //水印图
    [watermark drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.image = newImage;
}

/**
 人脸识别，调整图片显示的位置
 */
- (void)faceDetectWithImage:(UIImage *)aImage fast:(BOOL)fast {
    dispatch_queue_t queue = dispatch_queue_create("com.JCKit.betterface.queue", NULL);
    dispatch_async(queue, ^{
        CIImage *ciImage = aImage.CIImage;
        
        if (!ciImage) {
            ciImage = [CIImage imageWithCGImage:aImage.CGImage];
        }
        
        NSDictionary  *opts = [NSDictionary dictionaryWithObject:(fast ? CIDetectorAccuracyLow:CIDetectorAccuracyHigh) forKey:CIDetectorAccuracy];
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:opts];
        NSArray* features = [detector featuresInImage:ciImage];
        
        if (features.count == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = aImage;
                [[self _imageLayer] removeFromSuperlayer];
            });
        }else {
            self.contentMode = UIViewContentModeScaleAspectFill;
            [self _markAfterFaceDetect:features size:CGSizeMake(CGImageGetWidth(aImage.CGImage), CGImageGetHeight(aImage.CGImage)) image:aImage];
        }
    });
}

- (void)_markAfterFaceDetect:(NSArray *)features size:(CGSize)size image:(UIImage*)aImage {
    CGRect fixedRect = CGRectMake(MAXFLOAT, MAXFLOAT, 0, 0);
    CGFloat rightBorder = 0, bottomBorder = 0;
    for (CIFaceFeature *f in features){
        CGRect oneRect = f.bounds;
        oneRect.origin.y = size.height - oneRect.origin.y - oneRect.size.height;
        
        fixedRect.origin.x = MIN(oneRect.origin.x, fixedRect.origin.x);
        fixedRect.origin.y = MIN(oneRect.origin.y, fixedRect.origin.y);
        
        rightBorder = MAX(oneRect.origin.x + oneRect.size.width, rightBorder);
        bottomBorder = MAX(oneRect.origin.y + oneRect.size.height, bottomBorder);
    }
    
    fixedRect.size.width = rightBorder - fixedRect.origin.x;
    fixedRect.size.height = bottomBorder - fixedRect.origin.y;
    
    CGPoint fixedCenter = CGPointMake(fixedRect.origin.x + fixedRect.size.width / 2.0,
                                      fixedRect.origin.y + fixedRect.size.height / 2.0);
    CGPoint offset = CGPointZero;
    CGSize finalSize = size;
    if (size.width / size.height > self.bounds.size.width / self.bounds.size.height) {
        //move horizonal
        finalSize.height = self.bounds.size.height;
        finalSize.width = size.width/size.height * finalSize.height;
        fixedCenter.x = finalSize.width / size.width * fixedCenter.x;
        fixedCenter.y = finalSize.width / size.width * fixedCenter.y;
        
        offset.x = fixedCenter.x - self.bounds.size.width * 0.5;
        if (offset.x < 0) {
            offset.x = 0;
        } else if (offset.x + self.bounds.size.width > finalSize.width) {
            offset.x = finalSize.width - self.bounds.size.width;
        }
        offset.x = - offset.x;
    } else {
        //move vertical
        finalSize.width = self.bounds.size.width;
        finalSize.height = size.height/size.width * finalSize.width;
        fixedCenter.x = finalSize.width / size.width * fixedCenter.x;
        fixedCenter.y = finalSize.width / size.width * fixedCenter.y;
        
        offset.y = fixedCenter.y - self.bounds.size.height * (1 - 0.618);
        if (offset.y < 0) {
            offset.y = 0;
        } else if (offset.y + self.bounds.size.height > finalSize.height){
            offset.y = finalSize.height = self.bounds.size.height;
        }
        offset.y = - offset.y;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CALayer *layer = [self _imageLayer];
        layer.frame = CGRectMake(offset.x, offset.y, finalSize.width, finalSize.height);
        layer.contents = (id)aImage.CGImage;
    });
}

#define kBETTER_LAYER_NAME @"BETTER_LAYER_NAME"

- (CALayer *)_imageLayer {
    for (CALayer *layer in self.layer.sublayers) {
        if ([layer.name isEqualToString:kBETTER_LAYER_NAME]) {
            return layer;
        }
    }
    
    CALayer *layer = [CALayer layer];
    layer.name = kBETTER_LAYER_NAME;
    layer.actions = @{@"contents": [NSNull null], @"bounds": [NSNull null], @"position": [NSNull null]};
    [self.layer addSublayer:layer];
    return layer;
}

@end
