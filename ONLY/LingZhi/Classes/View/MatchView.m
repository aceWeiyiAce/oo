
//
//  MatchView.m
//  LingZhi
//
//  Created by pk on 3/6/14.
//
//

#import "MatchView.h"
#import "MatchProduct.h"
#import "ProductInfoModel.h"

@interface MatchView ()
{
    __weak IBOutlet UIScrollView *_matchImage;

}
@end

@implementation MatchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"MatchView" owner:self options:Nil];
        self = [nib objectAtIndex:0];
        
        
        
        
    }
    [self addViewToScrollView];
    return self;
}

-(void)awakeFromNib
{
//    [self addViewToScrollView];
    [super awakeFromNib];
    
}

-(void)addViewToScrollView
{
    [_matchProducts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        ProductInfoModel * product = (ProductInfoModel *)obj;
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(8 + idx*8 + 70*idx , 0,70, GET_VIEW_HEIGHT(_matchImage))];
        
        MatchProduct * match = [[MatchProduct alloc] init];
        [match showImageWithUrl:product.imageUrl  andPrice:product.price andProductId:product.productId];
        
        [view addSubview:match];
        [_matchImage addSubview:view];
        
    }];
    
    int num = [_matchProducts count];
    
    CGFloat totalWidth = (num > 4 && num %4!=0)? (num/4+1)* GET_VIEW_WIDTH(_matchImage):num/4*GET_VIEW_WIDTH(_matchImage);
    _matchImage.contentSize =CGSizeMake(totalWidth, GET_VIEW_HEIGHT(_matchImage));

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
