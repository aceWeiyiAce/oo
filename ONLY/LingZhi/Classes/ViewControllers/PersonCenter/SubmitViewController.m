//
//  SubmitViewController.m
//  LingZhi
//
//  Created by pk on 3/26/14.
//
//

#import "SubmitViewController.h"
#import "OrderContainsProducts.h"
#import "OrderProductCell.h"
#import "OrderShouldTotalPayCell.h"
#import "OrderAddressView.h"
#import "ProductInfoModel.h"
#import "AddressModel.h"
#import "LoginCell.h"
#import "PostCompanyModel.h"

#import "UPPayPlugin.h"
#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"
#import "AlixLibService.h"
#import "AddressEditViewController.h"
#import "Base64.h"





@interface SubmitViewController ()<UITableViewDelegate,UITableViewDataSource,OrderAddressViewDelegate,AddressEditViewControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UPPayPluginDelegate,AlixPaylibDelegate>
{
    
    IBOutlet UITableView *_tableTop;
    
    IBOutlet UIView *_orderIntroduceView;
    IBOutlet UIView *_postAndPayView;
    
    
    IBOutlet UIImageView *_airPayRadio;
    IBOutlet UIImageView *_unionPayRadio;
    
    
    int selectBtnTag;
    NSString * savePayWayStr;
    
    NSMutableArray * _addressInputs;
    
    OrderAddressView * _addressView;
    
    
    IBOutlet UIPickerView *_postCompanyPickView;
    IBOutlet UITextField *_postCompanyTxt;
    NSString * _recordPayWay;
    
    IBOutlet UIView *_savedAddressView;
    
    IBOutlet UILabel *_savedReceiveName;
    
    IBOutlet UILabel *_savedReceiveAddress;
    IBOutlet UILabel *_savedMobile;
    
    BOOL hasAddress;
    NSArray * _postArray;
}

@end

@implementation SubmitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _addressInputs = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0,@0,@0,@0, nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self requestToGetPostCompany];
     _postCompanyTxt.leftViewMode = UITextFieldViewModeAlways;
    _postCompanyTxt.leftView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    
    //默认的收货地址  DATA_ENV.address
//    DATA_ENV.address
    
    selectBtnTag = 10001;
    savePayWayStr = @"支付宝";
    
    hasAddress = [_orderDetail.receiver isEqualToString:@""] ? NO : YES;
    if (!hasAddress) {
        AddressModel * model = DATA_ENV.address;
        hasAddress = model ? YES : NO ;
    }
    if (!hasAddress) {
        //写在此处是为了方便计算cell的高度
        _addressView = [[OrderAddressView alloc] init];
        
        
        //        [_addressView setUsefulAction:^{
        //            //模态退出
        //            NSLog(@"跳转到地址选择页面");
        //        }];
        //        [_addressView setSaveAddressAction:^(UITableView *table){
        //            //读取tableView 中得信息 send到后台
        //
        //            //将信息赋值给收货信息视图中得对应字段
        //
        //            //将视图从父视图中删除
        //
        //            //将收货信息添加到视图中
        //
        //
        //
        //        }];
        
    }else{

        if ([_orderDetail.receiver isEqualToString:@""]) {
             AddressModel * model = DATA_ENV.address;
            [self updateAddressShowWithAddress:model];
        }else{
            _savedReceiveName.text = _orderDetail.receiver;
            
            _savedReceiveAddress.numberOfLines = 0;
            _savedReceiveAddress.width = GET_VIEW_WIDTH(_savedReceiveAddress);
            _savedReceiveAddress.text = [NSString stringWithFormat:@"%@%@%@%@",_orderDetail.province,_orderDetail.city,_orderDetail.borough,_orderDetail.address];
            [_savedReceiveAddress sizeToFit];
            
            _savedMobile.text = [NSString stringWithFormat:@"电话:%@",_orderDetail.contact];
        }
    }
    NSLog(@"_addressView = %@",NSStringFromCGRect(_addressView.frame));
    
    _tableTop.tableHeaderView = _orderIntroduceView;
    _tableTop.tableFooterView = _postAndPayView;
 

}

/**
 *  根据地址model 显示收货信息
 *
 *  @param adm
 */
