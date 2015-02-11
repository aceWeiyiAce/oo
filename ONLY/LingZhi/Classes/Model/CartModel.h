//
//  CartModel.h
//  LingZhi
//
//  Created by boguoc on 14-3-3.
//
//

#import "OnlyBaseModel.h"
#import "ProductInfoModel.h"

@interface CartModel : OnlyBaseModel

@property (nonatomic ,strong) NSString *showId;
@property (nonatomic ,strong) NSString *buyCount;
@property (nonatomic ,strong) NSString *houseCount;
@property (nonatomic ,strong) NSString *isSelect;
@property (nonatomic ,strong) NSString *hasTip;
@property (nonatomic ,strong) NSString *hasDelete;
@property (nonatomic ,strong) ProductInfoModel *productInfo;

@end
