//
//  ProductListViewController.m
//  LingZhi
//
//  Created by boguoc on 14-5-9.
//
//

#import "ProductListViewController.h"
#import "PersonCenterView.h"
#import "ScanningCodeViewController.h"
#import "ProductCell.h"
#import "LoginViewController.h"
#import "CartViewController.h"
#import "MyFavoriteViewController.h"
#import "MyOrderViewController.h"
#import "AddressViewController.h"
#import "ChangePasswordViewController.h"
#import "Reachability.h"
#import "ProductDetailInfoController.h"

#import "LoadingViewController.h"

#import "ChangePsdViewController.h"

@interface ProductListViewController ()<ProductCellDelegate,PersonCenterViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UIView          *_contentView;
    __weak IBOutlet UITableView     *_tableView;
    __weak IBOutlet UILabel         *_productLabel;
    __weak IBOutlet UILabel         *_productCountLabel;
    __weak IBOutlet UILabel         *_productNameLabel;
    __weak IBOutlet UIView          *_productInfoView;
    __weak IBOutlet UIImageView     *_arrowImageView;
    __weak IBOutlet UIButton        *_sellButton;
    __weak IBOutlet UIButton        *_priceButton;
    __weak IBOutlet UIView          *_homeListTableViewFootView;
    
    NSMutableArray              *_products;
    NSMutableArray              *_productCellArr;
    int                         _productPage;
    NSString                    *_sortType;
    BOOL                        _deleteProductArr;
    BOOL                        _isMoreProductList;
    BOOL                        _isArrowTop;
    BOOL                        _isFirst;
    NSMutableArray * _productIdArr;
}
@end

@implementation ProductListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveReachability) name:checkMainData object:nil];
    }
    return self;
}

- (void)receiveReachability
{
    _sellButton.enabled = isReachability? YES:NO;
    _priceButton.enabled = isReachability? YES:NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _isFirst = YES;
    _productPage = 1;
    _sortType = @"0";
    _isMoreProductList = NO;
    _isArrowTop = NO;
    _deleteProductArr = NO;
    _arrowImageView.left = _priceButton.centerX + 15;
    
//    [self getProductListRequestWithProductId:_home];
}

#pragma mark - Request Methods

- (void)getProductListRequestWithProductId:(HomeModel *)home
{
    if (!_products) {
        _products = [[NSMutableArray alloc]init];
    }
    
    NSMutableDictionary *paramet = [[NSMutableDictionary alloc]init];
    if ([home.pId isEqualToString:@"0"]) {
        [paramet setObject:home.productClassId forKey:@"bcategory"];
    } else {
        [paramet setObject:home.pId forKey:@"bcategory"];
        [paramet setObject:home.productClassId forKey:@"scategory"];
    }
    [paramet setObject:[NSString stringWithFormat:@"%d",_productPage] forKey:@"IndexNum"];
    [paramet setObject:@"20" forKey:@"PageSize"];
    [paramet setObject:_sortType forKey:@"SortType"];
    
    NSLog(@"start__PK");
    
    [ProtuctListRequest requestWithParameters:paramet
                            withIndicatorView:self.view
                            withCancelSubject:@"ProtuctListRequest"
                               onRequestStart:nil
                            onRequestFinished:^(ITTBaseDataRequest *request) {
                                NSLog(@"end__PK");
                                if ([request isSuccess]) {
                                    if (_deleteProductArr) {
                                        [_products removeAllObjects];
                                        _deleteProductArr = NO;
                                    }
                                    [_products addObjectsFromArray:request.handleredResult[@"keyModel"]];
                                    [_tableView reloadData];
                                    if (_isFirst) {
                                        _tableView.top = 35;
                                        [self performSelector:@selector(moveTableView) withObject:nil afterDelay:3.0f];
                                        _isFirst = NO;
                                    }
                                    int temp = [request.handleredResult[@"data"][@"ProductNum"] intValue];
                                    
                                    if (_products.count >= temp) {
                                        _isMoreProductList = NO;
                                        //                                        _homeListTableViewFootView.hidden = YES;
                                    }else{
                                        _isMoreProductList = YES;
                                    }
                                    if (_products.count > 0) {
                                        _homeListTableViewFootView.hidden = NO;
                                    }
                                    [self layoutProductLabel:request.handleredResult[@"data"]];
                                }
                            }
                            onRequestCanceled:nil
                              onRequestFailed:^(ITTBaseDataRequest *request) {
                                  
                              }];
}

- (void)moveTableView
{
    [UIView animateWithDuration:.3f animations:^{
        _tableView.top = 0;
    }];
}

