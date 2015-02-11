//
//  OrderDetailCell.m
//  LingZhi
//
//  Created by pk on 3/11/14.
//
//

#import "OrderDetailCell.h"
#import "ProductInfoModel.h"

@interface OrderDetailCell ()
{

    __weak IBOutlet ITTImageView *_imageView;
    __weak IBOutlet UILabel *_info;
    __weak IBOutlet UILabel *_productNO;
    __weak IBOutlet UILabel *_color;
    __weak IBOutlet UILabel *_size;
    __weak IBOutlet UILabel *_price;
    __weak IBOutlet UILabel *_count;
    IBOutlet UILabel *_NumLbl;
    
    BOOL isAutoShow;
    
    
    
}

@property(strong,nonatomic)ProductInfoModel * productInfo;
// app 1.4
@property (weak, nonatomic) IBOutlet UIButton *applyMoneyBtn;
@property (weak, nonatomic) IBOutlet UIButton *applyCoatBtn;
@property (weak, nonatomic) IBOutlet UILabel *stateInfoLbl;


@end



@implementation OrderDetailCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    
}

/**
 *  根据商品信息和购买的数量 显示订单详情
 *
 *  @param product
 *  @param count
 */
-(void)showOrderDetailWithProduct:(ProductInfoModel *)product
{
    [_imageView loadImage:product.imageUrl];
    _info.text = product.info;
    _productNO.text = product.num;
    _color.text = product.color;
    _size.text = product.size;
    _price.text = product.price;
    _count.text = product.buyCount;
//    if (!isAutoShow) {
//        [self autoDisplay];
//    }
    
    self.productInfo = product;
    
}

-(void)autoDisplay
{
    isAutoShow = YES;
    UIFont *font = [UIFont boldSystemFontOfSize:14.0];
    [_count setFont:font];
    [_count setNumberOfLines:1];
    NSString *text = _count.text;
    NSLog(@"Text = %@",text);
    
    CGSize size =[text sizeWithFont:font constrainedToSize:CGSizeMake(180.f, 30.f)];
    CGRect rect = _count.frame;
    rect.size = size;
    CGRect  newFrame = CGRectMake(GET_VIEW_WIDTH(self.contentView)-size.width-10, _count.origin.y + 8, 0, 0);
    newFrame.size = size;
    
    NSLog(@"_count.frame = %@",NSStringFromCGRect(_count.frame));
    [_count setFrame:newFrame];
    NSLog(@"_count.newframe = %@",NSStringFromCGRect(_count.frame));
    [_count setText:text];
    
    CGRect symbolRect = _NumLbl.frame;
    symbolRect.origin = CGPointMake(newFrame.origin.x - 30,  symbolRect.origin.y);
    _NumLbl.frame = symbolRect;
    
    
}

- (IBAction)tapShowProductInfo:(id)sender {
    
    _tapSendBlock(self.productInfo.num);
}

- (IBAction)applyToMoneyAction:(id)sender {

}

- (IBAction)applyToReturnCoatAction:(id)sender {
    
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
