//
//  AddressCell.m
//  LingZhi
//
//  Created by boguoc on 14-3-11.
//
//

#import "AddressCell.h"

@interface AddressCell ()
{
    __weak IBOutlet UIView  *_selectView;
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_addressLabel;
    __weak IBOutlet UILabel *_phoneLabel;
    __weak IBOutlet UIImageView *_defaultImageView;
    __weak IBOutlet UIButton *_editButton;
}
@end

@implementation AddressCell

-(void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)layoutAddressCellWithModel:(AddressModel *)model
{
    _nameLabel.text = model.name;
    _addressLabel.text = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",model.province,model.city,model.area,model.address,model.postalNum];
    _phoneLabel.text = [NSString stringWithFormat:@"电话: +86 %@",model.phone];
    if ([model.isSelect boolValue]) {
        [_selectView setBorderColor:RGBCOLOR(253, 163, 185) width:1 cornerRadius:0];
    } else {
        _selectView.layer.borderWidth = 0;
    }
    _defaultImageView.hidden = [model.isDefault isEqualToString:@"1"] ? NO : YES;
    _editButton.hidden = _isEdit?NO:YES;
}

- (IBAction)onEditButton:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didOnEditButtonAtIndex:)]) {
        [self.delegate didOnEditButtonAtIndex:_index];
    }
}

@end
