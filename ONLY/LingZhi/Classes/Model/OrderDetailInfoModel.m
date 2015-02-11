//
//  OrderDetailInfoModel.m
//  LingZhi
//
//  Created by pk on 4/1/14.
//
//

#import "OrderDetailInfoModel.h"

@implementation OrderDetailInfoModel

-(NSDictionary *)attributeMapDictionary
{
    return @{
             @"address"          : @"adress",
             @"province"         : @"province",
             @"provinceId"       : @"provinceId",
             @"receiver"         : @"receiver",
             @"city"             : @"city",
             @"cityId"             : @"cityId",
             @"borough"          : @"borough",
             @"boroughId"          : @"boroughId",
             @"contact"          : @"contact",
             @"postCode"         : @"postCode",
             
             @"currentState"     : @"currentState",
             @"discount"         : @"discount",
             @"orderId"          : @"orderId",
             @"postId"           : @"postId",
             @"payCompany"       : @"payCompany",
             @"postCompany"      : @"postCompany",
             @"postId"           : @"postId",
             @"postPrice"        : @"postPrice",
             @"submitDate"       : @"submitDate",
             @"sysDate"          : @"sysDate",
             @"orderNumber"      : @"orderNumber",
             @"totalPrice"       : @"totalPrice",
             @"totalCount"       : @"totalCount",
             @"products"         : @"products",
             
             };
}


@end
