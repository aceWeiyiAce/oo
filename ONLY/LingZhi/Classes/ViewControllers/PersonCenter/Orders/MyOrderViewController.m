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
#import "WaitPostOrderViewController.h"
#import "WaitPayViewController.h"
#import "OrderFormViewController.h"

#define choosePaddingLeft 20
#define choosePaddingHeight 10


@interface MyOrderViewController ()<UITableViewDelegate,UITableViewDataSource,OrderDetailControllerDelegate>
{

//    IBOutlet UITableView *_tableView;
//    NSMutableArray * _allOrders;
    
    __weak IBOutlet UIView *_containsView;
    ShareRemindView * remindView;
    
    NSArray * _arrayBtns;
    NSArray * _arrayBtnImages;
    
    NSMutableArray * _showArray;
}

@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIImageView *allBtnImage;

@property (weak, nonatomic) IBOutlet UIButton *waitPayBtn;
@property (weak, nonatomic) IBOutlet UIImageView *waitPayImage;

@property (weak, nonatomic) IBOutlet UIButton *postedBtn;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;

@property (weak, nonatomic) IBOutlet UIButton *finishedBtn;
@property (weak, nonatomic) IBOutlet UIImageView *finishedImage;


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
    
    _arrayBtns = [NSArray arrayWithObjects:_allBtn,_waitPayBtn,_postedBtn,_finishedBtn, nil];
    
    _arrayBtnImages = [NSArray arrayWithObjects:_allBtnImage,_waitPayImage,_postImage,_finishedImage, nil];
    
    [self changeBtnStateWithButton:_allBtn andImageView:_allBtnImage];
    
    _showArray = [[NSMutableArray alloc] init];
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
    return [_showArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"OrderListCell";
    OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // Configure the cell...
    if(!cell){
        cell = [OrderListCell loadFromXib];
    }
    OrderModel * orderM = [_showArray objectAtIndex:indexPath.row];
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
    OrderModel * model = _showArray[indexPath.row];
    if ([model.state intValue] == oWaitPost) {
        WaitPostOrderViewController * waitP = [[WaitPostOrderViewController alloc] init];
        waitP.order = model;
        [self.navigationController pushViewController:waitP animated:YES];
        return;
    }
    
    if ([model.state intValue] == oWaitPay) {
        WaitPayViewController * waitP = [[WaitPayViewController alloc] init];
        waitP.order = model;
        
        [self.navigationController pushViewController:waitP animated:YES];
        return;
    }

    OrderFormViewController *form = [[OrderFormViewController alloc] init];
    form.orderId = model.orderId;
    form.kTypeNum = 3;
    [self.navigationController pushViewController:form animated:YES];
    return;
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

- (IBAction)allBtnAction:(id)sender {
    [self changeBtnStateWithButton:_allBtn andImageView:_allBtnImage];
    [_showArray removeAllObjects];
    [_showArray addObjectsFromArray:_allOrders];
    [_tableView reloadData];
}

- (IBAction)waitPayAction:(id)sender {
    [self changeBtnStateWithButton:_waitPayBtn andImageView:_waitPayImage];
    [_showArray removeAllObjects];
    for (OrderModel *obj in _allOrders) {
        if ([obj.state intValue] == oWaitPay) {
            [_showArray addObject:obj];
        }
    }
    [_tableView reloadData];

}

- (IBAction)postedBtnAction:(id)sender {
    [self changeBtnStateWithButton:_postedBtn andImageView:_postImage];
    
    [_showArray removeAllObjects];
    for (OrderModel *obj in _allOrders) {
        if ([obj.state intValue] == oHasPosted) {
            [_showArray addObject:obj];
        }
    }
    [_tableView reloadData];
}

- (IBAction)finishedBtnAction:(id)sender {
    [self changeBtnStateWithButton:_finishedBtn andImageView:_finishedImage];
    [_showArray removeAllObjects];
    for (OrderModel *obj in _allOrders) {
        if ([obj.state intValue] == oDealFinished) {
            [_showArray addObject:obj];
        }
    }
    [_tableView reloadData];
}

-(void)changeBtnStateWithButton:(UIButton *)btn andImageView:(UIImageView *)imageView
{
    for (UIButton * obj in _arrayBtns) {
        if (obj == btn) {
            btn.selected = YES;
        }else{
            obj.selected = NO;
        }
    }
    
    for (UIImageView * obj in _arrayBtnImages) {
        if (obj == imageView) {
            obj.hidden = NO;
        }else{
            obj.hidden = YES;
        }
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
                                            [_showArray addObjectsFromArray:_allOrders];
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
