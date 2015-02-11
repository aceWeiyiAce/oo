//
//  OrderContainsProducts.h
//  LingZhi
//
//  Created by pk on 3/26/14.
//
//

#import "OnlyBaseModel.h"

@interface OrderContainsProducts : OnlyBaseModel


//"productInfo":"这件衣服很好看，very Good"，"buyCount"："2","sellPrice":"499"

@property (nonatomic,strong)NSString * productInfo;
@property (nonatomic,strong)NSString * buyCount;
@property (nonatomic,strong)NSString * sellPrice;


+(NSArray *)allContainsProducts;
@end
