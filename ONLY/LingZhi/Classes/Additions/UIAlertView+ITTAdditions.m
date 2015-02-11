//
//  UIAlertView+ITTAdditions.m
//  iTotemFrame
//
//  Created by jack 廉洁 on 3/15/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "UIAlertView+ITTAdditions.h"

static DismissBlock _dismissBlock;
static CancelBlock _cancelBlock;

@implementation UIAlertView (ITTAdditions)

+ (void) popupAlertByDelegate:(id)delegate title:(NSString *)title message:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg
                                                   delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];	
}

+ (void) popupAlertByDelegate:(id)delegate title:(NSString *)title message:(NSString *)msg cancel:(NSString *)cancel others:(NSString *)others, ... {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg
                                                    delegate:delegate cancelButtonTitle:cancel otherButtonTitles:others, nil];
    [alert show];	
}


+(UIAlertView *)promptTipViewWithTitle:(NSString *)title
                               message:(NSString *)message
                        cancelBtnTitle:(NSString *)cancelBtnTitle
                     otherButtonTitles:(NSArray *)otherbuttons
                             onDismiss:(DismissBlock)dismissed
                              onCancel:(CancelBlock)canceled
{
    _dismissBlock = [dismissed copy];
    _cancelBlock = [canceled copy];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelBtnTitle otherButtonTitles:nil];
    for (NSString * btnTitle in otherbuttons) {
        [alert addButtonWithTitle:btnTitle];
    }
    [alert show];
    return alert;
}


+ (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]) {
        _cancelBlock();
    }else{
        _dismissBlock( buttonIndex - 1);
    }
}
@end
