//
//  WaitPayViewController.m
//  LingZhi
//
//  Created by apple on 14-8-26.
//
//
#import "WaitPayViewController.h"
#import "PKBaseRequest.h"
#import "OrderDetailInfoModel.h"
#import "orderdetailCell.h"
#import "ProductInfoModel.h"
#import "ProductDetailInfoController.h"
#import "SubmitViewController_New.h"

@interface WaitPayViewController ()<UITableViewDataSource,UITableViewDelegate,ProductDetailInfoControllerDelegate>{
    NSMutableArray *_orderArray ;
    OrderDetailInfoModel * _detailModel;

}
@property (weak, nonatomic) IBOutlet UIButton *cancelOrder;
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
@property (weak, nonatomic) IBOutlet UITableView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *containCount;
@property (strong, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UIButton *btn_goToPay;



@end

@implementation WaitPayViewController

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
    if (IOS7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _cancelOrder.layer.borderColor = [[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0 ]CGColor];
    _cancelOrder.layer.borderWidth = 1.0;
    _orderNum.text = _order.orderNo;
    _orderTime.text = _order.date;
    _containCount.text = [NSString stringWithFormat:@"共%@件商品",_order.containsCount];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"合计：¥ %@",_order.totalPrice]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, _order.totalPrice.length+2)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:12.0] range:NSMakeRange(0, 3)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0] range:NSMakeRange(3, _order.totalPrice.length+2)];
    if (IOS7) {
        _totalPrice.bottom = _containCount.bottom;
        _totalPrice.right = _btn_goToPay.right;
    }else{
        _totalPrice.bottom = _containCount.bottom;
        _totalPrice.right = _contentView.right;
        _totalPrice.textAlignment = UITextAlignmentCenter;
    }
    

    
    _totalPrice.attributedText = str;
    [self requestToGetOrderDetial];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) requestToGetOrderDetial
{
    if (!_detailModel) {
        _detailModel = [[OrderDetailInfoModel alloc]init];
    }
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:_order.orderId forKey:@"orderId"];
    [param setObject: DATA_ENV.userInfo.userId forKey:@"loginName"];
    [RequestOrderDetailInfo requestWithParameters:param withIndicatorView:self.view withCancelSubject:@"RequestOrderDetailInfo" onRequestStart:nil onRequestFinished:^(ITTBaseDataRequest *request) {
           if ([request isSuccess]) {
               _detailModel = request.handleredResult[@"keyModel"];

           }
        [_contentView reloadData];
        
        
        
    } onRequestCanceled:nil onRequestFailed:^(ITTBaseDataRequest *request) {

    }];


}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int count = [_detailModel.products count];
    return count;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *identifier = @"OrderDetailCell";
        OrderDetailCell *cell       = [tableView dequeueReusableCellWithIdentifier:identifier];
        // Configure the cell...
        if(!cell){
            cell = [OrderDetailCell loadFromXib];
        }
        __unsafe_unretained WaitPayViewController * waitPayVC =  self;
        ProductInfoModel * product = _detailModel.products[indexPath.row];
    
        [cell showOrderDetailWithProduct:product];
       
       cell.tapSendBlock = ^(NSString * pNumber){
           ProductDetailInfoController * pDetailVc = [[ProductDetailInfoController alloc] init];
           pDetailVc.delegate = waitPayVC;
           pDetailVc.pNumber = pNumber;
           //            pDetailVc.productId = pNumber;
           [waitPayVC.navigationController pushViewController:pDetailVc animated:YES];

       };
       return cell;
}

-(void)makeMyOrderListRefresh
{

}

- (IBAction)btn_backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goToPayAction:(id)sender {
    SubmitViewController_New *submitVC = [[SubmitViewController_New alloc] init];
    submitVC.orderDetail = _detailModel;
    [self.navigationController pushViewController:submitVC animated:YES];
}

@end
