//
//  ProductCellModel.h
//  LingZhi
//
//  Created by boguoc on 14-3-5.
//
//

#import "OnlyBaseModel.h"

@interface ProductCellModel : OnlyBaseModel

@property (nonatomic ,strong) NSString *productId;
@property (nonatomic ,strong) NSString *price;
@property (nonatomic ,strong) NSString *imageUrl;

@end