-(void)updateAddressShowWithAddress:(AddressModel *)adm
{
    _savedReceiveName.text = adm.name;
    _savedReceiveAddress.numberOfLines = 0;
    _savedReceiveAddress.width = GET_VIEW_WIDTH(_savedReceiveAddress);
    _savedReceiveAddress.text = [NSString stringWithFormat:@"%@%@%@%@",adm.province,adm.city,adm.area,adm.address];
    [_savedReceiveAddress sizeToFit];
    _savedMobile.text = [NSString stringWithFormat:@"电话:%@",adm.phone];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableView delegate Methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row < [_orderDetail.products count]) {
        
        ProductInfoModel * product = (ProductInfoModel *)    _orderDetail.products[indexPath.row];
        UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 192, 0)];
        lbl.text =product.info;
        lbl.numberOfLines = 0;
        lbl.width = GET_VIEW_WIDTH(lbl);
        [lbl sizeToFit];
       
        return lbl.height;
    }
    
    if (indexPath.row == [    _orderDetail.products count]+1) {
        if (hasAddress) {
            NSLog(@"_savedAddressView height = %f",GET_VIEW_HEIGHT(_savedAddressView));
            return 181;
        }else{
            return [_addressView tableHeight];
        }
    }
    else{
        return 44;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_orderDetail.products count]+2;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [_orderDetail.products count]) {
        static NSString *identifier = @"OrderProductCell";
        OrderProductCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [OrderProductCell loadFromXib];
        }
        
        ProductInfoModel * product = (ProductInfoModel *)_orderDetail.products[indexPath.row];
        
        cell.infoLbl.text = product.info;
        cell.infoLbl.numberOfLines = 0;
        cell.infoLbl.width = 192;
        [cell.infoLbl sizeToFit];
        
        cell.price.text =[NSString stringWithFormat:@"%@  ￥%@",product.buyCount,product.price] ;
        NSLog(@"height = %f",cell.infoLbl.height);
       
        cell.height = cell.infoLbl.height;
        
        return cell;
        
    }
    if(indexPath.row == [_orderDetail.products count]){
        
        static NSString *identifier = @"OrderShouldTotalPayCell";
        OrderShouldTotalPayCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [OrderShouldTotalPayCell loadFromXib];
        }

        cell.totalPrice.text =[NSString stringWithFormat:@"%@  ￥%@", _orderDetail.totalCount, _orderDetail.totalPrice] ;
        return cell;
        
    }
    
    if (indexPath.row == [    _orderDetail.products count]+1) {
        
        static NSString * identifier = @"customTableView";
        UITableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:identifier ];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            
        }
        if (hasAddress) {
            [cell.contentView addSubview:_savedAddressView];
        }else{
            if (_addressView) {
                __unsafe_unretained SubmitViewController * submitVC = self;
                [_addressView setUsefulAction:^{
                    //模态退出
                    NSLog(@"跳转到地址选择页面");
                    AddressEditViewController * addVc =[[AddressEditViewController alloc] init];
                    addVc.delegate = submitVC;
                    [submitVC.navigationController pushViewController:addVc animated:YES];
                    
                }];
                
            }
            _addressView.orderId = _orderDetail.orderId;
            _addressView.delegate = self;
            [_addressView setSaveAddressAction:^(AddressModel *model){
                
                
            }];
            
            [cell.contentView addSubview:_addressView];

        }
            
        return cell;
    }
    
    return nil;
}

-(void)autoDisplay
{
    
//    UIFont *font = [UIFont boldSystemFontOfSize:14.0];
//    [_totalPrice setFont:font];
//    [_totalPrice setNumberOfLines:1];
//    NSString *text = _totalPrice.text;
//    
//    CGSize size =[text sizeWithFont:font constrainedToSize:CGSizeMake(180.f, 30.f)];
//    CGRect rect = _totalPrice.frame;
//    rect.size = size;
//    CGRect  newFrame = CGRectMake(GET_VIEW_WIDTH(self.contentView)-size.width-10, 64, 0, 0);
//    newFrame.size = size;
//    
//    [_totalPrice setFrame:newFrame];
//    [_totalPrice setText:text];
//    
//    CGRect symbolRect = _symbolMoney.frame;
//    symbolRect.origin = CGPointMake(newFrame.origin.x - 20, 64);
//    _symbolMoney.frame = symbolRect;
    
    
}


-(void)changeViewToShow:(AddressModel *)model
{
    [self updateAddressViewWithAddress:model];
}

/**
 *  更新地址的显示视图
 *
 *  @param model
 */
