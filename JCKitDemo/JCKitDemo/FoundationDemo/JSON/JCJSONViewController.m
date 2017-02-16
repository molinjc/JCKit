//
//  JCJSONViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 16/10/20.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCJSONViewController.h"
#import "NSObject+JCJSON.h"
#import "JCKitMacro.h"
#import "NSObject+JCObject.h"

@interface JCBook : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger bookID;
@end
@implementation JCBook
@end

@interface JCBookShelf : NSObject
@property (nonatomic, copy) NSString *bookShelfName;
@property (nonatomic, assign) NSInteger bookShelfID;
@property (nonatomic, strong) NSArray *bookShelfs;
@end
@implementation JCBookShelf
@end

@interface JCReaders : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) JCBook *book;
@end
@implementation JCReaders
- (NSDictionary *)modelPropertyGenericClass {
    return @{@"book":[JCBook class]};
}
@end

@interface JCJSONViewController ()<UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSMutableArray *sels;

@end

@implementation JCJSONViewController

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datas = @[].mutableCopy;
    self.sels = @[].mutableCopy;
    
    [self addCell:@"test1" sel:@"test1"];
    [self addCell:@"test2" sel:@"test2"];
    [self addCell:@"test3" sel:@"test3"];
    [self.view addSubview:self.tableView];
    
    
    JCLog(@"%@",JCLocalizedString(@"A"));
    NSString *ss = NSLocalizedString(@"A", nil);
    JCLog(@"%@",ss);
    
    NSString *j  = @"{notificationCount:2,activityCount:1,newsCount:1,allMessageCount:4}";
    NSDictionary *dic = [NSDictionary modelWithJSON:j];
    JCLog(@"%@",dic);
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods(自定义方法，只有自己调用)

- (void)addCell:(NSString *)title sel:(NSString *)selString {
    [self.datas addObject:title];
    [self.sels addObject:selString];
}


- (void)test1 {
    JCBook *book = [JCBook modelWithJSON:@"{\n    \"name\": \"iOS 编程书\",\n    \"bookID\": 1,\n}"];
    JCLog(@"%@",[book togetherIntoDictionary]);
}

- (void)test2 {
    JCBookShelf *bookShelf = [JCBookShelf modelWithJSON:@"{\n    \"bookShelfName\": \"A级书架\",\n    \"bookShelfID\": 1,\n    \"bookShelfs\": [\n        {\n            \"name\": \"iOS 编程书\",\n            \"bookID\": 1\n        },\n        {\n            \"name\": \"Android 编程书\",\n            \"bookID\": 2\n        },\n        {\n            \"name\": \"C++ 编程书\",\n            \"bookID\": 3\n        }\n    ]\n}"];
    bookShelf.bookShelfs = [bookShelf.bookShelfs modelsWithClass:JCBook.class];
    JCLog(@"%@",[bookShelf togetherIntoDictionary]);
    JCLog(@"bookShelfs：%@",bookShelf.bookShelfs);
}

- (void)test3 {
    JCReaders *readers = [JCReaders modelWithJSON:@"{\n    \"name\": \"读者001\",\n    \"sex\": \"F\",\n    \"age\": 25,\n    \"book\": {\n        \"name\": \"iOS 编程\",\n        \"bookID\": 1001\n    }\n}"];
    JCLog(@"%@",[readers togetherIntoDictionary]);
    if ([readers.book isKindOfClass:[JCBook class]]) {
        JCLog(@"book-name:%@ ，book-ID:%zd",readers.book.name,readers.book.bookID);
    }else {
        JCLog(@"book:%@",readers.book);
    }
    JCLog(@"readers:%@",readers.allPropertys);
}

#pragma mark - Custom Methods(自定义方法，外部可调用)
#pragma mark - Custom Delegate(自定义的代理)
#pragma mark - System Delegate(系统类的代理)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YY"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YY"];
    }
    cell.textLabel.text = self.datas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SEL sel = NSSelectorFromString(self.sels[indexPath.row]);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:sel];
#pragma clang diagnostic pop
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
