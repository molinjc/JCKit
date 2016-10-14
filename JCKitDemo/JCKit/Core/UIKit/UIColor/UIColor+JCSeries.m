//
//  UIColor+JCSeries.m
//  JCKit
//
//  Created by 林建川 on 16/9/28.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UIColor+JCSeries.h"

#define RGB16(value) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:1.0]

@implementation UIColor (JCSeries)

#pragma mark - **************** 红色系

/** 薄雾玫瑰*/
+ (UIColor *)mistyRose {
    return RGB16(0xFFE4E1);
}

/** 浅鲑鱼色*/
+ (UIColor *)lightSalmon {
    return RGB16(0xFFA07A);
}

/** 淡珊瑚色*/
+ (UIColor *)lightCoral {
    return RGB16(0xF08080);
}

/** 鲑鱼色*/
+ (UIColor *)salmonColor {
    return RGB16(0xFA8072);
}

/** 珊瑚色*/
+ (UIColor *)coralColor {
    return RGB16(0xFF7F50);
}

/** 番茄*/
+ (UIColor *)tomatoColor {
    return RGB16(0xFF6347);
}

/** 橙红色*/
+ (UIColor *)orangeRed {
    return RGB16(0xFF4500);
}

/** 印度红*/
+ (UIColor *)indianRed {
    return RGB16(0xCD5C5C);
}

/** 猩红*/
+ (UIColor *)crimsonColor {
    return RGB16(0xDC143C);
}

/** 耐火砖*/
+ (UIColor *)fireBrick {
    return RGB16(0xB22222);
}

#pragma mark - **************** 黄色系

/** 玉米色*/
+ (UIColor *)cornColor {
    return RGB16(0xFFF8DC);
}
/** 柠檬薄纱*/
+ (UIColor *)LemonChiffon {
    return RGB16(0xFFFACD);
}

/** 苍金麒麟*/
+ (UIColor *)paleGodenrod {
    return RGB16(0xEEE8AA);
}

/** 卡其色*/
+ (UIColor *)khakiColor {
    return RGB16(0xF0E68C);
}

/** 金色*/
+ (UIColor *)goldColor {
    return RGB16(0xFFD700);
}

/** 雌黄*/
+ (UIColor *)orpimentColor {
    return RGB16(0xFFC64B);
}

/** 藤黄*/
+ (UIColor *)gambogeColor {
    return RGB16(0xFFB61E);
}
/** 雄黄*/
+ (UIColor *)realgarColor {
    return RGB16(0xE9BB1D);
}

/** 金麒麟色*/
+ (UIColor *)goldenrod {
    return RGB16(0xDAA520);
}

/** 乌金*/
+ (UIColor *)darkGold {
    return RGB16(0xA78E44);
}

#pragma mark - **************** 绿色系

/** 苍绿*/
+ (UIColor *)paleGreen {
    return RGB16(0x98FB98);
}

/** 淡绿色*/
+ (UIColor *)lightGreen {
    return RGB16(0x90EE90);
}

/** 春绿*/
+ (UIColor *)springGreen {
    return RGB16(0x2AFD84);
}

/** 绿黄色*/
+ (UIColor *)greenYellow {
    return RGB16(0xADFF2F);
}

/** 草坪绿*/
+ (UIColor *)lawnGreen {
    return RGB16(0x7CFC00);
}

/** 酸橙绿*/
+ (UIColor *)limeColor {
    return RGB16(0x00FF00);
}

/** 森林绿*/
+ (UIColor *)forestGreen {
    return RGB16(0x228B22);
}

/** 海洋绿*/
+ (UIColor *)seaGreen {
    return RGB16(0x2E8B57);
}

/** 深绿*/
+ (UIColor *)darkGreen {
    return RGB16(0x006400);
}

/** 橄榄(墨绿)*/
+ (UIColor *)olive {
    return RGB16(0x556B2F);
}

#pragma mark - **************** 青色系

