//
//  ProductCell.m
//  LingZhi
//
//  Created by boguoc on 14-3-5.
//
//

#import "ProductCell.h"

@interface ProductCell ()
{
    __weak IBOutlet ITTImageView     *_oneImageView;
    __weak IBOutlet ITTImageView     *_twoImageView;
    __weak IBOutlet UILabel         *_oneLabel;
    __weak IBOutlet UILabel         *_twoLabel;
    __weak IBOutlet UIView          *_twoView;
}

@end

@implementation ProductCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)layoutProductCellWithModel:(ProductCellModel *)model andModel:(ProductCellModel *)aModel
{
    [_oneImageView loadImage:model.imageUrl];
    [_twoImageView loadImage:aModel.imageUrl];
    _oneLabel.text = [NSString stringWithFormat:@"￥ %@",model.price];
    _twoLabel.text = [NSString stringWithFormat:@"￥ %@",aModel.price];
    if (aModel == nil) {
        _twoView.hidden = YES;
    } else {
        _twoView.hidden = NO;
    }
}
#pragma mark Button methods

- (IBAction)onLeftButton:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didOnLeftButtonAtIndex:)]) {
        [self.delegate didOnLeftButtonAtIndex:self.index *2];
    }
}

- (IBAction)onRightButton:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didOnRightButtonAtIndex:)]) {
        [self.delegate didOnRightButtonAtIndex:self.index *2 +1];
    }
}

@end
