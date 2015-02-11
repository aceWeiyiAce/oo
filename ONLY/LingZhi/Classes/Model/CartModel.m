//
//  CartModel.m
//  LingZhi
//
//  Created by boguoc on 14-3-3.
//
//

#import "CartModel.h"

@implementation CartModel

-(NSDictionary *)attributeMapDictionary
{
    return @{@"showId"          : @"productId",
             @"buyCount"        : @"buyNum",
             @"houseCount"      : @"storageNum",
             @"isSelect"        : @"isSelect",
             @"hasDelete"       : @"hasDelete",
             @"hasTip"          : @"hasTip",
             @"productInfo"     : @"pname",};
}

+(id)createTestModelWithModelId:(NSString *)modelId
{
    CartModel *cart = [[CartModel alloc]init];
    
    cart.showId = [NSString stringWithFormat:@"123445%@",modelId];
    cart.buyCount = @"1";
    cart.houseCount = @"5";
    cart.isSelect = @"0";
    cart.hasDelete = @"0";
    cart.hasTip = @"0";
    cart.productInfo = [ProductInfoModel createTestModelWithModelId:modelId];
    
    return cart;
}

@end
