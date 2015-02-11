//
//  MyOrderViewController.m
//  LingZhi
//
//  Created by boguoc on 14-2-27.
//
//

#import "MyOrderViewController.h"
#import "OrderModel.h"
#import "OrderListCell.h"
#import "OrderDetailController.h"
#import "LogisticsTrackingViewController.h"
#import "PKBaseRequest.h"
#import "ShareRemindView.h"

#define choosePaddingLeft 20
#define choosePaddingHeight 10


@interface MyOrderViewController ()<UITableViewDelegate,UITableViewDataSource,OrderDetailControllerDelegate>
{

//    IBOutlet UITableView *_tableView;
//    NSMutableArray * _allOrders;
    
    __weak IBOutlet UIView *_containsView;
    ShareRemindView * remindView;
}


@end

@implementation MyOrderViewController

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
    [self showRemindView];
    [self requestToGetOrderList];
}


#pragma mark - tableViewDelegate datasource


//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    if (!_allOrders || _allOrders.count == 0) {
//        remindView.hidden = NO;
//    }
//    
//    return 1;
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (_allOrders.count == 0 || !_allOrders) {
//        remindView.hidden = NO;
//    }
    return [_allOrders count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"OrderListCell";
    OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // Configure the cell...
    if(!cell){
        cell = [OrderListCell loadFromXib];
    }
    OrderModel * orderM = [_allOrders objectAtIndex:indexPath.row];
    [cell showOrderInfoWithOrder:orderM];
    cell.btnClickBlock = ^(){
        LogisticsTrackingViewController * logisticsVC = [[LogisticsTrackingViewController alloc] init];
        logisticsVC.orderId = orderM.orderId;
        [self.navigationController pushViewController:logisticsVC animated:YES];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderModel * model = _allOrders[indexPath.row];
    OrderDetailController * orderDetailVc = [[OrderDetailController alloc] init];
    orderDetailVc.delegate = self;
    orderDetailVc.order = model;
    [self.navigationController pushViewController:orderDetailVc animated:YES];
}



-(void)showRemindView
{
//    remindView = [[ShareRemindView alloc] initWithFrame:CGRectMake(0, 64, 320,SCREEN_HEIGHT - 64)];
    remindView = [[ShareRemindView alloc] init];
    
    [remindView showRemindInfoWithImage:[UIImage imageNamed:@"order.png"] andMsg:@"您还没有待处理订单"];
    __unsafe_unretained MyOrderViewController * orderListVc = self;
    remindView.btn_block = ^(){
        
        [orderListVc.navigationController popToRootViewControllerAnimated:YES];
    };
    [_containsView addSubview:remindView];
    [_containsView sendSubviewToBack:remindView];
    [remindView setHidden:YES];
    [_tableView setHidden:YES];
    
}

#pragma mark - ButtonMethods

- (IBAction)backToPreviousPageAction:(id)sender {
    
//    [self.navigationController popViewControllerAnimated:YES];
    //涉及商品详情页直接购买支付的问题，修改返回按钮，直接返回至根视图控制器
    if (_productController) {
        [self.navigationController popToViewController:_productController animated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - orderDetailDelegateMethod
-(void)makePreviewControllerRefresh:(NSMutableArray *)array
{
    _allOrders = array;
    [_tableView reloadData];
}


-(void)requestToGetOrderList
{
    if (!_allOrders) {
        _allOrders = [[NSMutableArray alloc]init];
    }

    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:DATA_ENV.userInfo.userId forKey:@"uid"];
    //新增系统标签参数 at 20140704 by Pk
    [parameter setObject:AppSystemId forKey:@"brandCode"];

    
    [RequestOrderList requestWithParameters:parameter
                                withIndicatorView:self.view
                                withCancelSubject:@"RequestOrderList"
                                   onRequestStart:nil
                                onRequestFinished:^(ITTBaseDataRequest *request) {
                                    if ([request isSuccess]) {
                                        [_allOrders addObjectsFromArray:request.handleredResult[@"keyModel"]];
                                        
                                        _allOrders = request.handleredResult[@"keyModel"];
                                        
                                        NSLog(@"_allOrders = %@",_allOrders);
                                        //当没有收藏的商品时，显示提示信息
                                        if([_allOrders count]==0 || _allOrders==Nil){
                                            
                                            [remindView setHidden:NO];
                                        }else{
                                            _tableView.hidden = NO;
                                            [remindView removeFromSuperview];
                                            [_tableView reloadData];
                                        }
                                    }
                                    
                                } onRequestCanceled:nil
                                  onRequestFailed:^(ITTBaseDataRequest *request) {
//                                      NSLog(@"wuwangsfdsfsdfsdfsf");
                                      remindView.hidden = NO;
                                      _tableView.hidden = YES;
                                  }];

}


@end
