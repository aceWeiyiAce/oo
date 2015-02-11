//
//  CartCell.h
//  LingZhi
//
//  Created by boguoc on 14-3-3.
//
//

#import "ITTXibView.h"
#import "CartModel.h"

@protocol CartCellDelegate <NSObject>

- (void)reloadCartCellWithIndex:(NSIndexPath *)indexPath;
- (void)deleteCartCellWithIndex:(NSIndexPath *)indexPath;
- (void)didSelectCellWithIndex:(NSIndexPath *)indexPath;
- (void)didClickImageWithIndex:(NSIndexPath *)indexPath;

@end

@interface CartCell : ITTXibCell

@property (nonatomic ,strong) NSIndexPath *cartCellIndexPath;
@property (nonatomic ,assign) id <CartCellDelegate> delegate;

- (void)layoutCartCellWithModel:(CartModel *)model;

@end
