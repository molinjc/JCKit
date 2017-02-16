//
//  JCCustomerDemoViewController.m
//  JCKitDemo
//
//  Created by 林建川 on 16/10/9.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCCustomerDemoViewController.h"

@interface JCCustomerDemoViewController ()

@end

@implementation JCCustomerDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCell:@"JCPopupBaseView" class:@"JCPopupViewController"];
    [self addCell:@"跑马灯View" class:@"JCMarqueeViewController"];
    [self addCell:@"滚动图" class:@"JCAdvertisementViewController"];
    [self addCell:@"密码锁" class:@"JCJCCodedLockViewController"];
    [self addCell:@"二维码扫描" class:@"JCScanViewController"];
    [self addCell:@"角标" class:@"JCBadgeViewViewController"];
    [self addCell:@"Photo" class:@"JCGetPhotoViewController"];
    [self addCell:@"ProgressButton" class:@"JCButtonViewController"];
    
//    [self test];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)test {
    UIImage *image = [UIImage imageNamed:@"tabbar_mainframeHL"];
//    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.5, image.size.width * 0.5, image.size.height * 0.5, image.size.width * 0.5 )];
    UIImageView *imageview = [UIImageView new];
    imageview.frame = CGRectMake(10, 200, self.view.frame.size.width - 20, 200);
    imageview.image = image;
    [self.view addSubview:imageview];
}

@end
