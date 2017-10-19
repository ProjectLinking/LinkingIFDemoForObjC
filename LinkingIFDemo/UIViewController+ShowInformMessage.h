/**
 * Copyright © 2015-2016 NTT DOCOMO, INC. All Rights Reserved.
 */

#import <UIKit/UIKit.h>

@interface UIViewController (ShowInformMessage)

- (void)ShowInformMessage_showInformWithMessage:(NSString *)message
                                          title:(NSString *)title
                                   okActionName:(NSString *)okActionName
                                        handler:(void (^)(void))okActionHandler
                               cancelActionName:(NSString *)cancelActionName
                                        handler:(void (^)(void))cancelActionHandler;
@end
