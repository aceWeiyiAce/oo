//
//  CollectProductModel.h
//  LingZhi
//
//  Created by pk on 14-3-12.
//
//

#import "OnlyBaseModel.h"
#import "ProductInfoModel.h"

@interface CollectProductModel : OnlyBaseModel

@property (nonatomic ,strong) NSString *collectId;
@property (nonatomic ,strong) NSString *buyCount;
@property (nonatomic ,strong) NSString *houseCount;
@property (nonatomic ,strong) NSString *isInShopCar;
@property (nonatomic ,strong) NSString *hasDelete;
@property (nonatomic ,strong) ProductInfoModel *productInfo;
@property (nonatomic ,strong) NSArray *cModel;
@property (nonatomic ,strong) NSArray *zModel;


@end
