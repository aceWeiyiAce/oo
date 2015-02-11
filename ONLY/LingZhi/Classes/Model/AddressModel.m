//
//  AddressModel.m
//  LingZhi
//
//  Created by boguoc on 14-3-11.
//
//

#import "AddressModel.h"

@implementation AddressModel

-(NSDictionary *)attributeMapDictionary
{
    return @{@"name"        : @"receiver",
             @"address"     : @"address",
             @"province"    : @"province",
             @"city"        : @"city",
             @"area"        : @"area",
             @"postalNum"   : @"postCode",
             @"phone"       : @"mobile",
             @"isDefault"   : @"state",
             @"isSelect"    : @"isSelect",
             @"type"        : @"state",
             @"fixIndex"    : @"fixIndex",
             @"provinceId"  : @"provinceId",
             @"cityId"      : @"cityId",
             @"areaId"      : @"areaId",
             @"operation"   : @"operation",
             @"addressId"   : @"addressId",
             @"isAdd"       : @"isAdd"};
}

+(id)createTestModelWithModelId:(NSString *)modelId
{
    AddressModel *address = [[AddressModel alloc]init];
    
    address.name = [NSString stringWithFormat:@"WALL.E%@",modelId];
    address.address = @"死定了开发结束了副科级死定了开发接收到了罚款";
    address.province = @"北京";
    address.city = @"北京";
    address.area = @"海淀区";
    address.postalNum = [NSString stringWithFormat:@"%d",[modelId integerValue]*111111];
    address.phone = [NSString stringWithFormat:@"%d",([modelId integerValue] * 91234324)];
    
    return address;
}

@end
