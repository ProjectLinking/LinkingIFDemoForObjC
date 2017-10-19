/**
 * Copyright © 2015-2016 NTT DOCOMO, INC. All Rights Reserved.
 * ------説明----------
 * アラートを表示する
 */

#import "UIViewController+ShowInformMessage.h"

@implementation UIViewController (ShowInformMessage)

- (void)ShowInformMessage_showInformWithMessage:(NSString *)message
                                          title:(NSString *)title
                                   okActionName:(NSString *)okActionName
                                        handler:(void (^)(void))okActionHandler
                               cancelActionName:(NSString *)cancelActionName
                                        handler:(void (^)(void))cancelActionHandler {
    if (okActionName.length == 0 && cancelActionName.length == 0) {
        
        return;
    }
    
    UIAlertController *informAlertController = [UIAlertController alertControllerWithTitle:title
                                                                                   message:message
                                                                            preferredStyle:UIAlertControllerStyleAlert];
    if (okActionName.length > 0) {
        [informAlertController addAction:[UIAlertAction actionWithTitle:okActionName style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action) {
                                                                    if (okActionHandler) {
                                                                        okActionHandler();
                                                                    }
                                                                }]];
    }
    
    if (cancelActionName.length > 0) {
        [informAlertController addAction:[UIAlertAction actionWithTitle:cancelActionName style:UIAlertActionStyleCancel
                                                                handler:^(UIAlertAction *action) {
                                                                    if (cancelActionHandler) {
                                                                        cancelActionHandler();
                                                                    }
                                                                }]];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.view.window.rootViewController presentViewController:informAlertController animated:YES completion:nil];
    });
}

@end
