//
//  JCFPSLabel.h
//  JCKitDemo
//
//  Created by molin.JC on 2016/11/25.
//  Copyright © 2016年 molin. All rights reserved.
//

/**
 FPS:图像领域中的定义，是指画面每秒传输帧数，通俗来讲就是指动画或视频的画面数。FPS是测量用于保存、显示动态视频的信息数量。每秒钟帧数愈多，所显示的动作就会愈流畅.
 也可以理解为我们常说的“刷新率（单位为Hz)
 趋近于60fps才能让用户觉得够流畅,最低也要30fps。
 */
#import <UIKit/UIKit.h>

@interface JCFPSLabel : UILabel

+ (void)windowsAddFPSLabel;

@end