-(void)updateAddressViewWithAddress:(AddressModel *)model
{
    UITableViewCell * cell = [_tableTop.visibleCells lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    [cell.contentView removeAllSubviews];
    
    _savedReceiveName.text = model.name;
    NSString * address = [NSString stringWithFormat:@"%@%@%@%@",model.province,model.city,model.area,model.address];
    _savedReceiveAddress.numberOfLines = 0;
    _savedReceiveAddress.text = address;
    [_savedReceiveAddress sizeToFit];
    _savedMobile.text = [NSString stringWithFormat:@"电话:%@",model.phone];
    
    hasAddress = YES;
    [_tableTop reloadData];
}

#pragma mark - pickView Delegate
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_postArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    PostCompanyModel * model = _postArray[row];
    
    return model.carrierName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    PostCompanyModel * model = _postArray[row];
    _postCompanyTxt.text =  model.carrierName;
}


#pragma mark - Button Methods
- (IBAction)backToPreviewAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)choosePayRadioAction:(id)sender {
    UIButton * btn =(UIButton *)sender;
    selectBtnTag = btn.tag;
    switch (btn.tag) {
        case 10001:
            savePayWayStr = @"支付宝";
            _airPayRadio.image = [UIImage imageNamed:@"radioBtnChecked.png"];
            _unionPayRadio.image = [UIImage imageNamed:@"radioBtn.png"];
            break;
        case 10002:
            savePayWayStr = @"银联";
            _airPayRadio.image = [UIImage imageNamed:@"radioBtn.png"];
            _unionPayRadio.image = [UIImage imageNamed:@"radioBtnChecked.png"];
            break;
            
        default:
            break;
    }
    
    NSLog(@"savePayWay = %@",savePayWayStr);
}

