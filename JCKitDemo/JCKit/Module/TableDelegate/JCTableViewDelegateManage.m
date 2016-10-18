//
//  JCTableViewDelegateManage.m
//  JCKitDemo
//
//  Created by molin.JC on 16/10/18.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCTableViewDelegateManage.h"

@implementation JCTableViewDelegateManage

+ (JCTableViewDelegateBase *)tableViewDelegateBase {
    return [JCTableViewDelegateBase new];
}

+ (JCTableViewDelegateSection *)tableViewDelegateSection {
    return [JCTableViewDelegateSection new];
}

+ (JCTableViewDelegateHeaderHeight *)tableViewDelegateHeaderHeight {
    return [JCTableViewDelegateHeaderHeight new];
}

@end
