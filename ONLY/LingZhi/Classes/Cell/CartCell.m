//
//  CartCell.m
//  LingZhi
//
//  Created by boguoc on 14-3-3.
//
//

#import "CartCell.h"
#import "CartModel.h"

@interface CartCell ()<ITTImageViewDelegate>
{
    __weak IBOutlet UISwipeGestureRecognizer    *_cellSwipe;
    __weak IBOutlet UIView                      *_infoView;
    __weak IBOutlet ITTImageView                *_image;
    __weak IBOutlet UIButton                    *_isSelectButton;
    __weak IBOutlet UILabel                     *_infoLabel;
    __weak IBOutlet UILabel                     *_numLabel;
    __weak IBOutlet UILabel                     *_colorLabel;
    __weak IBOutlet UILabel                     *_sizeLabel;
    __weak IBOutlet UILabel                     *_priceLabel;
    __weak IBOutlet UILabel                     *_amount;
    __weak IBOutlet UILabel                     *_tipLabel;
    
    CartModel                                   *_cartModel;
}
@property (nonatomic,assign)BOOL isSelect;
@property (nonatomic,assign)BOOL hasDelete;
@end

@implementation CartCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    _cellSwipe.direction = UISwipeGestureRecognizerDirectionRight |
                           UISwipeGestureRecognizerDirectionLeft;
    _image.enableTapEvent = YES;
    _image.delegate = self;
}

- (void)layoutCartCellWithModel:(CartModel *)model
{
    _cartModel = model;
    
    [_image loadImage:model.productInfo.imageUrl];
    self.hasDelete = [model.hasDelete boolValue];
    _isSelectButton.selected = [model.isSelect boolValue];
    _infoLabel.text = model.productInfo.info;
    _numLabel.text = model.productInfo.num;
    _colorLabel.text = model.productInfo.color;
    _sizeLabel.text = model.productInfo.size;
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",model.productInfo.price];
    _amount.text = model.buyCount;
    if ([model.productInfo.state isEqualToString:@"-1"]) {
        _tipLabel.text = [NSString stringWithFormat:@"抱歉,此件商品已下架"];

    } else {
        _tipLabel.text = [NSString stringWithFormat:@"抱歉,此件商品库存不足 剩余%@件",model.houseCount];

    }
    [self reloadCellDeleteButton];
}

-(void)setHasDelete:(BOOL)hasDelete
{
    _hasDelete = hasDelete;
    _infoView.right = _hasDelete?260:320;
}

#pragma mark - Button Methods

- (IBAction)onIsSelectButton:(id)sender
{
    _cartModel.isSelect = [_cartModel.isSelect boolValue]?@"0":@"1";
    _isSelectButton.selected = [_cartModel.isSelect boolValue];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectCellWithIndex:)]) {
        [self.delegate didSelectCellWithIndex:_cartCellIndexPath];
    }
}

- (IBAction)onCutButton:(id)sender
{
    if ([_cartModel.buyCount integerValue]<2) {
        return;
    }
    int temp = [_cartModel.buyCount integerValue];
    temp--;
    _cartModel.buyCount = [NSString stringWithFormat:@"%d",temp];
    _amount.text = [NSString stringWithFormat:@"%d",temp];
    if ([_cartModel.hasTip isEqualToString:@"1"] && [_amount.text integerValue] <= [_cartModel.houseCount integerValue]) {
        _cartModel.hasTip = @"0";
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadCartCellWithIndex:)]) {
        [self.delegate reloadCartCellWithIndex:_cartCellIndexPath];
    }
}

- (IBAction)onAddButton:(id)sender
{
    int temp = [_cartModel.buyCount integerValue];
    temp++;
    _cartModel.buyCount = [NSString stringWithFormat:@"%d",temp];
    _amount.text = [NSString stringWithFormat:@"%d",temp];
    if ([_amount.text integerValue] > [_cartModel.houseCount integerValue]) {
        _cartModel.hasTip = @"1";
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadCartCellWithIndex:)]) {
        [self.delegate reloadCartCellWithIndex:_cartCellIndexPath];
    }
}

- (IBAction)onDeleteButton:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteCartCellWithIndex:)]) {
        [self.delegate deleteCartCellWithIndex:self.cartCellIndexPath];
    }
}

#pragma mark - UISwipeGestureRecognizer

- (IBAction)swipeCell:(UISwipeGestureRecognizer *)sender
{
    _hasDelete = !_hasDelete;
    [self showDeleteButton];
}

- (void)showDeleteButton
{
    _cartModel.hasDelete = _hasDelete?@"1":@"0";
    [UIView animateWithDuration:.24f
                     animations:^{
                         _infoView.right = _hasDelete?250:320;
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)reloadCellDeleteButton
{
    _cartModel.hasDelete = _hasDelete?@"1":@"0";
    _infoView.right = _hasDelete?250:320;
}

#pragma mark - ITTImageViewDelegate

-(void)imageViewDidClicked:(ITTImageView *)imageView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickImageWithIndex:)]) {
        [self.delegate didClickImageWithIndex:self.cartCellIndexPath];
    }
}
@end
