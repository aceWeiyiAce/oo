//
//  WaitPostOrderViewController.m
//  LingZhi
//
//  Created by kping on 14-8-26.
//
//

#import "WaitPostOrderViewController.h"
#import "ProductInfoModel.h"
#import "OrderDetailCell.h"
#import "LoginViewController.h"
#import "CustomAlertView.h"
#import "PhoneView.h"
#import "SubmitViewController.h"
#import "SubmitViewController_New.h"

#import "PKBaseRequest.h"
#import "OrderDetailInfoModel.h"
#import "NSDate+Utilities.h"
#import "UIAlertView+ITTAdditions.h"
#import "ProductDetailInfoController.h"
#import "UILabel+ITTAdditions.h"


@interface WaitPostOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
     OrderDetailInfoModel * _detailModel;
    
    
}


@property (weak, nonatomic) IBOutlet UIView *containsTopView;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLbl;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *receiveNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *mobileLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *containsBottomView;
@property (weak, nonatomic) IBOutlet UILabel *coatCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLbl;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;


@end

@implementation WaitPostOrderViewController

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
    // Do any additional setup after loading the view from its nib.
    [self requestToGetOrderDetailInfo];
    _cancelBtn.layer.borderColor = [UIColor colorWithWhite:0.761 alpha:1.000].CGColor;
    _cancelBtn.layer.borderWidth = 1.0;
}


-(void)autoLayOutPriceLabelWithString:(NSString *)string
{
    NSLog(@"totalPriceLbl.frame1 = %@",NSStringFromCGRect(_totalPriceLbl.frame));
    CGFloat width = [UILabel layoutLabelWidthWithText:string font:[UIFont boldSystemFontOfSize:17.0] height:21.0];
    CGFloat temp = width - _totalPriceLbl.width;
    _totalPriceLbl.width = width;
    _totalPriceLbl.left = _totalPriceLbl.left - temp;
    _coatCountLbl.left = _coatCountLbl.left - temp;
    
    NSLog(@"width = %f",width);
    NSLog(@"totalPriceLbl.frame2 = %@",NSStringFromCGRect(_totalPriceLbl.frame));
}

-(void)formatAddress
{
    //top
    _orderNumLbl.text = _detailModel.orderNumber;
    _orderTimeLbl.text = _detailModel.submitDate;
    _receiveNameLbl.text = _detailModel.receiver;
    _mobileLbl.text = _detailModel.contact;
    _addressLbl.text = [NSString stringWithFormat:@"%@%@%@%@",_detailModel.provinceId,_detailModel.cityId,_detailModel.boroughId,_detailModel.address];
    
    //bottom
    _coatCountLbl.text = [NSString stringWithFormat:@"共%@件商品要退款  合计:",_detailModel.totalCount];
    _totalPriceLbl.text = [NSString stringWithFormat:@"￥%@",_detailModel.totalPrice];
    
    [self autoLayOutPriceLabelWithString:_totalPriceLbl.text];
    _containsTopView.hidden = NO;
    _containsBottomView.hidden = NO;
}

#pragma mark - button Methods
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelAction:(id)sender {
    
}

- (IBAction)submitApplyAction:(id)sender {
    
}


#pragma mark - tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [_detailModel.products count];
//    return count>0 ? count + 1 :count;
    return count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row<[_detailModel.products count]) {
        static NSString *identifier = @"OrderDetailCell";
        OrderDetailCell *cell       = [tableView dequeueReusableCellWithIdentifier:identifier];
        // Configure the cell...
        if(!cell){
            cell = [OrderDetailCell loadFromXib];
        }
        
        ProductInfoModel * product = _detailModel.products[indexPath.row];
        [cell showOrderDetailWithProduct:product];
        __unsafe_unretained WaitPostOrderViewController * waitControl =  self;
        cell.tapSendBlock = ^(NSString * pNumber){
#warning 等待添加 201409827 by pk
            
//            ProductDetailInfoController * pDetailVc = [[ProductDetailInfoController alloc] init];
//            pDetailVc.delegate = waitControl;
//            pDetailVc.pNumber = pNumber;
            //            pDetailVc.productId = pNumber;
//            [self.navigationController pushViewController:pDetailVc animated:YES];
        };
        
        return cell;
    }else{
        static NSString * cellIdentifier = @"CellIdentifier";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - request Methods
/**
 *  获取订单详细信息
 */
-(void)requestToGetOrderDetailInfo
{
    if (!_detailModel) {
        _detailModel = [[OrderDetailInfoModel alloc]init];
    }
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:_order.orderId forKey:@"orderId"];
    [parameter setObject: DATA_ENV.userInfo.userId forKey:@"loginName"];
    [RequestOrderDetailInfo requestWithParameters:parameter
                                withIndicatorView:self.view
                                withCancelSubject:@"RequestOrderDetailInfo"
                                   onRequestStart:nil
                                onRequestFinished:^(ITTBaseDataRequest *request) {
                                    if ([request isSuccess]) {
                                        
                                        NSLog(@"orderDetail  = %@",request.handleredResult[@"keyModel"]);
                                        _detailModel = request.handleredResult[@"keyModel"];
                                        [_tableView reloadData];
                                        
                                        [self formatAddress];
                                    }
                                    
                                } onRequestCanceled:nil
                                  onRequestFailed:^(ITTBaseDataRequest *request) {
                                      
                                  }];
}




@end
