//
//  shareRemindView.h
//  LingZhi
//
//  Created by pk on 3/3/14.
//
//

#import <UIKit/UIKit.h>

typedef void(^backToHome)();

@interface ShareRemindView : UIView
/**
 *  根据图片和提示信息显示
 *
 *  @param image
 *  @param msg
 */
-(void)showRemindInfoWithImage:(UIImage *)image andMsg:(NSString *)msg;

@property (nonatomic,copy)backToHome btn_block;

@end
