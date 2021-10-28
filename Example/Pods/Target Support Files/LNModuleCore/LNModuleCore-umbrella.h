#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "LNModuleAppDelegate.h"
#import "LNModuleBaseProtocol.h"
#import "LNModuleCore.h"
#import "LNModuleManager.h"

FOUNDATION_EXPORT double LNModuleCoreVersionNumber;
FOUNDATION_EXPORT const unsigned char LNModuleCoreVersionString[];

