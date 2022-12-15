//
//  LNLogger.h
//  AIIoTOpenSDK
//
//  Created by Lenny on 2021/3/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//系统日志级别
typedef NS_ENUM(NSUInteger,LNLogLevel) {
    /*! 显示包括(DEBUGLog,INFOLog,WARNINGLog,ERRORLog的Log)*/
    LNLogLevelDEBUG   = 0,
    /*! 显示包括(INFOLog,WARNINGLog,ERRORLog的Log)*/
    LNLogLevelINFO    = 1,
    /*! 显示包括(WARNINGLog,ERRORLog的Log)*/
    LNLogLevelWARNING = 2,
    /*! 只显示ERRORLog的log*/
    LNLogLevelERROR   = 3,
    /*!  关闭所有日志*/
    LNLogLevelNONE    = 4,
};


////////////////////////////////////////////////////////
#define LOGDECL extern void
#define LOGDECL2 __attribute__((overloadable)) extern void

LOGDECL  DEBUGLog(NSString *message,...) NS_FORMAT_FUNCTION(1,2);
LOGDECL2 DEBUGLog(NSString *author,NSString *message,...) NS_FORMAT_FUNCTION(1,3);

LOGDECL  INFOLog(NSString *message,...) NS_FORMAT_FUNCTION(1,2);
LOGDECL2 INFOLog(NSString *author,NSString *message,...) NS_FORMAT_FUNCTION(1,3);

LOGDECL  WARNINGLog(NSString *message,...) NS_FORMAT_FUNCTION(1,2);
LOGDECL2 WARNINGLog(NSString *author,NSString *message,...) NS_FORMAT_FUNCTION(1,3);

LOGDECL  ERRORLog(NSString *message,...) NS_FORMAT_FUNCTION(1,2);
LOGDECL2 ERRORLog(NSString *author,NSString *message,...) NS_FORMAT_FUNCTION(1,3);



@interface LNLogger : NSObject

//设置日志级别，default LNLogLevelDEBUG
+ (void)setLogLevel:(LNLogLevel)level;

+ (LNLogLevel)currentLogLevel;


@end


NS_ASSUME_NONNULL_END
