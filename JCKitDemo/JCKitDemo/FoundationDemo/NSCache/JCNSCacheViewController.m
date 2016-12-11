//
//  JCNSCacheViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/11/30.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCNSCacheViewController.h"
#import "JCKitMacro.h"
#import "JCCache.h"
#import "UIImage+JCImage.h"
#import "UIImageView+JCWebImage.h"

@interface JCNSCacheViewController ()
{
    UIImageView * _imageView;
}
@end

@implementation JCNSCacheViewController

#pragma mark - Private Methods(自定义方法，只有自己调用)

- (void)save {
    NSCache *_cache = [[NSCache alloc] init];
    [_cache setObject:@"保存" forKey:@"save"];
}

- (void)read {
    NSCache *_cache = [[NSCache alloc] init];
    NSString *save = [_cache objectForKey:@"save"];
    JCLog(@"%@",save);
}

- (void)download:(NSString *)urlS {
    JCLog(@"======");
    
    NSURL *url=[NSURL  URLWithString:urlS];
    //创建请求对象
    NSURLRequest *req=[NSURLRequest  requestWithURL:url];
    //发送请求连接
    [NSURLConnection  sendAsynchronousRequest:req queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        JCLog(@"+++++%@,",connectionError);
        if (connectionError==nil) {
            [[JCCache sharedCache] saveObject:[UIImage animatedGIFWithData:data] data:data key:urlS];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _imageView.image = [UIImage animatedGIFWithData:data];
            });
        } else {
        }
    }];
}

- (void)showImage {
//    NSString *urlS = @"http://up.2cto.com/2013/1017/20131017034244189.jpg";
    NSString *urlS = @"http://img1.ph.126.net/iVUAqc-tPcFeF7RVmLoALQ==/2165949945888629440.gif";
//    NSData *data = [[JCCache sharedCache] dataFromCacheForKey:urlS];
//    UIImage *image = [UIImage imageWithData:data];
    UIImage *image = [[JCCache sharedCache] imageGIFFromCacheForKey:urlS];
    
    if (!image) {
        [self download:urlS];
        return;
    }
    _imageView.image = image;
}

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self save];
    [self read];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.frame = CGRectMake(10, 74, self.view.frame.size.width - 20, 300);
    _imageView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_imageView];
    
    [self showImage];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 385, self.view.frame.size.width - 20, 300)];
    imageView2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:imageView2];
    [imageView2 setImageGIFWithURL:
     [NSURL URLWithString:@"http://img1.ph.126.net/iVUAqc-tPcFeF7RVmLoALQ==/2165949945888629440.gif"]
                  placeholderImage:[UIImage imageNamed:@"1"]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.backgroundColor = [UIColor lightGrayColor];
    [button setImage:[[UIImage animatedGIFNamed:@"waiting"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    button.frame = CGRectMake(100, 686, 100, 49);
    [self.view addSubview:button];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Methods(自定义方法，外部可调用)
#pragma mark - Custom Delegate(自定义的代理)
#pragma mark - System Delegate(系统类的代理)
#pragma mark - Setter/Getter(懒加载)

@end
