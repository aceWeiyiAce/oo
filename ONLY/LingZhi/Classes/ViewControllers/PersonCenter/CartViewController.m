//
//  CartViewController.m
//  LingZhi
//
//  Created by boguoc on 14-2-27.
//
//

#import "CartViewController.h"
#import "CartCell.h"
#import "CartModel.h"
#import "LYBaseRequest.h"
#import "SubmitViewController_New.h"
#import "ProductDetailInfoController.h"

@interface CartViewController ()<UITableViewDelegate,UITableViewDataSource,CartCellDelegate>
{
    __weak IBOutlet UILabel             *_priceIntLabel;
    __weak IBOutlet UILabel             *_priceDeLabel;
    __weak IBOutlet UITableView         *_tabelView;
    __weak IBOutlet UIView              *_onCartView;
    __weak IBOutlet UIButton            *_allChooseButton;
    
    NSMutableArray                      *_cartArray;
    NSMutableArray                      *_checkoutArray;
    NSString                            *_checkoutStr;
    NSIndexPath                         *_index;
}
@end

@implementation CartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_cartArray) {
        _cartArray = [[NSMutableArray alloc]init];
        _checkoutArray = [[NSMutableArray alloc]init];
    }
    [self cartListRequest];
}
- (void)cartListRequest
{
    //    [_cartArray addObjectsFromArray:[CartModel createTestModels]];
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:DATA_ENV.userInfo.userId,@"userId",AppSystemId,@"brandCode", nil];
    //新增系统标签参数 at 20140704 by Pk
//    [parameter setObject:AppSystemId forKey:@"brandCode"];
    
    [GetCartListRequest requestWithParameters:parameter
                            withIndicatorView:self.view
                            withCancelSubject:@"GetCartListRequest"
                               onRequestStart:^(ITTBaseDataRequest *request) {
                                   
                               }
                            onRequestFinished:^(ITTBaseDataRequest *request) {
                                if ([request isSuccess]) {
                                    [_cartArray removeAllObjects];
                                    [_cartArray addObjectsFromArray:request.handleredResult[@"keyModel"]];
                                    [self layoutTableViewsFooderViewWithString:[NSString stringWithFormat:@"%@",request.handleredResult[@"data"][@"totalBuyPrice"]]];
                                    _tabelView.hidden = _cartArray.count>0?NO:YES;
                                    _onCartView.hidden = _cartArray.count>0?YES:NO;
                                    
                                    [_tabelView reloadData];
                                }
                            }
                            onRequestCanceled:nil
                              onRequestFailed:^(ITTBaseDataRequest *request) {
                                  [_cartArray removeAllObjects];
                                  _tabelView.hidden = _cartArray.count>0?NO:YES;
                                  _onCartView.hidden = _cartArray.count>0?YES:NO;
                              }];
}

- (void)deleteCartRequestWithNumber:(NSString *)num
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:DATA_ENV.userInfo.userId forKey:@"loginName"];
    [parameter setObject:num forKey:@"pnumber"];
    [DeleteCartRequest requestWithParameters:parameter
                           withIndicatorView:self.view
                           withCancelSubject:@"DeleteCartRequest"
                              onRequestStart:nil
                           onRequestFinished:^(ITTBaseDataRequest *request) {
                               if (request.isSuccess) {
                                   ActivityRemindView *act = [ActivityRemindView loadFromXib];
                                   [act showActivityViewInView:self.view withMsg:@"删除成功" inSeconds:2];
                                   
                                   [_cartArray removeObjectAtIndex:_index.row];
                                   [_tabelView beginUpdates];
                                   [_tabelView deleteRowsAtIndexPaths:@[_index] withRowAnimation:UITableViewRowAnimationFade];
                                   [_tabelView endUpdates];
                                   [self getCheckoutStr];
                                    if (_cartArray.count < 1) {
                                       _tabelView.hidden = YES;
                                       _onCartView.hidden = NO;
                                       return;
                                   }
                                   [_tabelView performSelector:@selector(reloadData) withObject:nil afterDelay:.3f];
                                   [self layoutTableViewsFooderViewWithString:nil];
                               }
                           } onRequestCanceled:nil
                             onRequestFailed:^(ITTBaseDataRequest *request) {
                                 
                             }];
}

