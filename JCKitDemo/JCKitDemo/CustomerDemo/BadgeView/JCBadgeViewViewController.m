//
//  JCBadgeViewViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/26.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCBadgeViewViewController.h"
#import "JCBadgeView.h"
#import "UIImage+JCImage.h"
#import "UIColor+JCSeries.h"
#import "NSData+JCData.h"

@interface JCBadgeViewViewController ()

@end

@implementation JCBadgeViewViewController

#pragma mark - Custom Methods(自定义方法，外部可调用)

#pragma mark - Private Methods(自定义方法，只有自己调用)

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JCBadgeView *badgeView = [[JCBadgeView alloc] initWithSuper:self.view position:CGPointMake(0, 0) radius:30];
    badgeView.backgroundColor = [UIColor grayColor];
    badgeView.frame = CGRectMake(20, 100, 40, 40);
//    [self.view addSubview:badgeView];
    
    NSString *text = JCBadgeView.testString;
    NSLog(@"%@",text);
    
    UIImageView *imageView = [[UIImageView alloc] init];//- (UIImage *)imageWithText:(NSString *)text textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize
    UIImage *image = [[UIImage imageWithColor:[UIColor deepSkyBlue] size:CGSizeMake(120, 120)] imageWithText:@"JC" textColor:[UIColor whiteColor] font:[UIFont fontWithName:@"Noteworthy-Bold" size:80.0f]];
    
    
    /// 生成icon
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *path = paths[0];
//    NSLog(@"appicon:%@", path);
//    NSArray *arr = @[@"180", @"167", @"152", @"120", @"87", @"80", @"60", @"58", @"40"];
//    dispatch_async(dispatch_queue_create("com.JCKit.JCCache", DISPATCH_QUEUE_SERIAL), ^{
//        for (NSString *ex in arr) {
//            NSString *np = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"jcAPPIcon-%@.png", ex]];
//            CGFloat wh = [ex floatValue];
//            UIImage *image1 = [image resize:CGSizeMake(wh, wh)];
//            NSData *data = [NSData compressedImage:image1];
//            [fileManager createFileAtPath:np contents:data attributes:nil];
//        }
//    });

    
    imageView.image = [self blurryImage:image withBlurLevel:1.8];
    imageView.frame = CGRectMake(0, 0, 120, 120);
    imageView.center = self.view.center;
    [self.view addSubview:imageView];
}

- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur{
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"
                                  keysAndValues:kCIInputImageKey,inputImage,@"inputRadius",@(blur),nil];
    CIImage *outPutImage = filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef outImage = [context createCGImage:outPutImage fromRect:[inputImage extent]];
    UIImage *img = [UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return img;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Delegate(自定义的代理)
#pragma mark - System Delegate(系统类的代理)
#pragma mark - Setter/Getter(懒加载)

@end
