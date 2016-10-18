//
//  JCTableViewDelegateManage.h
//  JCKitDemo
//
//  Created by molin.JC on 16/10/18.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JCTableViewDelegateBase.h"
#import "JCTableViewDelegateSection.h"
#import "JCTableViewDelegateHeaderHeight.h"

@interface JCTableViewDelegateManage : NSObject

+ (JCTableViewDelegateBase *)tableViewDelegateBase;

+ (JCTableViewDelegateSection *)tableViewDelegateSection;

+ (JCTableViewDelegateHeaderHeight *)tableViewDelegateHeaderHeight;

@end