- (void)CartCheckoutRequest
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:DATA_ENV.userInfo.userId forKey:@"userId"];
    [parameter setObject:_checkoutStr forKey:@"plist"];
    [parameter setObject:@"1" forKey:@"isShopcarts"];
    //新增系统标签参数 at 20140704 by Pk
    [parameter setObject:AppSystemId forKey:@"brandCode"];
    
    [CartCheckoutRequest requestWithParameters:parameter
                           withIndicatorView:self.view
                           withCancelSubject:@"CartCheckoutRequest"
                              onRequestStart:nil
                           onRequestFinished:^(ITTBaseDataRequest *request) {
                               if (request.isSuccess) {
                                   NSString *message = request.handleredResult[@"messg"];
                                   if ([message isEqualToString:@"订单失败,商品库存不足"]) {
//                                       ActivityRemindView *activity = [ActivityRemindView loadFromXib];
//                                       [activity showActivityViewInView:self.view withMsg:message inSeconds:2];
                                       [self checkoutInfoWithModel:request.handleredResult[@"kModel"]];
                                   } else {
                                       _checkoutStr = @"";
                                       [_checkoutArray removeAllObjects];
                                       SubmitViewController_New *submit = [[SubmitViewController_New alloc]init];
                                       submit.orderDetail = [request.handleredResult objectForKey:@"kModel"];
                                       [self.navigationController pushViewController:submit animated:YES];
                                   }
                               }
                           } onRequestCanceled:nil
                             onRequestFailed:^(ITTBaseDataRequest *request) {
                             }];
}

- (void)checkoutInfoWithModel:(NSArray *)model
{
    for (int i = 0; i<_checkoutArray.count; i++) {
        CartModel *changeCart = model[i];
        CartModel *cart = _checkoutArray[i];
        cart.hasTip = changeCart.hasTip;
        cart.productInfo.buyCount = changeCart.productInfo.buyCount;
        cart.productInfo.storeCount = changeCart.productInfo.storeCount;
    }
    [_tabelView reloadData];
}

- (void)layoutTableViewsFooderViewWithString:(NSString *)str
{
    float priceTemp = 0;
    int temp = 0;
    for (int i = 0; i < _cartArray.count; i++) {
        CartModel *model = [_cartArray objectAtIndex:i];
        if ([model.isSelect isEqualToString:@"1"]) {
            priceTemp += [model.productInfo.price floatValue] *[model.buyCount intValue];
            temp++;
        }
    }
    if (temp == _cartArray.count) {
        _allChooseButton.selected = YES;
    } else {
        _allChooseButton.selected = NO;
    }
    NSArray *array = [[NSString stringWithFormat:@"%.2f",priceTemp] componentsSeparatedByString:@"."];
    _priceIntLabel.text = [NSString stringWithFormat:@"%@",array[0]];
    _priceDeLabel.text = [NSString stringWithFormat:@".%@",array[1]];
    _priceIntLabel.width = [UILabel layoutLabelWidthWithText:_priceIntLabel.text font:_priceIntLabel.font height:_priceIntLabel.height];
    _priceDeLabel.width = [UILabel layoutLabelWidthWithText:_priceDeLabel.text font:_priceDeLabel.font height:_priceDeLabel.height];
    _priceDeLabel.left = _priceIntLabel.right + 1;
}

#pragma mark - Button Methods