/** 淡青色*/
+ (UIColor *)lightCyan {
    return RGB16(0xE1FFFF);
}

/** 苍白绿松石*/
+ (UIColor *)paleTurquoise {
    return RGB16(0xAFEEEE);
}

/** 绿碧*/
+ (UIColor *)aquamarine {
    return RGB16(0x7FFFD4);
}

/** 绿松石*/
+ (UIColor *)turquoise {
    return RGB16(0x40E0D0);
}

/** 适中绿松石*/
+ (UIColor *)mediumTurquoise {
    return RGB16(0x48D1CC);
}

/** 美团色*/
+ (UIColor *)meituanColor {
    return RGB16(0x2BB8AA);
}

/** 浅海洋绿*/
+ (UIColor *)lightSeaGreen {
    return RGB16(0x20B2AA);
}

/** 深青色*/
+ (UIColor *)darkCyan {
    return RGB16(0x008B8B);
}

/** 水鸭色*/
+ (UIColor *)tealColor {
    return RGB16(0x008080);
}

/** 深石板灰*/
+ (UIColor *)darkSlateGray {
    return RGB16(0x2F4F4F);
}

#pragma mark - **************** 蓝色系

/** 天蓝色*/
+ (UIColor *)skyBlue {
    return RGB16(0xE1FFFF);
}

/** 淡蓝*/
+ (UIColor *)lightBLue {
    return RGB16(0xADD8E6);
}

/** 深天蓝*/
+ (UIColor *)deepSkyBlue {
    return RGB16(0x00BFFF);
}

/** 道奇蓝*/
+ (UIColor *)doderBlue {
    return RGB16(0x1E90FF);
}

/** 矢车菊*/
+ (UIColor *)cornflowerBlue {
    return RGB16(0x6495ED);
}

/** 皇家蓝*/
+ (UIColor *)royalBlue {
    return RGB16(0x4169E1);
}

/** 适中的蓝色*/
+ (UIColor *)mediumBlue {
    return RGB16(0x0000CD);
}

/** 深蓝*/
+ (UIColor *)darkBlue {
    return RGB16(0x00008B);
}

/** 海军蓝*/
+ (UIColor *)navyColor {
    return RGB16(0x000080);
}

/** 午夜蓝*/
+ (UIColor *)midnightBlue {
    return RGB16(0x191970);
}

#pragma mark - **************** 紫色系

/** 薰衣草*/
+ (UIColor *)lavender {
    return RGB16(0xE6E6FA);
}

/** 蓟*/
+ (UIColor *)thistleColor {
    return RGB16(0xD8BFD8);
}

/** 李子*/
+ (UIColor *)plumColor {
    return RGB16(0xDDA0DD);
}

/** 紫罗兰*/
+ (UIColor *)violetColor {
    return RGB16(0xEE82EE);
}

/** 适中的兰花紫*/
+ (UIColor *)mediumOrchid {
    return RGB16(0xBA55D3);
}

/** 深兰花紫*/
+ (UIColor *)darkOrchid {
    return RGB16(0x9932CC);
}

/** 深紫罗兰色*/
+ (UIColor *)darkVoilet {
    return RGB16(0x9400D3);
}

/** 泛蓝紫罗兰*/
+ (UIColor *)blueViolet {
    return RGB16(0x8A2BE2);
}

/** 深洋红色*/
+ (UIColor *)darkMagenta {
    return RGB16(0x8B008B);
}

/** 靛青*/
+ (UIColor *)indigoColor {
    return RGB16(0x4B0082);
}

#pragma mark - **************** 灰色系

/** 白烟*/
+ (UIColor *)whiteSmoke {
    return RGB16(0xF5F5F5);
}

/** 鸭蛋*/
+ (UIColor *)duckEgg {
    return RGB16(0xE0EEE8);
}

/** 亮灰*/
+ (UIColor *)gainsboroColor {
    return RGB16(0xDCDCDC);
}