- (void)layoutProductLabel:(NSDictionary *)dic
{
    _productCountLabel.text = [NSString stringWithFormat:@"%@",dic[@"ProductNum"]];
    _productNameLabel.text = [NSString stringWithFormat:@"%@-共",dic[@"categoryName"]];
    
    _productNameLabel.width = [UILabel layoutLabelWidthWithText:[NSString stringWithFormat:@"%@-共",dic[@"categoryName"]] font:[UIFont systemFontOfSize:19] height:_productNameLabel.height];
    if (_productNameLabel.width > 180) {
        _productNameLabel.width = 180;
    }
    _productCountLabel.width = [UILabel layoutLabelWidthWithText:[NSString stringWithFormat:@"%@",dic[@"ProductNum"]] font:[UIFont systemFontOfSize:19] height:_productCountLabel.height] + 2;
    _productInfoView.width = _productNameLabel.width + _productCountLabel.width + _productLabel.width;
    
    _productInfoView.centerX = self.view.centerX;
    _productNameLabel.left = 0;
    _productCountLabel.left = _productNameLabel.right;
    _productLabel.left = _productCountLabel.right;
}


#pragma mark - Button Methods

- (IBAction)onBackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onPersonCenterButton:(id)sender
{
    [[PersonCenterView loadFromXib] showPersonCenterViewWithView:_contentView delegate:self];
}


- (IBAction)onPriceButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if (button.selected == YES) {
        button.selected = NO;
        _isArrowTop = YES;
    }
    if (!_isArrowTop) {
        _arrowImageView.transform = CGAffineTransformMakeRotation(3.14);
        _sortType = @"1";
    }else{
        _arrowImageView.transform = CGAffineTransformIdentity;
        _sortType = @"0";
    }
    _isArrowTop = !_isArrowTop;
    _arrowImageView.left = button.centerX + 15;
    _sellButton.selected = YES;
    _deleteProductArr = YES;
    _productPage = 1;
    [self getProductListRequestWithProductId:_home];
}
- (IBAction)onSellButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if (button.selected == YES) {
        button.selected = NO;
        _isArrowTop = YES;
    }
    if (!_isArrowTop) {
        _arrowImageView.transform = CGAffineTransformMakeRotation(3.14);
        _sortType = @"3";
    }else{
        _arrowImageView.transform = CGAffineTransformIdentity;
        _sortType = @"2";
    }
    _isArrowTop = !_isArrowTop;
    _arrowImageView.left = button.centerX + 15;
    _priceButton.selected = YES;
    _deleteProductArr = YES;
    _productPage = 1;
    
    [self getProductListRequestWithProductId:_home];
}

- (IBAction)onFootViewButton:(id)sender
{
    [UIView animateWithDuration:.4f animations:^{
        _tableView.contentOffset = CGPointMake(0, 0);
    }];
}

/**
 *  得到所有的productId
 */
-(void)getProductIdArr
{
    if (!_productIdArr) {
        _productIdArr = [NSMutableArray array];
    }
    [_productIdArr removeAllObjects];
    
    for (ProductCellModel * obj in _products) {
        if (obj.productId) {
            [_productIdArr addObject:obj.productId];
        }
    }
}


#pragma mark - UITableViewDelegate && UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self getProductIdArr];
    if (_products.count % 2 == 1) {
        return _products.count/2+1;
    } else {
        return _products.count/2;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *proIdentifier = @"ProductListCell";
    
    ProductCell *productCell = [tableView dequeueReusableCellWithIdentifier:proIdentifier];
    if (!productCell) {
        productCell = [ProductCell loadFromXib];
        productCell.delegate = self;
    }
    productCell.index = indexPath.row;
    
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:2];
    int x = indexPath.row * 2;
    int j = 0;
    if (_products.count%2 == 1 && indexPath.row == _products.count/2) {
        [productCell layoutProductCellWithModel:[_products objectAtIndex:x] andModel:nil];
        return productCell;
    }
    for (int i = 0; i<2; i++) {
        j = x + i;
        [tempArr addObject:[_products objectAtIndex:j]];
    }
    [productCell layoutProductCellWithModel:[tempArr objectAtIndex:0] andModel:[tempArr objectAtIndex:1]];
    
    return productCell;
}

#pragma mark - ProductCellDelegate
-(void)didOnLeftButtonAtIndex:(NSInteger)index
{
    ProductCellModel *model = [_products objectAtIndex:index];
    ProductDetailInfoController *product = [[ProductDetailInfoController alloc]init];
    ITTDPRINT(@"本款的productId为---%@",model.productId);
    ITTDPRINT(@"款式数组为---%@",model.productId);
    product.productId = model.productId;
    product.productIdArr = _productIdArr;
    [self.navigationController pushViewController:product animated:YES];
}

