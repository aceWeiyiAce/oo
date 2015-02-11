//
//  OrderShouldTotalPayCell.m
//  LingZhi
//
//  Created by pk on 3/26/14.
//
//

#import "OrderShouldTotalPayCell.h"

@implementation OrderShouldTotalPayCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)setStrContent:(NSString *)strContent
{
    CGRect priceRect = _totalPrice.frame;
    CGFloat priceWidth = [UILabel layoutLabelWidthWithText:strContent font:[UIFont systemFontOfSize:15.0] height:priceRect.size.height];
    
    //总价的相对位移
    CGFloat distance = priceWidth - _totalPrice.size.width;
    
    //合计往左移动的距离
    CGPoint totalTxtOrigin = CGPointMake(_totalTxt.origin.x - distance, _totalTxt.origin.y);
    //设置总价的frame
    _totalPrice.frame = CGRectMake(priceRect.origin.x - distance, priceRect.origin.y, priceWidth, priceRect.size.height);
    _totalTxt.origin = totalTxtOrigin;
    _totalPrice.text = strContent;
    
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
