//
//  MatchProduct.m
//  LingZhi
//
//  Created by pk on 3/6/14.
//
//

#import "MatchProduct.h"

@interface MatchProduct ()
{
    __weak IBOutlet ITTImageView *_imageView;
    
    __weak IBOutlet UILabel *_priceLbl;
    
    NSString * _productId;
}
@end


@implementation MatchProduct


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"MatchProduct" owner:self options:nil];
        self = [nib objectAtIndex:0];
    }
    return self;
}

/**
 *  自定义的初始化方法
 *
 *  @param frame
 *  @param imageUrl
 *  @param price
 *  @param productId
 *
 *  @return MacthProduct
 */
- (id)initWithFrame:(CGRect)frame AndImageView:(NSString *)imageUrl andPrice:(NSString *)price andProductId:(NSString *)productId
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"MatchProduct" owner:self options:nil];
        self = [nib objectAtIndex:0];
    }
    [_imageView loadImage:imageUrl];
    _priceLbl.text = [NSString stringWithFormat:@"￥%@",price];
    
    _productId = productId;
    return self;
}

/**
 *  根据imageUrl price productId 显示商品的搭配信息
 *
 *  @param imageUrl
 *  @param price
 *  @param productId 
 */
- (void)showImageWithUrl:(NSString *)imageUrl andPrice:(NSString *)price andProductId:(NSString *)productId
{
    [_imageView loadImage:imageUrl];
    
//    [_imageView setImage:[UIImage imageNamed:@"pic08.png"]];
    _priceLbl.text = [NSString stringWithFormat:@"￥%@",price];
    
    _productId = productId;
}

- (IBAction)gotoProductDetailView:(id)sender {
    
    _tapClick(_productId);

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
