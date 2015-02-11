//
//  ProductCell.h
//  LingZhi
//
//  Created by boguoc on 14-3-5.
//
//

#import "ITTXibView.h"
#import "ProductCellModel.h"

@protocol ProductCellDelegate <NSObject>

- (void)didOnLeftButtonAtIndex:(NSInteger)index;
- (void)didOnRightButtonAtIndex:(NSInteger)index;


@end

@interface ProductCell : ITTXibCell

@property (nonatomic ,assign) NSInteger index;
@property (nonatomic ,assign) id<ProductCellDelegate>delegate;

- (void)layoutProductCellWithModel:(ProductCellModel *)model andModel:(ProductCellModel *)aModel;

@end
