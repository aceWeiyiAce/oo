//
//  OrderFormViewController.m
//  LingZhi
//
//  Created by feng on 14-8-25.
//
//

#import "OrderFormViewController.h"

#import "OrderFormTableViewCell.h"

#import "DataModels.h"

@interface OrderFormViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation OrderFormViewController
{
    NSInteger heit;
    NSArray *tableArray;
}

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
    if (IOS7) {
        self.topView.frame = CGRectMake(0, 0, 320, 20);
        self.tableview.frame = CGRectMake(0, Height-20, 320, SCREEN_HEIGHT-Height+20);
    }else {
        self.topNavBar.frame = CGRectMake(0, 0, 320, 44);
        self.tableview.frame = CGRectMake(0, Height, 320, SCREEN_HEIGHT-Height-20);
    }
    [self requestToGetOrderDetailInfo];
    [self setTableviewHeaderView];
}

- (void)setTableviewHeaderView
{
    heit = 0;
    UIView *view = [[UIView alloc] init];
    if (_kTypeNum >= 1) {
        [self makeViewForAddsubview:view andSupview:self.orderTypeView];
    }
    if (_kTypeNum >= 2) {
        [self makeViewForAddsubview:view andSupview:self.consigneeAddressView];
    }
    if (_kTypeNum >= 3) {
        [self makeViewForAddsubview:view andSupview:self.expressageView];
    }
    [view sizeToFit];
    self.tableview.tableHeaderView = view;
    if (IOS7) {
        self.footPayView.frame = CGRectMake(0, SCREEN_HEIGHT-self.footPayView.bounds.size.height, 320, self.footPayView.bounds.size.height);
        [self.view addSubview:self.footPayView];
        self.tableview.frame = CGRectMake(0, Height-20, 320, SCREEN_HEIGHT-Height+20-self.footPayView.bounds.size.height);
    }else {
        self.footPayView.frame = CGRectMake(0, SCREEN_HEIGHT-self.footPayView.bounds.size.height-20, 320, self.footPayView.bounds.size.height);
        [self.view addSubview:self.footPayView];
        self.tableview.frame = CGRectMake(0, Height, 320, SCREEN_HEIGHT-Height-20-self.footPayView.bounds.size.height);
    }
    ((UIButton *)[self.footPayView viewWithTag:255]).layer.borderWidth = 0.8f;
    ((UIButton *)[self.footPayView viewWithTag:255]).layer.borderColor = [[UIColor blackColor] CGColor];
}

- (void)makeViewForAddsubview:(UIView *)view1 andSupview:(UIView *)view2
{
    view2.frame = CGRectMake(0, heit, 320, view2.bounds.size.height);
    [view1 addSubview:view2];
    heit += view2.bounds.size.height;
    view1.frame = CGRectMake(0, 0, 320, heit);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressForOrderForm:(UIButton *)btn
{
    switch (btn.tag) {
        case 111:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 255:
            //申请退货
            break;
        case 256:
            //确认收货
            break;
        case 355:
            //快递公司
            break;
        case 455:
            //提交退货理由   确定
            break;
        default:
            break;
    }
}

#pragma mark - tableViewDelegate datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 138;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"OrderListCell";
    OrderFormTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [OrderFormTableViewCell loadFromXib];
    }
    PInfoList *model = [tableArray objectAtIndex:indexPath.row];
    cell.orderName.text = model.pname;
    cell.orderNumber.text = [NSString stringWithFormat:@"货号 %@",model.pnumber];
    cell.orderColor.text = model.colorName;
    cell.orderType.text = model.sizeName;
    cell.orderPrice.text = [NSString stringWithFormat:@"￥%@",model.totalPrice];
    cell.orderNO.text = [NSString stringWithFormat:@"%f",model.buyNumber];
    [cell.orderImage loadImage:model.purl];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - request Methods


/**
 *  获取订单详细信息
 */
-(void)requestToGetOrderDetailInfo
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:self.orderId forKey:@"orderId"];
    [parameter setObject: DATA_ENV.userInfo.userId forKey:@"loginName"];
    [RequestOrderDetailInfo requestWithParameters:parameter
                                withIndicatorView:self.view
                                withCancelSubject:@"RequestOrderDetailInfo"
                                   onRequestStart:nil
                                onRequestFinished:^(ITTBaseDataRequest *request) {
                                    if ([request isSuccess]) {
                                        
//                                        NSLog(@"orderDetail  = %@",request.handleredResult);
                                        BaseClass *model = [BaseClass modelObjectWithDictionary:request.handleredResult];
                                        Data *data = model.data;
                                        tableArray = data.pInfoList;
                                        NSLog(@"%@",data);
                                        [self.tableview reloadData];
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
    [parameter setObject:self.orderId forKey:@"orderId"];
    [parameter setObject:DATA_ENV.userInfo.userId forKey:@"loginName"];
    [RequestCancelOrder requestWithParameters:parameter
                            withIndicatorView:self.view
                            withCancelSubject:@"RequestCancelOrder"
                               onRequestStart:nil
                            onRequestFinished:^(ITTBaseDataRequest *request) {
                                if ([request isSuccess]) {
                                    
                                    if ([request.handleredResult[@"status"] integerValue]==0) {
                                        //                                           _tableView.tableFooterView = _canceledView;
                                        NSLog(@"%@",request.handleredResult);
                                    }
                                    
                                    NSLog(@"status = %@",request.handleredResult[@"status"]);
                                    [self requestToGetOrderList];

                                    
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
    [parameter setObject:self.orderId forKey:@"orderId"];
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
                                                     
                                                 }
                                                 
                                                 NSLog(@"status = %@",request.handleredResult[@"status"]);
                                                 [self requestToGetOrderList];
                                                 
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
    [parameter setObject:self.orderId forKey:@"orderId"];
    
    [RequestToConfirmReceiveOrder requestWithParameters:parameter
                                      withIndicatorView:self.view
                                      withCancelSubject:@"RequestToConfirmReceiveOrder"
                                         onRequestStart:nil
                                      onRequestFinished:^(ITTBaseDataRequest *request) {
                                          if ([request isSuccess]) {
                                              if ([request.handleredResult[@"status"] integerValue]==0) {
                                                  //                                                     _tableView.tableFooterView = _canceledView;
                                                  NSLog(@"%@",request.handleredResult);
                                              }
                                              //                                                 _tableView.tableFooterView = Nil;
                                              
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
                                        
                                        NSLog(@"%@",request.handleredResult);
                                    }
                                    
                                } onRequestCanceled:nil
                                  onRequestFailed:^(ITTBaseDataRequest *request) {
                                      
                                      
                                  }];
    
}

@end
