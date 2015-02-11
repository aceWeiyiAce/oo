//
//  MatchProduct.h
//  LingZhi
//
//  Created by pk on 3/6/14.
//
//

#import <UIKit/UIKit.h>


typedef void(^GO_ProductDetail_TapClick)(NSString * pid);

@interface MatchProduct : UIView


/**
 *  自定义的初始化方法
 *
 *  @param frame
 *  @param imageUrl
 *  @param price
 *  @param productId
 *
 *  @return MacthProduct
 */
- (id)initWithFrame:(CGRect)frame AndImageView:(NSString *)imageUrl andPrice:(NSString *)price andProductId:(NSString *)productId;


/**
 *  根据imageUrl price productId 显示商品的搭配信息
 *
 *  @param imageUrl
 *  @param price
 *  @param productId
 */
- (void)showImageWithUrl:(NSString *)imageUrl andPrice:(NSString *)price andProductId:(NSString *)productId;


@property (nonatomic,copy)GO_ProductDetail_TapClick tapClick;

@end
