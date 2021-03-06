//
//  ViewController.m
//  JCKit
//
//  Created by 林建川 on 16/9/27.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCViewController.h"
#import "JCKitMacro.h"

#import "UIImage+JCImage.h"
#import "NSObject+JCObject.h"

#import "NSObject+JCStram.h"

#import "JCSQLite3.h"

#import "JCFPSLabel.h"
#import "UIBarButtonItem+JCBlock.h"
#if __has_include("NSObject+JCObserverKVO.h")
#define kSCALE 2.0
#else
#define kSCALE 1.0
#endif

@interface JCViewController ()<UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *classNames;

@end


@implementation JCViewController

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titles = @[].mutableCopy;
    self.classNames = @[].mutableCopy;
    [self.view addSubview:self.tableView];
    
    [JCFPSLabel windowsAddFPSLabel];
    self.title = @"JCKit Example";
    [self addCell:@"Foundation Example" class:@"JCFoundationExampleViewController"];
    [self addCell:@"UIKit Example" class:@"JCUIKitExampleViewController"];
    [self addCell:@"CustomerUI Example" class:@"JCCustomerDemoViewController"];
    [self addCell:@"SimplifyUI Example" class:@"JCSimplifyUIExampleViewController"];
    [self.view addSubview:self.imageView];
    self.imageView.frame = CGRectMake(0, 0, 200, 150);
    self.imageView.center = self.view.center;
    [[self.imageView.addStream addKeyPath:@"image"] observeValueForBlock:^(__weak id obj, NSString *keyPath, id oldValue, id newValue) {
        NSLog(@"keyPath:%@",keyPath);
    }];

    
    
//    JCMeasure(@"测试", 10, {JCLog(@"-----------------======");});
    
//    JCLog(@"%f",kSCALE);
//    [self test_Array];
//    [self test_String];
    
    [JCSQLite3 sharedSQLite3].sqliteName = @"test123";
    JCBenchmark(^{
        if ([[JCSQLite3 sharedSQLite3] executeSQLite3Statement:@"CREATE TABLE \"test\" (\"column1\" INTEGER, \"column2\" FLOAT, \"column3\" TEXT)"]) {
            NSLog(@"失败");
        }
        [[JCSQLite3 sharedSQLite3] executeSQLite3Statement:@"replace into \'test\' (\'column1\',\'column2\',\'column3\', ) values (\'1\',\'2.34\',\'测试啦\' ,)"];
        
        [[JCSQLite3 sharedSQLite3] openSQLite3];
        [[JCSQLite3 sharedSQLite3] executeSQLite3Statement:@"SELECT * FROM 'test'" consequence:^(id data) {
            JCLog(@"数据库：%@",data);
        }];
        [[JCSQLite3 sharedSQLite3] closeSQLite3];
    },^(double ms) {
        JCLog(@"JCSQLite3运行的时间：%2f",ms);
    });
    
//    UIBarButtonItem *button = ;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"sss" style:UIBarButtonItemStylePlain target:self action:@selector(ss)];
    self.navigationItem.rightBarButtonItem.badgeValue = @"12";
    JCLog(@"%@ \n %@",[(id)self.navigationItem.rightBarButtonItem view].subviews, self.navigationItem.rightBarButtonItem.customView.superview);
    self.navigationItem.rightBarButtonItem.width = -5;
    
}

