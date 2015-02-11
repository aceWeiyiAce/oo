//
//  ProductInfoModel.m
//  LingZhi
//
//  Created by boguoc on 14-3-3.
//
//

#import "ProductInfoModel.h"

@implementation ProductInfoModel

-(NSDictionary *)attributeMapDictionary
{
    return @{@"productId"        : @"productId",
             @"info"             : @"pname",
             @"num"              : @"pnumber",
             @"size"             : @"sizeName",
             @"price"            : @"price",
             @"imageUrl"         : @"purl",
             @"sellCount"        : @"sellCount",
             @"material"         : @"pmaterial",
             @"storeCount"       : @"storageNumber",
             @"stateInOrder"     : @"stateInOrder",
             @"color"            : @"colorName",
             @"buyCount"         : @"buyNumber",
             @"style"            : @"pshape",
             @"shareUrl"         : @"shareUrl",
             @"enough"           : @"enough",
             @"state"            : @"state",
             @"productInfo"      : @"productInfo"
             };
}

+(id)createTestModelWithModelId:(NSString *)modelId
{
    ProductInfoModel *productInfo = [[ProductInfoModel alloc]init];
    
    productInfo.productId = modelId;
    productInfo.info = [NSString stringWithFormat:@"s;%@",modelId];
    productInfo.num = modelId;
    productInfo.color = ([modelId integerValue]%2)?@"红色":@"黑色";
    productInfo.size = modelId;
    productInfo.price = [NSString stringWithFormat:@"%.2f",[modelId floatValue] *11.23];
    productInfo.imageUrl = testImage;
    
    productInfo.stateInOrder = modelId;
    
    return productInfo;
}

@end