- (IBAction)gotoPayAction:(id)sender {
    NSLog(@"我要支付了");
    
    //保存快递公司和支付方式
    [self requestToUpdatePostCompanyAndPayWay];
    
    if (selectBtnTag == 10002) {
        [self RequestToGetUnionPayTradeNum];
        return;
    }
    
//    AlixPayOrder *order = [[AlixPayOrder alloc] init];
//    order.partner = PartnerID;
//    order.seller = SellerID;
//    
//    order.tradeNO = _orderDetail.orderId; //订单ID（由商家自行制定）
//	order.productName = @"凌志商品"; //商品标题
//	order.productDescription = @"好贵，好贵。。。。。。"; //商品描述
//	order.amount = [NSString stringWithFormat:@"%.2f",0.01]; //商品价格
//	order.notifyURL =  @"http://www.xxx.com"; //回调URL
//    order.serviceName = @"mobile.securitypay.pay";
//    order.paymentType = @"1";
//    order.inputCharset = @"utf-8";
//    order.itBPay = @"30m";
//    order.showUrl = @"m.alipay.com";
//
//    NSString *appScheme = @"AliPayForOnly";
////    NSString* orderInfo = [self getOrderInfo];
////    NSString* signedStr = [self doRsa:orderInfo];
//    
////    NSLog(@"%@",signedStr);
//    
//	//将商品信息拼接成字符串
//	NSString *orderSpec = [order description];
//	NSLog(@"orderSpec = %@",orderSpec);
//	
//	//获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//	id<DataSigner> signer = CreateRSADataSigner(PartnerPrivKey);
//    
//    NSLog(@"signer = %@",signer);
//    
//	NSString *signedString = [signer signString:orderSpec];
//    NSLog(@"signedString = %@",signedString);
//	
//	//将签名成功字符串格式化为订单字符串,请严格按照该格式
//	NSString *orderString = nil;
//	if (signedString != nil) {
//		orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                       orderSpec, signedString, @"RSA"];
//        [AlixLibService payOrder:orderString AndScheme:appScheme seletor:@selector(paymentResult:) target:self];
//    
//    }

//    NSString *partner = @"2088101568358171";
//    NSString *seller = @"alipay-test09@alipay.com";
//    NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBANEliZbjWsu4KpsHAFAMAJoa9x5nfS8t0+xhEAvQ5qheFPv+rEwRne8Mr/D+a3uH3iEz7890kGp6lnPrLKhvSWbKXJmZnPWjYnyVnANL48hQZfvxclUF/Qkxfe2EIttZbuM8nIOIyh5Dfx398kWHVS6TPZrda/VJm9C3cph/b0a3AgMBAAECgYAtQJX4k9C9a2esi2NB7pbiwRre9T1cy+mip421QMnnfBPGQmA9RUKKyo/28NWIsOka/gXROUNWBpgvFJ9hAlM7CjcKzqTV4ph0IQ5XSo0TWvYaJq9aJAelCH+RMa0/If58AIOrJ+qGYESRO4386xAhxXQb89RpTBEIy3M0LxtlIQJBAO7rCW1RXSRtT7Aj5Fb4FmOhlukqL7yLNlhuz2KY+axcyFqzihM39zDB1sF7XYN94b21elLAZntJkufzW67Gk1sCQQDgGZZs3IU5lvVokOJaTZVTynDKAYFMlv6t76yD7DkRtVh/2U9UZOew1fLQvBRDcWP8flpQdXLsLQkV1XfYP8TVAkEAoK5aDLdn2RPbQC8jZoo7JI6MnAvPRxKpXhhISZtwb0eHR9jvx7Uf/h6ffEinv8NtitT+i6DyS4BT2MOGqajLeQJAFHVhjTiolPRaHRy0/Wd9zXN6zoZKppJWV8y8pCKJpzs2BB3zpxG7MSKnEzVIaEvOw/tJBXVjc3o9DRg646wWrQJBAOBeQVevEq1m8dmEgiQDeajUolJeItwTw3eksrH8CypEWOgGsIdafGCWexSBs68+3zs2mR32cPquPmT99HSoVUI=";
//    AlixPayOrder *order = [[AlixPayOrder alloc] init];
//	order.partner = partner;
//	order.seller = seller;
//	order.tradeNO = @"111111111111111"; //订单ID（由商家自行制定）
//	order.productName = @"only Mode"; //商品标题
//	order.productDescription = @"sdfasdsgsdgsg"; //商品描述
//	order.amount = [NSString stringWithFormat:@"%.2f",0.01]; //商品价格
//	order.notifyURL =  @"http://www.xxx.com"; //回调URL
//    
//    order.serviceName = @"mobile.securitypay.pay";
//    order.paymentType = @"1";
//    order.inputCharset = @"utf-8";
//    order.itBPay = @"30m";
//    order.showUrl = @"m.alipay.com";
//	
//	//应用注册scheme,在AlixPayDemo-Info.plist定义URL types
//	NSString *appScheme = @"AliPayForOnly";
//	
//	//将商品信息拼接成字符串
//	NSString *orderSpec = [order description];
//	NSLog(@"orderSpec = %@",orderSpec);
//	
//	//获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//	id<DataSigner> signer = CreateRSADataSigner(privateKey);
//	NSString *signedString = [signer signString:orderSpec];
//	
//	//将签名成功字符串格式化为订单字符串,请严格按照该格式
//	NSString *orderString = nil;
//	if (signedString != nil) {
//		orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                       orderSpec, signedString, @"RSA"];
//        
//        NSLog(@"orderString = %@",orderString);
//        
//        NSString * orderStr = @"partner=\"2088901725026871\"&seller_id=\"payment-china@f-club.cn\"&out_trade_no=\"IOIRHQJ1W4G9MRB\"&subject=\"话费充值\"&body=\"[四钻信誉]北京移动30元 电脑全自动充值 1到10分钟内到账\"&total_fee=\"1.01\"&notify_url=\"http://www.xxx.com\"&service=\"mobile.securitypay.pay\"&payment_type=\"1\"&_input_charset=\"utf-8\"&it_b_pay=\"30m\"&show_url=\"m.alipay.com\"&sign=\"CumqORF7%2F10buAjzKjl6fRw%2B7Gi0FF7Iq%2FqfwjsA%2BDZUZgYWZaAQn%2B4%2FrsPTImVFKwuWctCcXII863a0oRNciUXo3KKpypV9xsHGVxP%2BZ%2BqrgGqfyB6iMZ7AuuisjZslo7cZqaNC4IEIUKOuX1au27ir3KBdjnn%2FfZk034Dqtwc%3D\"&sign_type=\"RSA\"";
//        
//        NSString * str2 = @"_input_charset=\"utf-8\"&notify_url=\"http://pay.fclub.cn/\"&out_trade_no=\"PT2014032618247\"&partner=\"2088901725026871\"&payment_type=\"1\"&seller_id=\"payment-china@f-club.cn\"&service=\"mobile.securitypay.pay\"&subject=\"DD20130918A912C\"&total_fee=\"147.00\"&sign=\"CumqORF7%2F10buAjzKjl6fRw%2B7Gi0FF7Iq%2FqfwjsA%2BDZUZgYWZaAQn%2B4%2FrsPTImVFKwuWctCcXII863a0oRNciUXo3KKpypV9xsHGVxP%2BZ%2BqrgGqfyB6iMZ7AuuisjZslo7cZqaNC4IEIUKOuX1au27ir3KBdjnn%2FfZk034Dqtwc%3D\"&sign_type=\"RSA\"";
//        
//        [AlixLibService setFullScreen];
//        [AlixLibService payOrder:str2 AndScheme:appScheme seletor:@selector(paymentResult:) target:self];
//        
//    }

    
}

