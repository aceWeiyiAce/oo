    //
//  OrderDetailController.m
//  LingZhi
//
//  Created by pk on 3/11/14.
//
//

#import "OrderDetailController.h"
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




@interface OrderDetailController ()<UITableViewDataSource,UITableViewDelegate,ProductDetailInfoControllerDelegate>
{
    NSMutableArray * _containsProducts;
    
    __weak IBOutlet UITableView *_tableView;
    
    //header
    IBOutlet UIView *_header;
    __weak IBOutlet UILabel *_stateInHead;
    
    
    __weak IBOutlet UIView *_containsView;
    
    //footer
    IBOutlet UIView *_waitPayView;
    IBOutlet UIView *_waitPostView;
    IBOutlet UIView *_hasPostedView;
    IBOutlet UIView *_returningView;
    IBOutlet UIView *_finishedReturnView;
    IBOutlet UIView *_canceledView;
    IBOutlet UILabel *_cancelMsg;
    
    
    IBOutlet UIImageView *_returningImageView;
    
    
    
    //aboutView
    IBOutlet UIView *_aboutOrderView;
    __weak IBOutlet UIView *_aboutBottomView;
   
    __weak IBOutlet UILabel *_address;
    __weak IBOutlet UILabel *_postCash;
    __weak IBOutlet UILabel *_totalPrice;
    __weak IBOutlet UILabel *_payWay;
    __weak IBOutlet UILabel *_postWay;
    __weak IBOutlet UILabel *_timeDown;
    __weak IBOutlet UILabel *_aboutOrderNO;
    __weak IBOutlet UILabel *_createOrderTime;
    
    NSTimeInterval timeInterval;
    BOOL timeStart;
    
    //aboutView_Submitted
    IBOutlet UIView *_aboutOrderView_Submitted;
    __weak IBOutlet UIView *_aboutBottomView_Submitted;
    IBOutlet UILabel *_address_SMT;
    IBOutlet UILabel *_postCash_SMT;
    IBOutlet UILabel *_totalPrice_SMT;
    IBOutlet UILabel *_payWay_SMT;
    IBOutlet UILabel *_postWay_SMT;
    IBOutlet UILabel *_orderNO_SMT;
    IBOutlet UILabel *_createTime_SMT;
    __weak IBOutlet UILabel *_postNoLbl;
    
    OrderDetailInfoModel * _detailModel;
    
    //记录售后的电话
    NSString * _recordBehindSellTel;
    BOOL isPageFirstLoad;
    
    UIView * _bottomView;
    
}
@end

@implementation OrderDetailController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        [self initContainsProducts];
    }
    return self;
}

-(void)initContainsProducts
{
    //假设能取到数据
    _containsProducts = [NSMutableArray arrayWithArray:[ProductInfoModel createTestModels]];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self requsetToGetBehindSellTel];

//    [self requestToGetOrderDetailInfo];
    _bottomView = [[UIView alloc] init];
    [self.view addSubview:_bottomView];
    [self.view bringSubviewToFront:_bottomView];
}

-(void)viewWillAppear:(BOOL)animated
{
//    if (!isPageFirstLoad) {
//        [self requestToGetOrderDetailInfo];
//    }
    [self requestToGetOrderDetailInfo];
    
    _stateInHead.text          = _order.stateValue;
//    _tableView.tableHeaderView = _header;
}



/**
 *  设置有关的收货信息等...
 */
-(void)setSubviewsOfAboutView
{
    CGSize size =_address.size;
//    NSLog(@"size = %@",NSStringFromCGSize(size));
    _address.numberOfLines = 0;
    _address.width = 215.0;
    [_address sizeToFit];
    CGSize afterSize = _address.size;
//    NSLog(@"afterSize = %@",NSStringFromCGSize(afterSize));

    [self autolayoutAboutBottomView:_aboutBottomView startSize:size andEndSize:afterSize];
    
    
    CGSize submitSize = _address_SMT.size;
    _address_SMT.numberOfLines = 0;
    _address_SMT.width = 215.0;
    [_address_SMT sizeToFit];
    
    CGSize afterSubmitSize = _address_SMT.size;
    
    [self autolayoutAboutBottomView:_aboutBottomView_Submitted startSize:submitSize andEndSize:afterSubmitSize];
}

