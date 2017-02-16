//
//  JCNSUserDefaultsViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/11/30.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCNSUserDefaultsViewController.h"
#import "JCKitMacro.h"
#import "NSURL+JCURL.h"
#import "NSDictionary+JCBlock.h"
#import "NSString+JCString.h"
#import "NSMutableAttributedString+JCAttributedString.h"

#import <objc/message.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

@interface JCUser : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;

@end

@implementation JCUser

- (NSString *)description {
    return [NSString stringWithFormat:@"<name:%@ age:%zd>",self.name, self.age];
}

@end

@interface JCNSUserDefaultsViewController ()

@end

@implementation JCNSUserDefaultsViewController

#pragma mark - Private Methods(自定义方法，只有自己调用)

- (void)save {
//   NSUserDefaults只能存取NSString、NSArray、NSDictionary、NSData、NSNumber类型的数据。
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"保存数据" forKey:@"save"];
    JCUser *user = [JCUser new];
    user.name = @"name";
    user.age = 122;
//    [userDefaults setObject:@[user] forKey:@"user"];
}


- (void)read {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *save = [userDefaults objectForKey:@"save"];
    _Log(@"%@",save);
    
    NSArray *array = [userDefaults objectForKey:@"user"];
    JCUser *user = array[0];
    _Log(@"%@",user);
}

- (void)test1 {
    struct sockaddr_in zero_addr;
    bzero(&zero_addr, sizeof(zero_addr));
    zero_addr.sin_len = sizeof(zero_addr);
    zero_addr.sin_family = AF_INET;
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)&zero_addr);
    SCNetworkReachabilityFlags flags = 0;
    SCNetworkReachabilityGetFlags(ref, &flags);
    _Log(@"%@",YYReachabilityStatusFromFlags(flags, YES));
}

static NSString * YYReachabilityStatusFromFlags(SCNetworkReachabilityFlags flags, BOOL allowWWAN) {
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0) {
        return @"Not Reachable";
    }
    
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) &&
        (flags & kSCNetworkReachabilityFlagsTransientConnection)) {
        return @"Reachable via WiFi";
    }
    
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) && allowWWAN) {
        return @" Reachable via WWAN (2G/3G/4G)";
    }
    
    return @"Reachable via WiFi";
}

- (void)test2 {
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.131:8080/craft4j/share/shareClientOrder.do?orderNo=20161202101213509"];
    _Log(@"%@",url.parameters);
}

- (void)test3 {
    _Log(@"%@",[NSBundle mainBundle].infoDictionary);
}

- (void)test4 {
    NSMutableDictionary *dic = @{@"a":@(NO)}.mutableCopy;
    BOOL size = [dic boolForKey:@"a"];
    if (size) {
         _Log(@"%@",@"12343");
    }
}

- (void)test5 {
    NSString *str = @"<sss>sss<sss>sss<ss>@<s>wwaasdaslka";
    NSString *s = [str stringReplacement:@"|" target:@"<",@">",@"@",nil];
    _Log(@"%@",s);
}

- (void)test6 {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.backgroundColor = [UIColor grayColor];
    button.frame = CGRectMake(30, 200, 50, 25);
    [self.view addSubview:button];
    
    button.bounds = CGRectMake(-10, -10, 70, 50);
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.backgroundColor = [UIColor greenColor];
    button1.frame = CGRectMake(30, 200, 50, 25);
    [self.view addSubview:button1];
//    - (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
}