- (IBAction)manageAddressAction:(id)sender {
    //模态跳转到地址页

    AddressEditViewController * addVc =[[AddressEditViewController alloc] init];
    addVc.delegate =self;
    [self.navigationController pushViewController:addVc animated:YES];
}

/**
 *  显示或隐藏快递公司选择器
 *
 *  @param sender <#sender description#>
 */
- (IBAction)showOrHidePostCompanyPickView:(id)sender {
    _postCompanyPickView.hidden = !_postCompanyPickView.hidden;
    
}

- (void)didChooseAddress:(AddressModel *)model
{
    NSLog(@"%@",model);
    [self updateAddressViewWithAddress:model];
    [self requestToSaveAddress:model];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _tableTop.contentInset = contentInsets;
    _tableTop.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    //    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
    //        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
    //        [_tableTop setContentOffset:scrollPoint animated:YES];
    //    }
    //    [_tableTop setContentOffset:scrollPoint animated:YES];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _tableTop.contentInset = contentInsets;
    _tableTop.scrollIndicatorInsets = contentInsets;
}


-(void)requestToSaveAddress:(AddressModel *)address
{
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:DATA_ENV.userInfo.userId forKey:@"userId"];
    [parameter setObject:self.orderDetail.orderId forKey:@"orderId"];
    [parameter setObject:address.name forKey:@"receiver"];
    [parameter setObject:address.address forKey:@"receiveAddress"];
    [parameter setObject:address.province forKey:@"province"];
    [parameter setObject:address.city forKey:@"city"];
    [parameter setObject:address.area forKey:@"borough"];
    [parameter setObject:address.phone forKey:@"contact"];
    [parameter setObject:address.postalNum forKey:@"postCode"];
    
    
    [RequestToSaveReceiceAddress requestWithParameters:parameter
                                     withIndicatorView:self.view
                                     withCancelSubject:@"RequestToSaveReceiceAddress"
                                        onRequestStart:nil
                                     onRequestFinished:^(ITTBaseDataRequest *request) {
                                         if ([request isSuccess]) {
                                             
                                         }
                                         
                                     } onRequestCanceled:nil
                                       onRequestFailed:^(ITTBaseDataRequest *request) {
                                           [UIAlertView promptTipViewWithTitle:Nil message:request.handleredResult[@"messg"] cancelBtnTitle:@"确定" otherButtonTitles:Nil onDismiss:^(int buttonIndex) {
                                               
                                           } onCancel:^{
                                               
                                           }];
                                       }];
    
    
}

-(void)requestToGetPostCompany
{
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];

//    [parameter setObject:@"OMS" forKey:@"carriderCode"];

    _postArray = nil;
    [RequestToGetPostCompany requestWithParameters:parameter
                                     withIndicatorView:self.view
                                     withCancelSubject:@"RequestToGetPostCompany"
                                        onRequestStart:nil
                                     onRequestFinished:^(ITTBaseDataRequest *request) {
                                         if ([request isSuccess]) {
                                             
                                        
                                             _postArray =[NSArray arrayWithArray: request.handleredResult[@"keyModel"]];
                                             NSLog(@"array = %@",request.handleredResult[@"keyModel"]);
                                             [_postCompanyPickView reloadAllComponents];
                                             if ([_postCompanyTxt.text isEqualToString:@""]) {
                                                 PostCompanyModel * model = [_postArray firstObject];
                                                 _postCompanyTxt.text = model.carrierName;
                                             }
                                         }
                                         
                                     } onRequestCanceled:nil
                                       onRequestFailed:^(ITTBaseDataRequest *request) {
                                           [UIAlertView promptTipViewWithTitle:Nil message:request.handleredResult[@"messg"] cancelBtnTitle:@"确定" otherButtonTitles:Nil onDismiss:^(int buttonIndex) {
                                               
                                           } onCancel:^{
                                               
                                           }];
                                       }];
    
    
}

/**
 *  保存快递方式和支付方式
 */