-(void)autolayoutAboutBottomView:(UIView *)view startSize:(CGSize)startSize andEndSize:(CGSize)endSize
{

     NSLog(@"startSize = %@",NSStringFromCGSize(startSize));
     NSLog(@"endSize = %@",NSStringFromCGSize(endSize));
    view.origin = CGPointMake(0, 0);
    CGPoint startOrigin = view.origin;
//    CGFloat height = endSize.height == 0 ? 30:endSize.height - startSize.height + 30;
    CGFloat height = endSize.height == 0 ? 30:endSize.height + 10;
    CGPoint endOrigin = CGPointMake( startOrigin.x, startOrigin.y + height);
    view.origin = endOrigin;
    NSLog(@"frame = %@",NSStringFromCGRect(view.frame));
    _aboutOrderView.size =  CGSizeMake(320, _aboutBottomView.size.height + height + 30);

    _aboutOrderView_Submitted.size =  CGSizeMake(320, _aboutBottomView.size.height + endSize.height - startSize.height + 30);
}


-(void)updateAboutOrderView
{
    
    
    NSDate * date = [NSDate dateWithString:_detailModel.submitDate formate:@"yyyy.MM.dd HH:mm:ss"];
    
    NSDate * sysDate = [NSDate dateWithString:_detailModel.sysDate formate:@"yyyy.MM.dd HH:mm:ss"];
    
    NSLog(@"systemDate =  %@",sysDate);
    timeInterval = [[date dateByAddingDays:1] timeIntervalSinceDate:sysDate];
    NSLog(@"timeInterval = %f",timeInterval);
    
    NSString * strContent;
    
    if (![_detailModel.province isEqualToString:@""] && _detailModel.province ) {
//        strContent = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",_detailModel.provinceId,_detailModel.cityId,_detailModel.boroughId,_detailModel.address,_detailModel.postCode];
         strContent = [NSString stringWithFormat:@"%@%@%@%@\n%@ +86 %@",_detailModel.provinceId,_detailModel.cityId,_detailModel.boroughId,_detailModel.address,_detailModel.receiver,_detailModel.contact];
    }
    
    _address.text = strContent;
    _postCash.text =[NSString stringWithFormat:@"￥ %@",_detailModel.postPrice];
    _totalPrice.text = _detailModel.totalPrice;
    _payWay.text = _detailModel.payCompany;
    _postWay.text = _detailModel.postCompany;
    
    _aboutOrderNO.text = _order.orderNo;
    _createOrderTime.text = _detailModel.submitDate;
    
    _address_SMT.text = strContent;
    _postCash_SMT.text =[NSString stringWithFormat:@"￥ %@",_detailModel.postPrice];
    _totalPrice_SMT.text = _detailModel.totalPrice;
    _payWay_SMT.text = _detailModel.payCompany;
    _postWay_SMT.text = _detailModel.postCompany;
    _postNoLbl.text = _detailModel.postId;
    _orderNO_SMT.text = _order.orderNo;
    _createTime_SMT.text = _detailModel.submitDate;
 
    [self setSubviewsOfAboutView];
}



-(void)setTableFootViewByOrderState
{
       NSLog(@"state =  %d",[self.order.state integerValue]);
    [self updateAboutOrderView];
    
    switch ([self.order.state integerValue]) {
        case oWaitPay:
            timeStart = YES;
            [self setTimeIntervalOnTimeDownWithInterval:3000];
            [self setBottomSubviewWithView:_waitPayView];
            
            
            break;
        case oWaitPost:

            [self setBottomSubviewWithView:_waitPostView];
            break;
        case oHasPosted:
            [self setBottomSubviewWithView:_hasPostedView];
            break;
        case oReturnOrChange:
            [self setBottomSubviewWithView:_returningView];
            [self returnIngImageViewAnimation];
            break;
        case oDealFinished:

            break;
        case oDealCanceled:
            [self setBottomSubviewWithView:_canceledView];
            break;
        case oReceivedGoods:
            [self setBottomSubviewWithView:_finishedReturnView];
            break;
        default:
            
            break;
    }
}

