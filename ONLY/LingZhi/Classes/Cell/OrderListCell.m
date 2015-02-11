//
//  OrderListCell.m
//  LingZhi
//
//  Created by pk on 3/11/14.
//
//

#import "OrderListCell.h"
#import "OrderModel.h"

@interface OrderListCell ()
{

    IBOutlet UIButton *_trackBtn;
    OrderModel *_order;
    IBOutlet UILabel *_symbolMoney;
    
    
}
@property (weak, nonatomic) IBOutlet UILabel *countDesc;


@end

@implementation OrderListCell


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

/**
 *  根据order信息，给cell中的信息赋值
 *
 *  @param order
 */
-(void)showOrderInfoWithOrder:(OrderModel *)order
{
    if (order) {
        _order = order;
        self.orderNo.text = order.orderNo;
//        self.orderNo.text = order.orderId;
        self.date.text = order.date;
        self.containsCount.text = order.containsCount;
        self.totalPrice.text = order.totalPrice;
        self.state.text = order.stateValue;
        [self autoDisplay];
        [self autoLayOutContainsCount];
        _trackBtn.hidden = [order.state intValue] == oHasPosted ? NO : YES;
    }
}

-(void)autoLayOutContainsCount
{
    UIFont *font = [UIFont boldSystemFontOfSize:14.0];
    [_containsCount setFont:font];
    [_containsCount setNumberOfLines:1];
    NSString *text = _containsCount.text;
    
    CGSize size =[text sizeWithFont:font constrainedToSize:CGSizeMake(180.f, 30.f)];
//    CGRect rect = _containsCount.frame;
    CGRect rect = CGRectMake(42, 64, 30, 20);
    rect.size = size;
    CGRect  newFrame = CGRectMake(rect.origin.x, 64, 0, 0);
    newFrame.size = size;
    
    [_containsCount setFrame:newFrame];
    [_containsCount setText:text];
    
    NSLog(@"newFrame = %@",NSStringFromCGRect(newFrame));
    
    CGRect symbolRect = _countDesc.frame;
    symbolRect.origin = CGPointMake(newFrame.origin.x + 10 + size.width, 64);
    _countDesc.frame = symbolRect;
    
}


-(void)autoDisplay
{

    UIFont *font = [UIFont boldSystemFontOfSize:14.0];
    [_totalPrice setFont:font];
    [_totalPrice setNumberOfLines:1];
    NSString *text = _totalPrice.text;
   
    CGSize size =[text sizeWithFont:font constrainedToSize:CGSizeMake(180.f, 30.f)];
    CGRect rect = _totalPrice.frame;
    rect.size = size;
    CGRect  newFrame = CGRectMake(GET_VIEW_WIDTH(self.contentView)-size.width-10, 64, 0, 0);
    newFrame.size = size;
    
    [_totalPrice setFrame:newFrame];
    [_totalPrice setText:text];
    
    CGRect symbolRect = _symbolMoney.frame;
    symbolRect.origin = CGPointMake(newFrame.origin.x - 20, 64);
    _symbolMoney.frame = symbolRect;
    
    
}

#pragma mark - ButtonMethods

- (IBAction)showPostInfo:(id)sender {
    
    _btnClickBlock();
    
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
