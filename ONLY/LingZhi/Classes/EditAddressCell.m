//
//  EditAddressCell.m
//  LingZhi
//
//  Created by boguoc on 14-3-11.
//
//

#import "EditAddressCell.h"

@interface EditAddressCell ()<UITextFieldDelegate>
{
    __weak IBOutlet UITextField *_textField;
    __weak IBOutlet UIView      *_pinkView;
    __weak IBOutlet UIImageView *_pullDownImage;
    __weak IBOutlet UILabel     *_tipLabel;
    __weak IBOutlet UIImageView *_pinkImageView;
    
    EditAddressModel            *_editModel;
    NSString *_row;
}

@end

@implementation EditAddressCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldRegisterFirst:) name:@"addressTextField" object:nil];
    
//    [_pinkImageView setBorderColor:RGBCOLOR(253, 163, 185) width:1 cornerRadius:0];
    [self resignFirstResponder];
}

- (void)textFieldRegisterFirst:(NSNotification *)noti
{
    [_textField resignFirstResponder];
    
    NSString *str = [noti object];
    
    if ([str isEqualToString:[NSString stringWithFormat:@"%d",_editModel.indexPath.row]]) {
        [_textField becomeFirstResponder];
    }
}

- (void)layoutEditAddressCellWithModel:(EditAddressModel *)model
{
    _editModel = model;

    _textField.placeholder = model.holder;
    _textField.text = model.content;

    _pinkView.hidden = [model.isError boolValue]?NO:YES;
    
//    if (model.indexPath.row == 2 || model.indexPath.row == 3) {
//        _pullDownImage.hidden = NO;
//        _textField.enabled = NO;
//    }
//    if (model.indexPath.row == 4) {
        if ([model.isPicker isEqualToString:@"1"]) {
            _pullDownImage.hidden = NO;
            _textField.enabled = NO;
        } else {
            _pullDownImage.hidden = YES;
            _textField.enabled = YES;
        }
//    }
    if (model.indexPath.row < 5) {
        if (model.indexPath.row == 1) {
            if (_textField.text.length > 35) {
                _tipLabel.text = @"最多能输入35个字符";
            } else {
                _tipLabel.text = @"此栏为必填项";
            }
        } else {
            if (model.indexPath.row == 0) {
                if ([_textField.text length]<1) {
                     _tipLabel.text = @"此栏为必填项";
                }
                if ([_textField.text lengthOfBytesUsingEncoding:NSUTF8StringEncoding]>30) {
                    _tipLabel.text = @"姓名可容纳字符(中文10个、英文30个)";
                }
            }else{
                _tipLabel.text = @"此栏为必填项";
            }
            
        }
    } else if (5 == model.indexPath.row) {
        _tipLabel.text = @"邮政编码无效,请重新填写";
    } else {
        _tipLabel.text = @"手机号码无效,请重新填写";
    }
    if (model.indexPath.row == 5 || model.indexPath.row == 6) {
        _textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _editModel.content = _textField.text;

    if (self.delegate && [self.delegate respondsToSelector:@selector(cellTextFieldDidEndEditingAtIndexPath:)]) {
        [self.delegate cellTextFieldDidEndEditingAtIndexPath:_editModel.indexPath];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellTextFieldBeingEditingAtIndexPath:)]) {
        [self.delegate cellTextFieldBeingEditingAtIndexPath:_editModel.indexPath];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _editModel.content = _textField.text;

    if (self.delegate && [self.delegate respondsToSelector:@selector(cellTextFieldShouldReturnAtIndexPath:)]) {
        [self.delegate cellTextFieldShouldReturnAtIndexPath:_editModel.indexPath];
    }
    [_textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string{
    if ([[[UITextInputMode currentInputMode]primaryLanguage] isEqualToString:@"emoji"] || [string isEqualToString:@" "]) {
        return NO;
    }
    return YES;
}
@end
