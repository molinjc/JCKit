//  JCKit.h
//  Created by molin.JC on 2017/3/24.
//  Copyright © 2017年 molin. All rights reserved.

#import <UIKit/UIKit.h>

/** init 快速初始化 */
#import "UIView+JCInit.h"

/** Layout 布局 */
#import "UIScreen+JCScale.h"
#import "UIView+JCLayout.h"

/** MVP 架构 */
#import "JCPresenters.h"

/** Macro 常用宏 */
#import "JCKitMacro.h"

/** BaseController 基础控制器 */
#import "JCTableController.h"

/** BaseView 基础view */
#import "JCTableViewCell.h"

/** UserDataStore 用户数据存储 */
#import "JCArchiveTool.h"

/** Debug 调试 */
#import "UIViewController+JCDealloc.h"
#import "JCFPSLabel.h"

/** Utility 常用功能 */
#import "JCWeakProxy.h"            // 弱引用
#import "JCPhotoLibrary.h"         // 获取系统照片类，要导入AssetsLibrary库
#import "JCReachability.h"         // 网络状态监控
#import "JCKeychain.h"             // 密钥存储
#import "JCAuthorizationManager.h" // 授权管理(权限请求)

/** Analysis-JSON JSON解析 */
#import "NSObject+JCJSON.h"

/** ThirdParty 第三方库 */
#import "JCRequest.h"              // 网络请求
#import "UIImageView+WebCache.h"   // 图片缓存
#import "MJRefresh.h"              // 上拉下拉加载

/** CustomUI */
#import "JCQRCodeScanViewBase.h"   // 二维码扫描界面

/** BaseCategory-UI */
#import "UINavigationController+JCNavigationAttributes.h"
#import "UIBarButtonItem+JCBlock.h"
#import "UIScrollView+JCScrollView.h"
#import "UIGestureRecognizer+JCBlock.h"
#import "UITableViewCell+JCSeparator.h"
#import "UIApplication+JCApplication.h"
#import "UIButton+JCImageTitleStyle.h"
#import "UIButton+JCButtonSimplify.h"
#import "UIColor+JCColor.h"
#import "UIColor+JCSeries.h"
#import "UIControl+JCControl.h"
#import "UIDevice+JCDevice.h"
#import "UIFont+JCScale.h"
#import "JCFontName.h"
#import "UIImage+JCImage.h"
#import "UITextField+JCTextField.h"
#import "CALayer+JCLayer.h"
#import "JCGraphicsUtilities.h"
#import "UIView+JCView.h"
#import "UIWebView+JCJavaScript.h"
#import "UIWebView+JCHTML.h"
#import "UIBezierPath+JCBezierPath.h"

/** BaseCategory-NS */
#import "NSBundle+JCBundle.h"
#import "NSURL+JCURL.h"
#import "NSFileManager+JCFileManager.h"
#import "NSArray+JCBlock.h"
#import "NSData+JCData.h"
#import "NSDate+JCDate.h"
#import "NSDictionary+JCBlock.h"
#import "NSException+JCException.h"
#import "NSNumber+JCNumber.h"
#import "NSObject+JCObject.h"
#import "NSString+JCString.h"
#import "NSTimer+JCBlock.h"