/**
 *  设置悬浮的底部视图
 */
-(void)setBottomSubviewWithView:(UIView *)view
{
    [_bottomView removeAllSubviews];
    [_bottomView setBackgroundColor:[UIColor whiteColor]];
    //设置BottomView的frame
    CGSize size = view.size;
    CGPoint origin;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
         origin= CGPointMake(0, SCREEN_HEIGHT - size.height);
    }else{
         origin = CGPointMake(0, SCREEN_HEIGHT - size.height-20);
    }
   
    _bottomView.origin = origin;
    _bottomView.size = size;
    [_bottomView addSubview:view];
    
    CGFloat _tableOriginHeight = SCREEN_HEIGHT - 64;
    
    //设置tableView的高度，避免被遮盖
    _tableView.height = _tableView.height - size.height;
    
    
    NSLog(@"_tableView.farme = %@",NSStringFromCGRect(_tableView.frame));
//    _tableView.contentSize = CGSizeMake(320, _tableView.contentSize.height - size.height);
    _tableView.size = CGSizeMake(320, _tableOriginHeight - size.height);
    NSLog(@"_tableView.farme = %@",NSStringFromCGRect(_tableView.frame));
}



-(void)setTimeIntervalOnTimeDownWithInterval:(double)value
{
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
}

#pragma mark - 倒计时
- (void)timerFireMethod:(NSTimer *)theTimer
{
    NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    NSDateComponents *endTime = [[NSDateComponents alloc] init];    //初始化目标时间...
    NSDate *today = [NSDate date];    //得到当前时间
    
    NSDate *date = [NSDate dateWithTimeInterval:timeInterval sinceDate:today];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    static int year;
    static int month;
    static int day;
    static int hour;
    static int minute;
    static int second;
    
    if(timeStart) {//从NSDate中取出年月日，时分秒，但是只能取一次
        year = [[dateString substringWithRange:NSMakeRange(0, 4)] intValue];
        month = [[dateString substringWithRange:NSMakeRange(5, 2)] intValue];
        day = [[dateString substringWithRange:NSMakeRange(8, 2)] intValue];
        hour = [[dateString substringWithRange:NSMakeRange(11, 2)] intValue];
        minute = [[dateString substringWithRange:NSMakeRange(14, 2)] intValue];
        second = [[dateString substringWithRange:NSMakeRange(17, 2)] intValue];
        timeStart= NO;
        
    }
    [endTime setYear:year];
    [endTime setMonth:month];
    [endTime setDay:day];
    [endTime setHour:hour];
    [endTime setMinute:minute];
    [endTime setSecond:second];
    NSDate *todate = [cal dateFromComponents:endTime]; //把目标时间装载入date
    
    
    //用来得到具体的时差，是为了统一成北京时间
    unsigned int unitFlags = NSYearCalendarUnit| NSMonthCalendarUnit| NSDayCalendarUnit| NSHourCalendarUnit| NSMinuteCalendarUnit| NSSecondCalendarUnit;
    NSDateComponents *d = [cal components:unitFlags fromDate:today toDate:todate options:0];
//    NSString *fen = [NSString stringWithFormat:@"%d", [d minute]];
    
    if ([d hour]<=0 && [d minute] <=0 && [d second] <= 0) {
        [self requestToCancelOrder];
        [theTimer invalidate];
        return;
    }
    
//    if([d minute] < 10) {
//        fen = [NSString stringWithFormat:@"0%d",[d minute]];
//    }
//    NSString *miao = [NSString stringWithFormat:@"%d", [d second]];
//    if([d second] < 10) {
//        miao = [NSString stringWithFormat:@"0%d",[d second]];
//    }
    
    if([d second] > 0) {
        
        //计时尚未结束，do_something
        NSString *title= [NSString stringWithFormat:@"%d时%d分%d秒,请尽快进行结算",[d hour],[d minute],[d second]];
        _timeDown.text = title;


    } else  {
        NSString *title= [NSString stringWithFormat:@"%d时%d分%d秒,请尽快进行结算",[d hour],[d minute],[d second]];
        _timeDown.text = title;
        
    }
    
   
}

