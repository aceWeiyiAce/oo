//
//  ProductDetailInfoModel.h
//  LingZhi
//
//  Created by pk on 4/3/14.
//
//

#import "OnlyBaseModel.h"
#import "ProductInfoModel.h"

@interface ProductDetailInfoModel : OnlyBaseModel

@property (nonatomic,strong)ProductInfoModel * productInfo;
@property (nonatomic,strong)NSArray * imageUrlArr;
@property (nonatomic,strong)NSArray * colorArr;
@property (nonatomic,strong)NSArray * sizeArr;
@property (nonatomic,strong)NSArray * macthProducts;
@property (nonatomic,strong)NSString * collectId;
@property (nonatomic,assign)BOOL isCollected;

@end
