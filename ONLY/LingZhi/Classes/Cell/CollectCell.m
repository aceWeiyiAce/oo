//
//  CollectCell.m
//  LingZhi
//
//  Created by pk on 3/3/14.
//
//

#import "CollectCell.h"


@interface CollectCell ()
{

   __weak IBOutlet UIView *_containsView;
   __weak IBOutlet UISwipeGestureRecognizer *_swipeCell;
    __weak IBOutlet UISwipeGestureRecognizer *_swipeRight;
    
    
   __weak IBOutlet ITTImageView *_imageView;
   __weak IBOutlet UILabel *_info;
   __weak IBOutlet UILabel *_productNO;
   __weak IBOutlet UILabel *_color;
   __weak IBOutlet UILabel *_sizeCode;
   __weak IBOutlet UILabel *_price;
    
   __weak IBOutlet UIButton *_addInCarBtn;
   __weak IBOutlet UIButton *_delBtn;
    
    
    BOOL isRightSwipeHasDone;
    CollectProductModel * _model;
   

}
@property (nonatomic,assign) BOOL isLeft;
@property (nonatomic,assign) BOOL inCar;
@end

@implementation CollectCell

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
    _swipeCell.direction =  UISwipeGestureRecognizerDirectionLeft;
//  _swipeCell.direction =  UISwipeGestureRecognizerDirectionLeft;
    isRightSwipeHasDone  = NO;
}

/**
 *  根据商品信息显示具体商品
 *  实际参数为product  待修改
 *  @param imageUrl
 *  @param proNO
 *  @param isInCar
 */
-(void)showProductInfoWithProduct:(NSString *)imageUrl productNO:(NSString *)proNO andIsInShopCar:(BOOL)isInCar
{
    [_imageView loadImage:imageUrl];
    _productNO.text = proNO;
    
    //显示是否在购物车中
    if (isInCar) {
        _inCarImageView.hidden = NO;
        _inCarImageView.backgroundColor = [UIColor redColor];
    }
}

-(void)showCollectProductWithCollectModel:(CollectProductModel *)model
{
    _model = model;
    ProductInfoModel * product = model.productInfo;

    [_imageView loadImage:product.imageUrl];
    _info.text = product.info;
    _productNO.text = product.num;
    _color.text = product.color;
    _sizeCode.text = product.size;
    _price.text = product.price;
//    if ([model.isInShopCar boolValue]) {
//        _inCarImageView.hidden = NO;
//    }
   
    self.isLeft = [model.hasDelete boolValue];
    self.inCar = [model.isInShopCar boolValue];
}

-(void)setIsLeft:(BOOL)isLeft
{
    _isLeft = isLeft;
    _containsView.right = _isLeft?240:320;
}

-(void)setInCar:(BOOL)inCar
{
    _inCar = inCar;
    _inCarImageView.hidden = inCar?NO:YES;
}

- (IBAction)swipeToLeftAction:(id)sender {
    
//     _isLeft = !_isLeft;
    _isLeft = YES;
     _model.hasDelete = _isLeft?@"1":@"0";
    [UIView animateWithDuration:.24f
                     animations:^{
                         _containsView.right = _isLeft?240:320;
                     } completion:^(BOOL finished) {
                         
                     }];
    
    
    
}

- (IBAction)swipeToRightAction:(id)sender {
    _isLeft = NO;
    _model.hasDelete = _isLeft?@"1":@"0";
    [UIView animateWithDuration:.24f
                     animations:^{
                         _containsView.right = _isLeft?240:320;
                     } completion:^(BOOL finished) {
                         
                     }];

}



-(void)showCheckedImageViewWithBool:(BOOL)isInShopCar
{
    _inCar = isInShopCar;
    _model.isInShopCar = isInShopCar?@"1":@"0";
    [UIView animateWithDuration:.24f
                     animations:^{
                         _inCarImageView.hidden = _inCar?NO:YES;
                     } completion:^(BOOL finished) {
                         
                     }];
}

-(void)resetCellWithIsLeft:(BOOL)isleft
{
    self.isLeft = isleft;
    _model.hasDelete = _isLeft?@"1":@"0";
}

- (IBAction)addInCarAction:(id)sender {
    
    NSLog(@"加入购物车");
    _addInCarBtnBlock(Nil);

}

- (IBAction)deleteAction:(id)sender {
    
    NSLog(@"删除");
//    id blockSender = (id)self;
    _delBtnBlock((id)self);
//    [UIView animateWithDuration:0.2f animations:^{
//        _containsView.right = 320;
//    }];
}


-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
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
