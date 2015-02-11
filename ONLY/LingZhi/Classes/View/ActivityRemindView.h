//
//  ActivityRemindView.h
//  LingZhi
//
//  Created by pk on 14-4-14.
//
//

#import "ITTXibView.h"

@interface ActivityRemindView : ITTXibView

/**
 *  在给定的视图容器中，显示指定的信息
 *
 *  @param view 视图容器，父视图
 *  @param msg  信息
 */
-(void)showActivityViewInView:(UIView *)view withMsg:(NSString *)msg;

/**
 *  隐藏
 */
-(void)hideActivity;

/**
 *  在给定的视图容器中，显示指定的信息，并在指定的时间内自动隐藏
 *
 *  @param view    视图容器，父视图
 *  @param msg     信息
 *  @param seconds 显示的时间
 */
-(void)showActivityViewInView:(UIView *)view withMsg:(NSString *)msg inSeconds:(int)seconds;

@end
