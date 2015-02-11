//
//  UIAlertView+ITTAdditions.h
//  iTotemFrame
//
//  Created by jack 廉洁 on 3/15/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DismissBlock)(int buttonIndex);
typedef void(^CancelBlock)();

@interface UIAlertView (ITTAdditions)<UIAlertViewDelegate>

+ (void) popupAlertByDelegate:(id)delegate title:(NSString *)title message:(NSString *)msg;
+ (void) popupAlertByDelegate:(id)delegate title:(NSString *)title message:(NSString *)msg cancel:(NSString *)cancel others:(NSString *)others, ...;


+(UIAlertView *)promptTipViewWithTitle:(NSString *)title
                               message:(NSString *)message
                        cancelBtnTitle:(NSString *)cancelBtnTitle
                     otherButtonTitles:(NSArray *)otherbuttons
                             onDismiss:(DismissBlock)dismissed
                              onCancel:(CancelBlock)canceled;



@end
