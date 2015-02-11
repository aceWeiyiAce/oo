//
//  EditAddressCell.h
//  LingZhi
//
//  Created by boguoc on 14-3-11.
//
//

#import "ITTXibView.h"
#import "EditAddressModel.h"

@protocol EditAddressCellDelegate <NSObject>

- (void)cellTextFieldBeingEditingAtIndexPath:(NSIndexPath *)index;
- (void)cellTextFieldDidEndEditingAtIndexPath:(NSIndexPath *)index;
- (void)cellTextFieldShouldReturnAtIndexPath:(NSIndexPath *)index;

@end

@interface EditAddressCell : ITTXibCell

@property (nonatomic ,assign) id<EditAddressCellDelegate>delegate;

- (void)layoutEditAddressCellWithModel:(EditAddressModel *)model;

@end