-(void)didOnRightButtonAtIndex:(NSInteger)index
{
    ProductCellModel *model = [_products objectAtIndex:index];
    ProductDetailInfoController *product = [[ProductDetailInfoController alloc]init];
    product.productId = model.productId;
    product.productIdArr = _productIdArr;
    [self.navigationController pushViewController:product animated:YES];
}

#pragma mark UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _tableView) {
        if (scrollView.contentOffset.y > scrollView.contentSize.height - _tableView.height + 55 && _isMoreProductList == YES) {
            _productPage++;
            _isMoreProductList = NO;
            [self getProductListRequestWithProductId:_home];
        }
    }
}

#pragma mark - PersonCenterViewDelegate

-(void)didOnPersonCenterButtonWithType:(PersonCenterButtonType)type
{
    switch (type) {
        case kPersonCenterCart:
        {
            if (DATA_ENV.userInfo.userId.length > 1) {
                CartViewController *cart = [[CartViewController alloc]init];
                cart.productController = self;
                [self.navigationController pushViewController:cart animated:YES];
            } else {
                [self presentLoginViewControllerWithString:@"CartViewController"];
            }
        }
            break;
        case kPersonCenterFavorite:
        {
            if (DATA_ENV.userInfo.userId.length > 1) {
                MyFavoriteViewController *favorite = [[MyFavoriteViewController alloc]init];
                favorite.productController = self;
                [self.navigationController pushViewController:favorite animated:YES];            } else {
                    [self presentLoginViewControllerWithString:@"MyFavoriteViewController"];
                }
            
        }
            break;
        case kPersonCenterOrder:
        {
            if (DATA_ENV.userInfo.userId.length > 1) {
                MyOrderViewController *order = [[MyOrderViewController alloc] init];
                order.productController = self;
                [self.navigationController pushViewController:order animated:YES];
            } else {
                [self presentLoginViewControllerWithString:@"MyOrderViewController"];
            }
        }
            break;
        case kPersonCenterAddress:
        {
            if (DATA_ENV.userInfo.userId.length > 1) {
                AddressViewController *address = [[AddressViewController alloc]init];
                address.productController = self;
                address.isAddressEdit = NO;
                [self.navigationController pushViewController:address animated:YES];
            } else {
                [self presentLoginViewControllerWithString:@"AddressViewController"];
            }
        }
            break;
        case kPersonCenterPassword:
        {
            if (DATA_ENV.userInfo.userId.length > 1) {
                ChangePsdViewController *psd = [[ChangePsdViewController alloc] init];
                //                ChangePasswordViewController *password = [[ChangePasswordViewController alloc]init];
                [self.navigationController pushViewController:psd animated:YES];
            } else {
                [self presentLoginViewControllerWithString:@"ChangePasswordViewController"];
            }
        }
            break;
        case kPersonCenterLogin:
        {
            if (DATA_ENV.userInfo.userId.length > 1) {
                
                [UIAlertView promptTipViewWithTitle:nil message:@"确认是否注销" cancelBtnTitle:@"取消" otherButtonTitles:@[@"确定"] onDismiss:^(int buttonIndex) {
                    UserInfo *userInfo = DATA_ENV.userInfo;
                    userInfo.userId = nil;
                    DATA_ENV.userInfo = userInfo;
                    ActivityRemindView *activity = [ActivityRemindView loadFromXib];
                    AddressModel *address = DATA_ENV.address;
                    address.addressId = nil;
                    DATA_ENV.address = address;
                    
                    [activity showActivityViewInView:self.view withMsg:@"注销成功" inSeconds:2];
                     [[NSNotificationCenter defaultCenter] postNotificationName:KEY_SHOW_COMPLETEBTN object:nil];
                } onCancel:^{
                    
                }];
                
                //                UserInfo *userInfo = DATA_ENV.userInfo;
                //                userInfo.userId = nil;
                //                DATA_ENV.userInfo = userInfo;
                //                ActivityRemindView *activity = [ActivityRemindView loadFromXib];
                //                [activity showActivityViewInView:self.view withMsg:@"注销成功" inSeconds:2];
            } else {
                [self presentLoginViewControllerWithString:nil];
            }
        }
            break;
        default:
            break;
    }
}

- (void)presentLoginViewControllerWithString:(NSString *)name
{
//    LoginViewController *login = [[LoginViewController alloc]init];
//    login.controllerName = name;
//    [self.navigationController pushViewController:login animated:YES];
    
    LoadingViewController *login = [[LoadingViewController alloc]init];
    //    login.controllerName = name;
    [self.navigationController pushViewController:login animated:YES];
}

/**
 *  检测用户是否已经登录
 *
 *  @return
 */
-(BOOL)isLogin
{
    if ([USER_DEFAULT valueForKey:UserNameKey]!=Nil && [USER_DEFAULT valueForKey:PWDKey]!=Nil) {
        return YES;
    }
    return NO;
}

@end