- (IBAction)onBackButton:(id)sender
{
    if (_productController) {
        [self.navigationController popToViewController:_productController animated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)allChooseButton:(id)sender
{
    if (_cartArray.count < 1) {
        return;
    }
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    for (CartModel *cart in _cartArray) {
        cart.isSelect = button.selected?@"1":@"0";
    }
//    if (button.selected == ) {
//        <#statements#>
//    }
    [self layoutTableViewsFooderViewWithString:nil];
    [self getCheckoutStr];
    [_tabelView reloadData];
}

- (IBAction)onSettleButton:(id)sender
{
    BOOL hasTip = NO;
    for (CartModel *cart in _cartArray) {
        if ([cart.hasTip isEqualToString:@"1"] && [cart.isSelect isEqualToString:@"1"]) {
            hasTip = YES;
        }
    }
    if (_checkoutArray.count < 1) {
        [UIAlertView promptTipViewWithTitle:@"请选取购买商品" message:nil cancelBtnTitle:@"确认" otherButtonTitles:nil onDismiss:^(int buttonIndex) {} onCancel:^{}];
        return;
    } else if (hasTip) {
        [UIAlertView promptTipViewWithTitle:@"所选商品库存不足" message:nil cancelBtnTitle:@"确认" otherButtonTitles:nil onDismiss:^(int buttonIndex) {} onCancel:^{}];
    } else {
        [self CartCheckoutRequest];
    }
}

- (IBAction)onToShoppingButton:(id)sender
{
//    if (_productController) {
//        [self.navigationController popToViewController:_productController animated:YES];
//    } else {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartModel *cart = [_cartArray objectAtIndex:indexPath.row];
    if ([cart.hasTip isEqualToString:@"1"]) {
        return 198;
    } else {
        return 143;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cartArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CartCell";
    
    CartCell *cartCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cartCell) {
        cartCell = [CartCell loadFromXib];
        cartCell.delegate = self;
    }
    cartCell.cartCellIndexPath = indexPath;
    [cartCell layoutCartCellWithModel:[_cartArray objectAtIndex:indexPath.row]];
    
    return cartCell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - CartCellDelegate

-(void)deleteCartCellWithIndex:(NSIndexPath *)index
{
    [UIAlertView promptTipViewWithTitle:@"删除提示" message:@"是否删除此件商品" cancelBtnTitle:@"取消" otherButtonTitles:@[@"确认"] onDismiss:^(int buttonIndex) {
        _index = index;
        CartModel *model = [_cartArray objectAtIndex:index.row];
        [self deleteCartRequestWithNumber:model.productInfo.num];
    } onCancel:^{
        CartModel *model = [_cartArray objectAtIndex:index.row];
        model.hasDelete = @"0";
        [_tabelView reloadData];
    }];

}

-(void)reloadCartCellWithIndex:(NSIndexPath *)indexPath
{
    [_tabelView beginUpdates];
    [_tabelView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [_tabelView endUpdates];
    [self layoutTableViewsFooderViewWithString:nil];
    [self getCheckoutStr];
}

-(void)didSelectCellWithIndex:(NSIndexPath *)indexPath
{
    [self layoutTableViewsFooderViewWithString:nil];
    [self getCheckoutStr];
    
}

- (void)getCheckoutStr
{
    [_checkoutArray removeAllObjects];
    _checkoutStr = @"";
    for (CartModel *cart in _cartArray) {
        if ([cart.isSelect isEqualToString:@"1"]) {
            [_checkoutArray addObject:cart];
            _checkoutStr = [NSString stringWithFormat:@"%@,%@_%@",_checkoutStr,cart.productInfo.num,cart.buyCount];
        }
    }
    if (_checkoutStr.length>1) {
        _checkoutStr = [_checkoutStr substringFromIndex:1];
    }
}

- (void)didClickImageWithIndex:(NSIndexPath *)indexPath
{
    CartModel *model = [_cartArray objectAtIndex:indexPath.row];
    ProductDetailInfoController *product = [[ProductDetailInfoController alloc]init];
    product.productId = model.productInfo.productId;
    product.productIdArr = [NSArray arrayWithObjects:model.productInfo.productId, nil];
    [self.navigationController pushViewController:product animated:YES];
}

@end
