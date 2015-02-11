//
//  ProductInfoModel.h
//  LingZhi
//
//  Created by boguoc on 14-3-3.
//
//

#import "OnlyBaseModel.h"
//#import "ColorModel.h"
//#import "SizeModel.h"

@interface ProductInfoModel : OnlyBaseModel

@property (nonatomic ,strong) NSString *productId;
@property (nonatomic ,strong) NSString *info;
@property (nonatomic ,strong) NSString *num;
@property (nonatomic ,strong) NSString *color;
@property (nonatomic ,strong) NSString *size;
@property (nonatomic ,strong) NSString *price;
@property (nonatomic ,strong) NSString *imageUrl;
@property (nonatomic ,strong) NSString *sellCount;
@property (nonatomic ,strong) NSString *material;
@property (nonatomic ,strong) NSString *storeCount;
@property (nonatomic ,strong) NSString *buyCount;
@property (nonatomic ,strong) NSString *style;
@property (nonatomic ,strong) NSString *shareUrl;
@property (nonatomic ,strong) NSString *enough;
@property (nonatomic ,strong) NSString *state;
//提供商品在订单中得状态（正常/0 or 退货/1）
@property (nonatomic ,strong) NSString *stateInOrder;
@property (nonatomic ,strong) NSString *productInfo;
@end
