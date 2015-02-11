//
//  CustomAlertView.h
//  LingZhi
//
//  Created by pk on 3/19/14.
//
//

#import "ITTXibView.h"

typedef void(^ButtonBlock)();

@interface CustomAlertView : ITTXibView


- (void)showCustomViewWithSuperView:(UIView *)superView title:(NSString *)atitle content:(NSString *)acontent oneButtonText:(NSString *)text1 twoButtonText:(NSString *)text2 oneButtonActionBlock:(ButtonBlock) leftBlock twoButtonBlock:(ButtonBlock) rightBlock;

@end