/** 蟹壳青*/
+ (UIColor *)carapaceColor {
    return RGB16(0xBBCDC5);
}

/** 银白色*/
+ (UIColor *)silverColor {
    return RGB16(0xC0C0C0);
}

/** 暗淡的灰色*/
+ (UIColor *)dimGray {
    return RGB16(0x696969);
}

#pragma mark - **************** 白色系

/** 海贝壳*/
+ (UIColor *)seaShell {
    return RGB16(0xFFF5EE);
}

/** 雪*/
+ (UIColor *)snowColor {
    return RGB16(0xFFFAFA);
}

/** 亚麻色*/
+ (UIColor *)linenColor {
    return RGB16(0xFAF0E6);
}

/** 花之白*/
+ (UIColor *)floralWhite {
    return RGB16(0xFFFAF0);
}

/** 老饰带*/
+ (UIColor *)oldLace {
    return RGB16(0xFDF5E6);
}

/** 象牙白*/
+ (UIColor *)ivoryColor {
    return RGB16(0xFFFFF0);
}

/** 蜂蜜露*/
+ (UIColor *)honeydew {
    return RGB16(0xF0FFF0);
}

/** 薄荷奶油*/
+ (UIColor *)mintCream {
    return RGB16(0xF5FFFA);
}

/** 蔚蓝色*/
+ (UIColor *)azureColor {
    return RGB16(0xF0FFFF);
}

/** 爱丽丝蓝*/
+ (UIColor *)aliceBlue {
    return RGB16(0xF0F8FF);
}

/** 幽灵白*/
+ (UIColor *)ghostWhite {
    return RGB16(0xF8F8FF);
}

/** 淡紫红*/
+ (UIColor *)lavenderBlush {
    return RGB16(0xFFF0F5);
}

/** 米色*/
+ (UIColor *)beigeColor {
    return RGB16(0xF5F5DD);
}

#pragma mark - **************** 棕色系

/** 黄褐色*/
+ (UIColor *)tanColor {
    return RGB16(0xD2B48C);
}

/** 玫瑰棕色*/
+ (UIColor *)rosyBrown {
    return RGB16(0xBC8F8F);
}

/** 秘鲁*/
+ (UIColor *)peruColor {
    return RGB16(0xCD853F);
}

/** 巧克力*/
+ (UIColor *)chocolateColor {
    return RGB16(0xD2691E);
}

/** 古铜色*/
+ (UIColor *)bronzeColor {
    return RGB16(0xB87333);
}

/** 黄土赭色*/
+ (UIColor *)siennaColor {
    return RGB16(0xA0522D);
}

/** 马鞍棕色*/
+ (UIColor *)saddleBrown {
    return RGB16(0x8B4513);
}

/** 土棕*/
+ (UIColor *)soilColor {
    return RGB16(0x734A12);
}

/** 栗色*/
+ (UIColor *)maroonColor {
    return RGB16(0x800000);
}

/** 乌贼墨棕*/
+ (UIColor *)inkfishBrown {
    return RGB16(0x5E2612);
}

#pragma mark - **************** 粉色系

/** 水粉*/
+ (UIColor *)waterPink {
    return RGB16(0xF3D3E7);
}

/** 藕色*/
+ (UIColor *)lotusRoot {
    return RGB16(0xEDD1D8);
}

/** 浅粉红*/
+ (UIColor *)lightPink {
    return RGB16(0xFFB6C1);
}

/** 适中的粉红*/
+ (UIColor *)mediumPink {
    return RGB16(0xFFC0CB);
}

/** 桃红*/
+ (UIColor *)peachRed {
    return RGB16(0xF47983);
}

/** 苍白的紫罗兰红色*/
+ (UIColor *)paleVioletRed {
    return RGB16(0xDB7093);
}

/** 深粉色*/
+ (UIColor *)deepPink {
    return RGB16(0xFF1493);
}

@end
