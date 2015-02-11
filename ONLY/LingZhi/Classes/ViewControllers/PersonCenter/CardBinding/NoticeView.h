//
//  NoticeView.h
//  LingZhi
//
//  Created by feng on 14-8-12.
//
//

#import <UIKit/UIKit.h>

@interface NoticeView : UIView

- (id)initWithFrame:(CGRect)frame andView:(UIView *)backview;

- (void)makeViewShow:(NSString *)message;

@end
