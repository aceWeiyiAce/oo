//
//  CollectProductModel.m
//  LingZhi
//
//  Created by pk on 14-3-12.
//
//

#import "CollectProductModel.h"

@implementation CollectProductModel

-(NSDictionary *)attributeMapDictionary
{
    return @{@"collectId"       : @"collectId",
             @"houseCount"      : @"houseCount",
             @"isInShopCar"     : @"isInShopCar",
             @"hasDelete"       : @"hasDelete",
             @"productInfo"     : @"productInfo",
             @"cModel"          : @"availableColors",
             @"zModel"          : @"availableSizes"
             };
}

+(id)createTestModelWithModelId:(NSString *)modelId
{
    CollectProductModel *collect = [[CollectProductModel alloc]init];
    
    collect.collectId = [NSString stringWithFormat:@"123445%@",modelId];
    collect.buyCount = @"1";
    collect.houseCount = @"5";
    collect.isInShopCar = @"0";
    collect.hasDelete = @"0";
    collect.productInfo = [ProductInfoModel createTestModelWithModelId:modelId];
    
    return collect;
}


@end