/**
 *  旋转动画
 */
-(void)returnIngImageViewAnimation
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation             = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue     = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration    = 0.8;
    rotationAnimation.cumulative  = YES;
    rotationAnimation.repeatCount = 10000;
    
    [_returningImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

#pragma mark - tableViewDelegate datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [_detailModel.products count];
    return count>0 ? count + 1 :count;
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
        __unsafe_unretained OrderDetailController * orderControl =  self;
        cell.tapSendBlock = ^(NSString * pNumber){
            ProductDetailInfoController * pDetailVc = [[ProductDetailInfoController alloc] init];
            pDetailVc.delegate = orderControl;
            pDetailVc.pNumber = pNumber;
            [self.navigationController pushViewController:pDetailVc animated:YES];
        };
        
        return cell;
    }else{
        static NSString * cellIdentifier = @"CellIdentifier";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [self updateAboutOrderView];
        [self.order.state integerValue] == oWaitPay ? [cell.contentView addSubview: _aboutOrderView]:[cell.contentView addSubview: _aboutOrderView_Submitted];
        
        return cell;
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //最后一行显示aboutView的高度设置 订单状态
    if (indexPath.row == [_detailModel.products count]) {

        NSLog(@"rowIndex = %d",indexPath.row);
        return [self.order.state integerValue]== oWaitPay ? GET_VIEW_HEIGHT(_aboutOrderView) : GET_VIEW_HEIGHT(_aboutOrderView_Submitted);
//        return GET_VIEW_HEIGHT(_aboutOrderView);

    }else{
        return 137;
    }
    
//    if ([_detailModel.currentState isEqualToString:@"1"]) {
//        return GET_VIEW_HEIGHT(_aboutBottomView);
//    }
//    return GET_VIEW_HEIGHT(_aboutBottomView_Submitted);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ButtonMethods



- (IBAction)backToPreviewAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)goToPayAction:(id)sender {
    NSLog(@"结算跳转中......");

    
    SubmitViewController_New * submitVc  =[[SubmitViewController_New alloc] init];
    submitVc.orderDetail = _detailModel;
    
    [self.navigationController pushViewController:submitVc animated:YES];
    
}


- (IBAction)cancelOrderAction:(id)sender {
    
    NSString * strContent = [NSString stringWithFormat:@"本订单中包含 %@ 件商品，是否将 %@ 件商品重新放入购物车？",_detailModel.totalCount,_detailModel.totalCount];
    CustomAlertView *customAlert = [CustomAlertView loadFromXib];
    [customAlert showCustomViewWithSuperView:self.view title:@"取消订单提示" content:strContent oneButtonText:@"放回购物车" twoButtonText:@"直接取消订单" oneButtonActionBlock:^{
        
        NSLog(@"放回购物车 ing");
        [self requestToReturnProductInShopCar];
        
        
    } twoButtonBlock:^{
        
        [self requestToCancelOrder];
        
    }];
    
    
}

- (IBAction)cancelOrderAndApplyForMoneyAction:(id)sender {
    
    NSLog(@"取消订单，申请退款!");
    if ([[UIDevice currentDevice].model isEqualToString:@"iPhone"]) {
        PhoneView * phoneCall = [PhoneView loadFromXib];
        [phoneCall showPhoneViewWithSuperView:self.view title:@"拨打客服电话" content:_recordBehindSellTel oneButtonText:@"呼叫" twoButtonText:@"取消"];
    }else{
        [UIAlertView promptTipViewWithTitle:nil message:@"您的设备不支持呼叫功能" cancelBtnTitle:@"确定"  otherButtonTitles:nil onDismiss:^(int buttonIndex) {
            
        } onCancel:^{
            
        }];
    }
}

- (IBAction)confirmToReceivedAction:(id)sender {
    
    NSLog(@"确认收货");
    [self requestToConfirmProduct];
}