-(void)requestToUpdatePostCompanyAndPayWay
{
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    
    [parameter setObject:_orderDetail.orderId forKey:@"orderId"];
    [parameter setObject:DATA_ENV.userInfo.userId forKey:@"userId"];
    [parameter setObject:_postCompanyTxt.text forKey:@"expressCompany"];
    [parameter setObject:savePayWayStr forKey:@"payCompany"];
    
    
    [RequestToUpdatePostAndPayCompany requestWithParameters:parameter
                                 withIndicatorView:self.view
                                 withCancelSubject:@"RequestToUpdatePostAndPayCompany"
                                    onRequestStart:nil
                                 onRequestFinished:^(ITTBaseDataRequest *request) {
                                     if ([request isSuccess]) {
                                         
                                     }
                                     
                                 } onRequestCanceled:nil
                                   onRequestFailed:^(ITTBaseDataRequest *request) {
                                
                                   }];

}

-(void)requestUpdateOrderState
{
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    
    [parameter setObject:_orderDetail.orderId forKey:@"orderId"];
    [parameter setObject:DATA_ENV.userInfo.userId forKey:@"userId"];
    [parameter setObject:[NSNumber numberWithInt:oWaitPost] forKey:@"orderStateId"];

    
    
    [RequestToUpdateOrderState requestWithParameters:parameter
                                          withIndicatorView:self.view
                                          withCancelSubject:@"RequestToUpdateOrderState"
                                             onRequestStart:nil
                                          onRequestFinished:^(ITTBaseDataRequest *request) {
                                              if ([request isSuccess]) {
                                                  
                                              }
                                              
                                          } onRequestCanceled:nil
                                            onRequestFailed:^(ITTBaseDataRequest *request) {
                                                
                                            }];
}

-(void)RequestToGetUnionPayTradeNum
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    
    [parameter setObject:[self encodeString:_orderDetail.orderId inTimes:3] forKey:@"od"];
    
    [RequestToGetUnionPayTN requestWithParameters:parameter
                                          withIndicatorView:self.view
                                          withCancelSubject:@"RequestToGetUnionPayTN"
                                             onRequestStart:nil
                                          onRequestFinished:^(ITTBaseDataRequest *request) {
                                              if ([request isSuccess]) {
                                                  NSString *tradeNo = request.handleredResult[@"data"][@"tradeno"];
                                                  NSLog(@"tradeNo = %@",tradeNo);
                                                  
                                                  [UPPayPlugin startPay:tradeNo mode:@"01" viewController:self delegate:self];
                                                  
                                              }
                                              
                                          } onRequestCanceled:nil
                                            onRequestFailed:^(ITTBaseDataRequest *request) {
                                                
                                            }];
    

}

-(NSString *)encodeString:(NSString *)str inTimes:(int)times
{
    NSMutableString * result = [NSMutableString stringWithFormat:@"%@%@",str,@"onlyh5orderid&%"];
    for (int i =0; i<times; i++) {
        
        NSData * data = [[NSData alloc] initWithData:[result dataUsingEncoding:NSUTF8StringEncoding]];
        result = [NSMutableString stringWithString:[data base64EncodedString]];
        result = [NSMutableString stringWithString:[result encodeUrl]];
        NSLog(@"result = %@",result);
    }
    return result;
}

#pragma mark - 银联支付回调接口 协议
/**
 *  银联支付回调接口 协议
 *
 *  @param result
 */
-(void)UPPayPluginResult:(NSString*)result
{
//#warning 支付成功，更改订单状态
    NSLog(@"reuslt = %@",result);
    if ([result isEqualToString:@"success"]) {
        
    }
}




//wap回调函数
-(void)paymentResult:(NSString *)resultd
{
    //结果处理

    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
	if (result)
    {
		
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            NSString* key = AlipayPubKey;//签约帐户后获取到的支付宝公钥
			id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            
			if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                //验证签名成功，交易结果无篡改
			}
        }
        else
        {
            //交易失败
        }
    }
    else
    {
        //失败
    }
    
}


-(NSString*)getOrderInfo
{
    
    AlixPayOrder *order = [[AlixPayOrder alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    
    order.tradeNO = _orderDetail.orderId; //订单ID（由商家自行制定）
	order.productName = @"凌志商品"; //商品标题
	order.productDescription = @"好贵，好贵。。。。。。"; //商品描述
	order.amount = [NSString stringWithFormat:@"%.2f",0.01]; //商品价格
	order.notifyURL =  @"http%3A%2F%2Fwwww.xxx.com"; //回调URL
	
	return [order description];
}


-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}

-(void)paymentResultDelegate:(NSString *)result
{
    NSLog(@"%@",result);
}


@end
