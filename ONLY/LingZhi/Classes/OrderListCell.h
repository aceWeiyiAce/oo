//
//  OrderListCell.h
//  LingZhi
//
//  Created by pk on 3/11/14.
//
//

#import "ITTXibView.h"
@class OrderModel;

typedef void(^BUTTON_BLOCK_ACTION)(void);

@interface OrderListCell : ITTXibCell



@property (strong, nonatomic) IBOutlet UILabel *orderNo;
@property (strong, nonatomic) IBOutlet UILabel *state;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *containsCount;
@property (strong, nonatomic) IBOutlet UILabel *totalPrice;


@property (nonatomic,copy) BUTTON_BLOCK_ACTION btnClickBlock;


/**
 *  根据order信息，给cell中的信息赋值
 *
 *  @param order
 */
-(void)showOrderInfoWithOrder:(OrderModel *)order;

@end