- (IBAction)wantToRetuanOrChangeAction:(id)sender {
    
    NSLog(@"我要退货......");
    
    if ([[UIDevice currentDevice].model isEqualToString:@"iPhone"]) {
        PhoneView * phoneCall = [PhoneView loadFromXib];
        [phoneCall showPhoneViewWithSuperView:self.view title:@"拨打客服电话" content:_recordBehindSellTel oneButtonText:@"呼叫" twoButtonText:@"取消"];
    }else{
        [UIAlertView promptTipViewWithTitle:nil message:@"您的设备不支持呼叫功能" cancelBtnTitle:@"确定"  otherButtonTitles:nil onDismiss:^(int buttonIndex) {
            
        } onCancel:^{
            
        }];
    }
    
    
    
}

#pragma mark - productDetailInfoControllerDelegate
-(void)makeMyOrderListRefresh
{
    [self requestToGetOrderList];
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
                                  [self setTableFootViewByOrderState];

                                  _tableView.tableHeaderView = _header;
                                  [_tableView reloadData];
                                  isPageFirstLoad = YES;
                              }
                              
                          } onRequestCanceled:nil
                            onRequestFailed:^(ITTBaseDataRequest *request) {
                                
                            }];
}


/**
 *  取消订单
 */
-(void)requestToCancelOrder
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:_order.orderId forKey:@"orderId"];
    [parameter setObject:DATA_ENV.userInfo.userId forKey:@"loginName"];
    [RequestCancelOrder requestWithParameters:parameter
                                withIndicatorView:self.view
                                withCancelSubject:@"RequestCancelOrder"
                                   onRequestStart:nil
                                onRequestFinished:^(ITTBaseDataRequest *request) {
                                    if ([request isSuccess]) {
                                        
                                        if ([request.handleredResult[@"status"] integerValue]==0) {
//                                           _tableView.tableFooterView = _canceledView;
                                            [self setBottomSubviewWithView:_canceledView];
                                            _order.state = [NSString stringWithFormat:@"%d",oDealCanceled];
                                            _stateInHead.text =@"已取消";
                                        }
                                        
                                        NSLog(@"status = %@",request.handleredResult[@"status"]);
                                        [self requestToGetOrderList];
                                        UITableViewCell * cell = [_tableView.visibleCells lastObject];
                                        [cell.contentView removeAllSubviews];
                                        [cell.contentView addSubview:_aboutOrderView_Submitted];
                                        [_tableView reloadData];
                                        
                                    }
                                    
                                } onRequestCanceled:nil
                                  onRequestFailed:^(ITTBaseDataRequest *request) {
                                      
                                  }];

}

/**
 *  获取订单列表,并返回、更新订单列表页
 */
-(void)requestToGetOrderList
{

    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:DATA_ENV.userInfo.userId forKey:@"uid"];
    //新增系统标签参数 at 20140704 by Pk
    [parameter setObject:AppSystemId forKey:@"brandCode"];
    
    [RequestOrderList requestWithParameters:parameter
                          withIndicatorView:nil
                          withCancelSubject:@"RequestOrderList"
                             onRequestStart:nil
                          onRequestFinished:^(ITTBaseDataRequest *request) {
                              if ([request isSuccess]) {
                                  NSMutableArray * _allOrders = [NSMutableArray array];
                                  [_allOrders addObjectsFromArray:request.handleredResult[@"keyModel"]];
                                  
                                  _allOrders = request.handleredResult[@"keyModel"];
                                  
                                  NSLog(@"_allOrders = %@",_allOrders);
                                  if ([_delegate respondsToSelector:@selector(makePreviewControllerRefresh:)]) {
                                      [_delegate makePreviewControllerRefresh:_allOrders];
//                                      [self.navigationController popViewControllerAnimated:YES];
                                  }
                                  
                              }
                              
                          } onRequestCanceled:nil
                            onRequestFailed:^(ITTBaseDataRequest *request) {
                                
                            }];
    
}


/**
 *  放回购物车，并取消订单
 */
