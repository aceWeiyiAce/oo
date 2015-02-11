//
//  OrderModel.m
//  LingZhi
//
//  Created by pk on 3/11/14.
//
//

#import "OrderModel.h"
//#import "NSDate+Utilities.h"

@implementation OrderModel


-(NSDictionary *)attributeMapDictionary
{
    return @{@"orderId"          : @"orderId",
             @"orderNo"          : @"orderNumber",
             @"state"            : @"orderStateId",
             @"date"             : @"submitDate",
             @"postId"           : @"postId",
             @"containsCount"    : @"productCount",
             @"totalPrice"       : @"orderPrice",
             @"remindMessage"    : @"remindMessage",
             @"stateValue"       : @"stateValue"
             };
}


+(NSArray *)allOrders
{
    NSMutableArray *allOrderArr = [NSMutableArray array];
    for (int i=0; i<11; i++) {
        OrderModel * model = [[OrderModel alloc] init];
        model.orderId = @"123423";
        model.orderNo = @"1234543212";
        model.state = [NSString stringWithFormat:@"%d",i];
        model.date = @"2014.3.12 08:09:38";
        model.postId = @"12345676464";
        model.containsCount = @"3";
        model.totalPrice = @"4567.00";
        
        [allOrderArr addObject:model];
        
    }
    
    OrderModel * updateModel = allOrderArr[4];
    updateModel.state = [NSString stringWithFormat:@"%d",oHasPosted];
    
    OrderModel * twoModel = allOrderArr[10];
    twoModel.state = [NSString stringWithFormat:@"%d",oDealCanceled];
    twoModel.remindMessage = @"该订单将于2014.3.15日自动删除";
    
    return allOrderArr;
}

@end
