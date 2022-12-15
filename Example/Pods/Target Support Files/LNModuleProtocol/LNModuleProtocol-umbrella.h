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

#import "LNAccountModuleProtocol.h"
#import "LNFeedModuleProtocol.h"
#import "LNLiveModuleProtocol.h"
#import "LNModuleProtocol.h"
#import "LNProtocolConfig.h"
#import "LNUserCenterModuleProtocol.h"
#import "LNVideoModuleProtocol.h"

FOUNDATION_EXPORT double LNModuleProtocolVersionNumber;
FOUNDATION_EXPORT const unsigned char LNModuleProtocolVersionString[];

