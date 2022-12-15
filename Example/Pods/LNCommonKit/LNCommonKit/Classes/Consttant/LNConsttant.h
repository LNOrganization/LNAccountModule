//
//  LNConsttant.h
//  LNCommonKit
//
//  Created by Lenny on 2022/12/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define LN_SAFE_BLOCK_CALL(Block, ...) ({ !Block ? nil : Block(__VA_ARGS__); })


// 1.系统相关宏定义

/** 1.设备状态条,导航栏,tabbar高度 */
#define LN_HEIGHT_STATUSBAR     20.f // 状态条高度
#define LN_HEIGHT_NAVIGATIONBAR 44.f // 导航栏高度
#define LN_HEIGHT_TABBAR        49.f // tabbar高度

/** 2.设备屏幕宽度和高度(支持横屏) */
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000 // 当前Xcode支持iOS8及以上
#define LN_SCREEN_WIDTH ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)
#define LN_SCREEN_HEIGHT ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)
#define LN_SCREEN_SIZE ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale):[UIScreen mainScreen].bounds.size)
#else
#define LN_SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define LN_SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height
#define LN_SCREEN_SIZE      [UIScreen mainScreen].bounds.size
#endif

/**
 *  3.设备类型
 *  设备屏幕高度:IPHONE4(iPhone4,iPhone4s)480;IPHONE5(iPhone5,iPhone5s)568;IPHONE6 667;IPHONE6PLUS 736.
 *  EPSILON是最小误差,DBL_EPSILON是双浮点型(double)最小误差,是EPSILON+X不等于X的最小的正数
 */
#if TARGET_IPHONE_SIMULATOR // 模拟器
#define IPHONE4             ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )
#define IPHONE5             ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IPHONE6             ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )667 ) < DBL_EPSILON )
#define IPHONE6PLUS         ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )736 ) < DBL_EPSILON )
#elif TARGET_OS_IPHONE // 真机
#define IPHONE4             ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )
#define IPHONE5             ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IPHONE6             ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )667 ) < DBL_EPSILON )
#define IPHONE6PLUS         ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )736 ) < DBL_EPSILON )
#endif
// 判断是否为iPhone
#define LN_IS_IPHONE           (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
// 判断是否为iPad
#define LN_IS_IPAD             (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
// 判断是否为ipod
#define LN_IS_IPOD             ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])


/**
 *  4.设备系统版本
 */
#define iOS6_LATER          ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
#define iOS7_LATER          ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
#define iOS8_LATER          ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
#define iOS9_LATER          ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)
#define iOS10_LATER          ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)
#define iOS11_LATER          ([[UIDevice currentDevice].systemVersion floatValue] >= 11.0)
#define iOS12_LATER          ([[UIDevice currentDevice].systemVersion floatValue] >= 12.0)
#define iOS13_LATER          ([[UIDevice currentDevice].systemVersion floatValue] >= 13.0)
#define iOS14_LATER          ([[UIDevice currentDevice].systemVersion floatValue] >= 14.0)

//获取系统版本
#define IOS_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
//判断 iOS 8 或更高的系统版本
#define IOS_VERSION_8_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0)? (YES):(NO))


/** 5.获取temp,沙盒Document,沙盒Cache目录 */
#define LN_PATH_TEMP        NSTemporaryDirectory()
#define LN_PATH_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
#define LN_PATH_CACHE       [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

/** 6.ARC/MRC */
#if __has_feature(objc_arc)
// ARC
#else
// MRC

#endif

 

//2.自定义宏

 

/** 1.颜色字体 */
#define LN_COLOR_HEX(x)              ([UIColor colorWithHexColor:(x)])
#define LN_COLOR(r,g,b)              ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:255/255.0])
#define LN_COLOR_ALPHA(r,g,b,a)      ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)])
#define LN_COLOR_RANDOM              ([UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0])
#define LN_FONT(x)                   ([UIFont systemFontOfSize:(x)])

/** 2.空值判断 */
#define LN_IS_EMPTY_STR(_str)        (((_str) == nil) || ([(_str) isEqual:[NSNull null]]) ||([(_str)isEqualToString:@""]))
#define LN_IS_EMPTY_ARR(_arr)        (((_arr) == nil) || ([(_arr) isEqual:[NSNull null]]) ||([(_arr) count] == 0))

/** 3.单例 */
// 声明单例
#undef  LN_SINGLETON_DEFINE
#define LN_SINGLETON_DEFINE( __class ) \
+ (__class *)sharedInstance;
// 实现单例
#undef  LN_SINGLETON_IMPLEMENT
#define LN_SINGLETON_IMPLEMENT( __class ) \
+ (__class *)sharedInstance \
{ \
static __class * __singleton__ = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
__singleton__ = [[__class alloc] init]; \
}); \
return __singleton__; \
}

/** 4.打印日志 */
#ifdef DEBUG
#define ZBLog(...)  NSLog(__VA_ARGS__)
#define LN_LOG_INT(N) NSLog(@"%d",(N))
#define LN_LOG_FLOAT(F) NSLog(@"%f",(F))
#define LN_LOG_INTEGER(I) NSLog(@"%ld",(long)(I))
#else
#define ZBLog(...)
#define LN_LOG_INT(N)
#define LN_LOG_FLOAT(F)
#define LN_LOG_INTEGER(I)
#endif

/** 5.weakself/strongself */
#define LN_WEAK_SELF(type)  __weak typeof(type) weak##type = type;
#define LN_STRONG_SELF(type)  __strong typeof(weak##type) strong##type = weak##type;

/** 6.GCD */
// GCD - 一次性执行
#define LN_DISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);
// GCD - 在Main线程上运行
#define LN_DISPATCH_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);
// GCD - 开启异步线程

#define LN_DISPATCH_GLOBAL_QUEUE_DEFAULT(globalQueueBlock) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlock);

 

//获取屏幕的宽和高
#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height
//设置随机颜色
#define LRRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]
//设置RGB和RGB颜色
#define LRRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define LRRGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]
// clear背景颜色
#define LRClearColor [UIColor clearColor]

//判断是否为iPhone
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//判断是否为iPad
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//判断是否为ipod
#define IS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])
// 判断是否为 iPhone 5SE
#define iPhone5SE [[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 568.0f
// 判断是否为iPhone 6/6s
#define iPhone6_6s [[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 667.0f
// 判断是否为iPhone 6Plus/6sPlus
#define iPhone6Plus_6sPlus [[UIScreen mainScreen] bounds].size.width == 414.0f && [[UIScreen mainScreen] bounds].size.height == 736.0f
//获取系统版本
#define IOS_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
//判断 iOS 8 或更高的系统版本
#define IOS_VERSION_8_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0)? (YES):(NO))
//判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif
#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

//沙盒目录文件
//获取temp
#define kPathTemp NSTemporaryDirectory()
//获取沙盒 Document
#define kPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒 Cache
#define kPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

//NSLog
#define NSLog(format, ...) do {                                                                          \
    fprintf(stderr, "<%s : %d> %s\n",                                           \
    [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
    __LINE__, __func__);                                                        \
    (NSLog)((format), ##__VA_ARGS__);                                           \
    fprintf(stderr, "-------\n");                                               \
} while (0)


@interface LNConsttant : NSObject

@end

NS_ASSUME_NONNULL_END