- (void)ss {
    JCLog(@"ss");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    JCLog(@"timeStr:%@",JCCompileTime());
    
    self.imageView.image = [UIImage imageNamed:@"banner1"];
    
    /*
     UIImageOrientationUp: 正常
     UIImageOrientationDown: 180度倒
     UIImageOrientationLeft: 顺时针旋转270度，向左
     UIImageOrientationRight: 顺时针旋转90度，向右
     UIImageOrientationUpMirrored: 翻转，像照镜子里的样子
     UIImageOrientationDownMirrored: 180度倒 翻转
     UIImageOrientationLeftMirrored: 顺时针旋转270度，向左翻转
     UIImageOrientationRightMirrored: 顺时针旋转90度，向右翻转
     */
    
    
    /*
    JCLog(@"%@",self.navigationController.viewControllers)
    NSMutableArray *array = [NSMutableArray new];
    [array addObject:self.navigationController.viewControllers.firstObject];
    Class class = NSClassFromString(@"JCCustomerDemoViewController"); // 根据给定的类名创建一个类
    if (class) {
        UIViewController *ctrl = class.new;  // 也可以用[class new],把类给UIViewController
        ctrl.title = @"CustomerUI Example";
        [array addObject:ctrl];
    }
    
    Class class1 = NSClassFromString(@"JCJCCodedLockViewController"); // 根据给定的类名创建一个类
    if (class1) {
        UIViewController *ctrl = class1.new;  // 也可以用[class new],把类给UIViewController
        ctrl.title = @"密码";
        [array addObject:ctrl];
    }
    [self.navigationController setViewControllers:array animated:YES];
    JCLog(@"%@",self.navigationController.viewControllers)
  */
    
//    - (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods(自定义方法，只有自己调用)

- (void)addCell:(NSString *)title class:(NSString *)className {
    [self.titles addObject:title];
    [self.classNames addObject:className];
}


#pragma mark - Custom Methods(自定义方法，外部可调用)
#pragma mark - Custom Delegate(自定义的代理)
#pragma mark - System Delegate(系统类的代理)
#pragma mark - Setter/Getter(懒加载)

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

#pragma mark - Test Methods(测试方法)

- (void)test_String {
    
    NSString *path = @"p0/p1/f";
    JCLog(@"pathComponents:%@",[path.stringByDeletingLastPathComponent stringByAppendingString:@"f.text"]);
    NSString *file = path.pathComponents.lastObject;
//    NSString *file = files[files.count];
    JCLog(@"file:%@ \n %@",file,file.pathExtension);

    
    NSString *string = @"   Lorem    Ipsum dolar  12345  sit  amet.     ";
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSArray *components = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    components = [components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self <> ''"]];
    string = [components componentsJoinedByString:@" "];
    JCLog(@"string:%@",string);
    
    NSString *v = @"1.9.3";
    NSString *v1 = @"0.a.0";
//    vstring characterAtIndex:0];
    int sum = 0;
    int sum1 = 0;
    for (int i=0; i<v.length; i++) {
        int s = [v characterAtIndex:i];
        int s1 = [v1 characterAtIndex:i];
        JCLog(@"%d -- %d",s,s1);
        sum += s;
        sum1 += s1;
    }
    JCLog(@"sum:%d--%d",sum,sum1);
    if (sum1 > sum) {
        JCLog(@"%@",v1);
    }else {
        JCLog(@"%@",v);
    }
}

/**
 *  测试数组遍历
 */
- (void)test_Array {
    NSArray *array = @[@1,@2,@3,@4,@5];
    
    // NSEnumerationConcurrent：各个Block是同时开始执行的。这样遍历的完成顺序是不确定的
    // NSEnumerationReverse：以反序方式遍历。
    [array enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    }];
    
    // 一个个遍历
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //        JCLog(@"%zd --%@",idx,obj);
    }];
    
    NSUInteger index = [array indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JCLog(@"%zd --%@",idx,obj);
        if (idx == 3) {
            return YES;
        }
        return NO;
    }];
    
    //indexesOfObjectsPassingTest
    
    JCLog(@"%zd",index);
}

#pragma mark - UITableViewDataSource or UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YY"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YY"];
    }
    cell.textLabel.text = _titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *className = self.classNames[indexPath.row];
    Class class = NSClassFromString(className); // 根据给定的类名创建一个类
    if (class) {
        UIViewController *ctrl = class.new;  // 也可以用[class new],把类给UIViewController
        ctrl.title = _titles[indexPath.row];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Setter/Getter(懒加载)

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


@end