-(void)requestToReturnProductInShopCar
{
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:DATA_ENV.userInfo.userId forKey:@"loginName"];
    [parameter setObject:self.order.orderId forKey:@"orderId"];
    //新增系统标签参数 at 20140704 by Pk
    [parameter setObject:AppSystemId forKey:@"brandCode"];
    
    [RequestToReturnProductInShopCar requestWithParameters:parameter
                          withIndicatorView:self.view
                          withCancelSubject:@"RequestToReturnProductInShopCar"
                             onRequestStart:nil
                          onRequestFinished:^(ITTBaseDataRequest *request) {
                              if ([request isSuccess]) {
                                  if ([request.handleredResult[@"status"] integerValue]==0) {
//                                      _tableView.tableFooterView = _canceledView;
                                      [self setBottomSubviewWithView:_canceledView];
                                      _order.state = [NSString stringWithFormat:@"%d",oDealCanceled];
                                  }
                                  
                                  NSLog(@"status = %@",request.handleredResult[@"status"]);
                                  [self requestToGetOrderList];
                                  _stateInHead.text =@"已取消";
                                  UITableViewCell * cell = [_tableView.visibleCells lastObject];
                                  [cell.contentView removeAllSubviews];
                                  [cell.contentView addSubview:_aboutOrderView_Submitted];
                                  [_tableView reloadData];
                              }
                              
                          } onRequestCanceled:nil
                            onRequestFailed:^(ITTBaseDataRequest *request) {
//                                [UIAlertView promptTipViewWithTitle:Nil message:request.handleredResult[@"messg"] cancelBtnTitle:@"确定" otherButtonTitles:Nil onDismiss:^(int buttonIndex) {
//                                    
//                                } onCancel:^{
//                                    
//                                }];
                            }];
    
}

/**
 *  确认收货
 */
-(void)requestToConfirmProduct
{
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:DATA_ENV.userInfo.userId forKey:@"loginName"];
    [parameter setObject:self.order.orderId forKey:@"orderId"];
    
    [RequestToConfirmReceiveOrder requestWithParameters:parameter
                                         withIndicatorView:self.view
                                         withCancelSubject:@"RequestToConfirmReceiveOrder"
                                            onRequestStart:nil
                                         onRequestFinished:^(ITTBaseDataRequest *request) {
                                             if ([request isSuccess]) {
                                                 if ([request.handleredResult[@"status"] integerValue]==0) {
//                                                     _tableView.tableFooterView = _canceledView;
                                                     [self setBottomSubviewWithView:_canceledView];
                                                     _order.state = [NSString stringWithFormat:@"%d",oDealCanceled];
                                                 }
//                                                 _tableView.tableFooterView = Nil;
                                                 [_bottomView removeFromSuperview];
                                                _tableView.size = CGSizeMake(320, SCREEN_HEIGHT-64);
                                                 _stateInHead.text =@"交易完成";
                                                 NSLog(@"status = %@",request.handleredResult[@"status"]);
                                                 [self requestToGetOrderList];
                                                 
                                             }
                                             
                                         } onRequestCanceled:nil
                                           onRequestFailed:^(ITTBaseDataRequest *request) {
//                                               [UIAlertView promptTipViewWithTitle:Nil message:request.handleredResult[@"messg"] cancelBtnTitle:@"确定" otherButtonTitles:Nil onDismiss:^(int buttonIndex) {
//                                                   
//                                               } onCancel:^{
//                                                   
//                                               }];
                                           }];

}


-(void)requsetToGetBehindSellTel
{
    [RequestToGetContactTel requestWithParameters:nil
                                      withIndicatorView:self.view
                                      withCancelSubject:@"RequestToGetContactTel"
                                         onRequestStart:nil
                                      onRequestFinished:^(ITTBaseDataRequest *request) {
                                          if ([request isSuccess]) {

                                              _recordBehindSellTel = request.handleredResult[@"data"][@"afterSales"];
                                          }
                                          
                                      } onRequestCanceled:nil
                                        onRequestFailed:^(ITTBaseDataRequest *request) {
                                            

                                        }];

}

@end
