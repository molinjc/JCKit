//
//  JCFPSLabel.h
//  Created by molin.JC on 2016/11/25.
//  Copyright © 2016年 molin. All rights reserved.
//

/**
 FPS:图像领域中的定义，是指画面每秒传输帧数，通俗来讲就是指动画或视频的画面数。FPS是测量用于保存、显示动态视频的信息数量。每秒钟帧数愈多，所显示的动作就会愈流畅.
 也可以理解为我们常说的“刷新率（单位为Hz)
 趋近于60fps才能让用户觉得够流畅,最低也要30fps。
 
 用绘制的方式构建的动画，必然需要不断的刷新绘制的内容来呈现流畅的动画，CADisplayLink就像是一个定时器，每隔几毫秒刷新一次屏幕。能让我们以和屏幕刷新频率相同的频率去刷新我们绘制到屏幕上的内容.
 当CADisplayLink注册到runloop以后，屏幕刷新的时候就会调用绑定到它上面的target所拥有的selector方法。停止CADisplayLink的运行非常的简单，只需要调用它的invalidate方法。
 */
#import <UIKit/UIKit.h>

@interface JCFPSLabel : UILabel

+ (void)windowsAddFPSLabel;

@end