- (void)test7 {
    NSString *string = @"公元前3000年，印度河流域的居民的数字使用就已经比较普遍，居民们采用了十进位制的计算法。到吠陀时代（公元前1500～公元前500年），雅利安人已意识到数字在生产活动和日常生活中的作用，创造了一些简单的、不完全的数字。\n\n公元前3世纪，印度出现了整套的数字，但各地的写法不一，其中最典型的是婆罗门式，它的独到之处就是从1～9每个数都有专用符号，现代数字就是从它们中脱胎而来的。\n当时，“0”还没有出现。到了笈多时代（300～500年）才有了“0”，叫“舜若”（shunya），表示方式是一个黑点“●”，后来衍变成“0”。\n这样，一套完整的数字便产生了。这项劳动创作也对世界文化做出了巨大的贡献。lll";
    NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:string];
    //富文本样式
    [aAttributedString addAttribute:NSForegroundColorAttributeName  //文字颜色
                            value:[UIColor lightGrayColor]
                            range:NSMakeRange(0, string.length)];
    [aAttributedString addAttribute:NSFontAttributeName             //文字字体
                              value:[UIFont systemFontOfSize:20]
                            range:NSMakeRange(0, string.length * 0.5)];
    
    NSMutableParagraphStyle *paragraphStyleImage = [[NSMutableParagraphStyle alloc]init];
    paragraphStyleImage.alignment = NSTextAlignmentCenter;
    paragraphStyleImage.paragraphSpacingBefore = 10.0; // 首段的间距
    paragraphStyleImage.paragraphSpacing = 10.0;
    [aAttributedString addParagraphStyle:paragraphStyleImage range:NSMakeRange(20, 100)];
    
    NSShadow *shadow = [NSShadow new];
    shadow.shadowOffset = CGSizeMake(9, 6);     // 阴影偏移量
    shadow.shadowColor = [UIColor whiteColor]; // 阴影颜色
    [aAttributedString addAttribute:NSShadowAttributeName value:shadow range:NSMakeRange(0, string.length * 0.5)];
    
//    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
//    attachment.image = [UIImage imageNamed:@"1"];
//    attachment.bounds = CGRectMake(0, 0, 200, 200);
//    [aAttributedString addTextAttachment:attachment];
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor grayColor];
    label.numberOfLines = 0;
    label.attributedText = aAttributedString;
    CGFloat height1 = [aAttributedString heightForAttributeWithWidth:self.view.frame.size.width - 40];
//    - (CGRect)boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options context:(nullable NSStringDrawingContext *)context
//    CGFloat height = [aAttributedString boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
    label.frame = CGRectMake(20, 200, self.view.frame.size.width - 40, height1);
//    [self.view addSubview:label];
    
//    _Log(@"%zd",string.length);
//    __block CGFloat height = 0;
//    [aAttributedString enumerateAttributesInRange:NSMakeRange(0, string.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
//        _Log(@"attrs:%@ \n range:%@",attrs, NSStringFromRange(range));
//        NSString *str = [aAttributedString.string substringWithRange:range];
//        UIFont *font = attrs[@"NSFont"];
//        if (font) {
//            height += [str heightForFont:font width:label.frame.size.width];
//            _Log(@"font:%@, height:%f", font, height);
//        }else {
//            height += [str heightForFont:label.font width:label.frame.size.width];
//            _Log(@"height:%f", height);
//        }
//    }];
//    if (height == 0) {
//        height = 100;
//    }
//    CGRect rect = label.frame;
//    rect.size.height = height;
//    label.frame = rect;
}

- (void)test8 {
    NSString *s1 = @"🙃";
    NSString *s2 = @"⌚";
    NSString *s3 = @"❎";
    NSString *s4 = @"🇨🇭";
    NSString *s5 = @"👁😥😪";
    _Log(@"%@ ---- %d \n %@ ---- %d \n %@ ---- %d \n %@ ---- %d \n %@ ---- %d", s1, [s1 containsEmoji],
                                      s2, [s2 containsEmoji],
         s3, [s3 containsEmoji], s4, [s4 containsEmoji], s5, [s5 containsEmoji]);
    
   NSRegularExpression *regexOld = [NSRegularExpression regularExpressionWithPattern:@"(🙃|⌚)" options:kNilOptions error:nil];
    NSString *s = @"⌚";
    NSRange regexRange = [regexOld rangeOfFirstMatchInString:s options:kNilOptions range:NSMakeRange(0, s.length)];
    _Log(@"%@ -- %d", NSStringFromRange(regexRange), regexRange.location != NSNotFound);
}

//将数字转为
#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);

//获取默认表情数组
- (void)defaultEmoticons {
    NSString *str = @"";
    for (int i=0x1F600; i<=0x1F64F; i++) {
        if (i < 0x1F641 || i > 0x1F644) {
            int sym = EMOJI_CODE_TO_SYMBOL(i);
            NSString *emoT = [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
            str = [NSString stringWithFormat:@"%@|%@", str, emoT];
        }
    }
    JCLog(@"%@", str);
}

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self save];
    [self read];
    [self test1];
    [self test2];
    [self test3];
    [self test4];
    [self test5];
    [self test6];
    [self test7];
    [self test8];
    [self defaultEmoticons];
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
