//
//  PhoneView.h
//  LingZhi
//
//  Created by boguoc on 14-3-5.
//
//

#import "ITTXibView.h"

@interface PhoneView : ITTXibView

@property (nonatomic,strong) NSString *phoneNum;

- (void)showPhoneViewWithSuperView:(UIView *)superView title:(NSString *)atitle content:(NSString *)acontent oneButtonText:(NSString *)text1 twoButtonText:(NSString *)text2;

/**
 *  附近门店详细专用
 *
 *  @param superView <#superView description#>
 *  @param atitle    <#atitle description#>
 *  @param acontent  <#acontent description#>
 *  @param text1     <#text1 description#>
 *  @param text2     <#text2 description#>
 */
- (void)showPhoneViewForMapViewWithSuperView:(UIView *)superView title:(NSString *)atitle content:(NSString *)acontent oneButtonText:(NSString *)text1 twoButtonText:(NSString *)text2;

@end
