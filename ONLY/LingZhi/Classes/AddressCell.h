//
//  AddressCell.h
//  LingZhi
//
//  Created by boguoc on 14-3-11.
//
//

#import "ITTXibView.h"
#import "AddressModel.h"

@protocol AddressCellDelegate <NSObject>

- (void)didOnEditButtonAtIndex:(NSInteger)index;

@end

@interface AddressCell : ITTXibCell

@property(nonatomic ,assign) id<AddressCellDelegate>delegate;
@property(nonatomic ,assign) NSInteger index;
@property(nonatomic ,assign) BOOL isEdit;

- (void)layoutAddressCellWithModel:(AddressModel *)model;

@end
