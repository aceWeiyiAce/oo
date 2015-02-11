//
//  OrderDetailCell.h
//  LingZhi
//
//  Created by pk on 3/11/14.
//
//

#import "ITTXibView.h"
@class ProductInfoModel;

typedef void(^ShowProductBlock)(NSString * pNumber);

@interface OrderDetailCell : ITTXibCell

@property(nonatomic,copy)ShowProductBlock tapSendBlock;


/**
 *  根据商品信息和购买的数量 显示订单详情
 *
 *  @param product
 *  @param count
 */
-(void)showOrderDetailWithProduct:(ProductInfoModel *)product;

@end
