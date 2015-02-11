//
//  OrderModel.h
//  LingZhi
//
//  Created by pk on 3/11/14.
//
//

#import <Foundation/Foundation.h>
#import "OnlyBaseModel.h"

@interface OrderModel : OnlyBaseModel

@property (nonatomic ,strong) NSString *orderId;
@property (nonatomic ,strong) NSString *orderNo;
@property (nonatomic ,strong) NSString *state;
@property (nonatomic ,strong) NSString *date;
@property (nonatomic ,strong) NSString *postId;
@property (nonatomic ,strong) NSString *containsCount;
@property (nonatomic ,strong) NSString *totalPrice;
@property (nonatomic ,strong) NSString *remindMessage;
@property (nonatomic ,strong) NSString *stateValue;


+(NSArray *)allOrders;
@end
