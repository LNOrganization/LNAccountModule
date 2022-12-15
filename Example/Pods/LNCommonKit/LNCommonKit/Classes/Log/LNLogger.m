//
//  LNLogger.m
//  AIIoTOpenSDK
//
//  Created by Lenny on 2021/3/16.
//

#import "LNLogger.h"

//日志打印前缀
static NSString * _Nonnull LogPrefixs[] = {
    [LNLogLevelDEBUG]   = @"[🐞AIIoTOpenSDK DEBUG]",
    [LNLogLevelINFO]    = @"[🌴AIIoTOpenSDK INFO]",
    [LNLogLevelWARNING] = @"[⚠️AIIoTOpenSDK WARN]",
    [LNLogLevelERROR]   = @"[🔴AIIoTOpenSDK ERROR]"
};


//static __inline__ __attribute__((always_inline)) NSDateFormatter * loggerDataFormatter(void){
//    static NSDateFormatter *format;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        format = [[NSDateFormatter alloc] init];
//        format.dateFormat = @"yy/MM/dd HH:mm:ss:SSS";
//    });
//    return format;
//}

//static __inline__ __attribute__((always_inline)) void __showlog(const char *cString,LNLogLevel level,NSString *author){
//    NSString *prefix = LogPrefixs[level];
//    NSDateFormatter *format = loggerDataFormatter();
//    const char *dateString = [[format stringFromDate:[NSDate date]] UTF8String];
//    if (author) {
//        printf("%s %s<%s>: %s \n",[prefix UTF8String],dateString,[author UTF8String],cString);
//    }else{
//        printf("%s %s: %s \n",[prefix UTF8String],dateString,cString);
//    }
//}

static __inline__ __attribute__((always_inline)) void __showNoDatelog(const char *cString, LNLogLevel level, NSString *author){
    NSString *prefix = LogPrefixs[level];
    if (author) {
        NSLog(@"%@<%@>: %s",prefix, author, cString);
    }else{
        NSLog(@"%@: %s",prefix, cString);
    }
}

#pragma mark ====================================
#pragma mark - Public API

static LNLogLevel __curLogLevel = LNLogLevelDEBUG;
void setLogLevel(LNLogLevel level){
    __curLogLevel = level;
}

LNLogLevel currentLogLevel(void){
    return __curLogLevel;
}


//void saveLog(NSString *log, NSUInteger level,NSString *author);

#ifndef doLog

#define doLog(__level,author,...)           \
    if ((__curLogLevel > __level)) {        \
        return;                             \
    }                                       \
    va_list argList;                        \
    va_start(argList, message);             \
    NSString *logString = [[NSString alloc] initWithFormat:message arguments:argList];                 \
    const char *cString = [logString UTF8String];   \
    __showNoDatelog(cString, __level,author);     \
    va_end(argList);                        \
//    saveLog(logString,__level,author);      \

#endif

//static void doLog(LNLogLevel level, NSString *author, NSString *message,...)
//{
//    if ((__curLogLevel > level)) {
//        return;
//    }
//    va_list argList;
//    va_start(argList, message);
//    NSString *logString = [[NSString alloc] initWithFormat:message arguments:argList];
//    const char *cString = [logString UTF8String];
//    __showlog(cString, level,author);
//    va_end(argList);
//}

void DEBUGLog(NSString *message,...){
    doLog(LNLogLevelDEBUG,nil);
}

__attribute__((overloadable)) void DEBUGLog(NSString *author,NSString *message,...){
    doLog(LNLogLevelDEBUG,author);
}


void INFOLog(NSString *message,...){
    doLog(LNLogLevelINFO,nil);
}

__attribute__((overloadable)) void INFOLog(NSString *author,NSString *message,...){
    doLog(LNLogLevelINFO,author);
}

void WARNINGLog(NSString *message,...){
    doLog(LNLogLevelWARNING,nil);
    
}

__attribute__((overloadable)) void WARNINGLog(NSString *author,NSString *message,...){
    doLog(LNLogLevelWARNING,author);
}

void ERRORLog(NSString *message,...){
    doLog(LNLogLevelERROR,nil);
}

__attribute__((overloadable)) void ERRORLog(NSString *author,NSString *message,...){
    doLog(LNLogLevelERROR,author);
}


@implementation LNLogger
//设置日志级别，default LNLogLevelDEBUG
+ (void)setLogLevel:(LNLogLevel)level
{
    setLogLevel(level);
}

+ (LNLogLevel)currentLogLevel
{
    return currentLogLevel();
}

- (void)isInvalid
{
    //此处代码不可删除
    NSString *platformId = [NSString stringWithFormat:@"U2FsdGVkX1911N1+AytJfWou2fcjlkD1wE4P+RuYv4/PnnvlAuONBrjUOoHnTNhA"];
    if ([@"KingSoft" isEqualToString:platformId]) {
        NSLog(@"%@", platformId);
    }
}


@end
