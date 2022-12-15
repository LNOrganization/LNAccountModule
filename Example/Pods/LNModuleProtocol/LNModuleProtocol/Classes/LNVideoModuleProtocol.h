//
//  LNVideoModuleProtocol.h
//  LNModuleProtocol
//
//  Created by Lenny on 2021/10/17.
//

#import "LNProtocolConfig.h"

@protocol LNVideoModuleProtocol <LNModuleBaseProtocol>

- (UIViewController *)getPayerViewControllerWithUrlStr:(NSString *)urlStr;

- (UIViewController *)getRecommendTableViewController;

- (UIViewController *)getFocusTableViewController;

@end
