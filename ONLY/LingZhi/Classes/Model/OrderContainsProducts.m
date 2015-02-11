//
//  OrderContainsProducts.m
//  LingZhi
//
//  Created by pk on 3/26/14.
//
//

#import "OrderContainsProducts.h"

@implementation OrderContainsProducts


-(NSDictionary *)attributeMapDictionary
{
    return @{@"productInfo"          : @"productInfo",
             @"buyCount"             : @"buyCount",
             @"sellPrice"            : @"sellPrice"
             };
}



+(NSArray *)allContainsProducts
{
    NSMutableArray *allOrderArr = [NSMutableArray array];
    for (int i=0; i<3; i++) {
        OrderContainsProducts * model = [[OrderContainsProducts alloc] init];
        model.productInfo = @"just fuck off japanese!just fuck off japanese!just fuck off japanese!just fuck off japanese!";
        model.buyCount = @"3";
        model.sellPrice = @"893.00";
        [allOrderArr addObject:model];
    }
    
    return allOrderArr;
}

@end
