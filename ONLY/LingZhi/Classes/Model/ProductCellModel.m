//
//  ProductCellModel.m
//  LingZhi
//
//  Created by boguoc on 14-3-5.
//
//

#import "ProductCellModel.h"

@implementation ProductCellModel

-(NSDictionary *)attributeMapDictionary
{
    return @{@"productId"   : @"productId",
             @"price"       : @"priceDisplay",
             @"imageUrl"    : @"picture",};
}

+(id)createTestModelWithModelId:(NSString *)modelId
{
    ProductCellModel *product = [[ProductCellModel alloc]init];
    
    product.productId = modelId;
    product.price = [NSString stringWithFormat:@"%.2f",random()%1000 * 0.12321];
    product.imageUrl = testImage;
    
    return product;
}

@end
