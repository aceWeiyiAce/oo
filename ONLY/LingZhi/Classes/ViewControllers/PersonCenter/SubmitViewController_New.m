//
//  SubmitViewController.m
//  LingZhi
//
//  Created by pk on 3/26/14.
//
//

typedef enum{
    kUnkown = 0,
	ksheng,
	kcity,
    karea,
    kpostCompany
} ChoosePickerType;

#import "SubmitViewController_New.h"
#import "OrderContainsProducts.h"
#import "OrderProductCell.h"
#import "OrderShouldTotalPayCell.h"
//#import "OrderAddressView.h"
#import "ProductInfoModel.h"
#import "AddressModel.h"

#import "PostCompanyModel.h"
#import "UPPayPlugin.h"
#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"
#import "AlixLibService.h"
#import "AddressEditViewController.h"
#import "LoginCell.h"
#import "NSRegularExpression+Addition.h"
//#import "IQUIView+IQKeyboardToolbar.h"
#import "CityModel.h"
#import "MyOrderViewController.h"

#import "Base64.h"






@interface SubmitViewController_New ()<UITableViewDelegate,UITableViewDataSource,AddressEditViewControllerDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UPPayPluginDelegate>
{
    
    IBOutlet UITableView *_tableTop;
    IBOutlet UITableView *_tableAddress;
    IBOutlet UIView *_addressHeader;
    IBOutlet UIView *_addressFooter;
    
    
    IBOutlet UIView *_orderIntroduceView;
    IBOutlet UIView *_postAndPayView;
    
    
    IBOutlet UIImageView *_airPayRadio;
    IBOutlet UIImageView *_unionPayRadio;
    
    int selectBtnTag;
    NSString * savePayWayStr;
    
    IBOutlet UIPickerView *_postCompanyPickView;
    IBOutlet UITextField *_postCompanyTxt;
    __weak IBOutlet UIView *_pickSuperView;
    
    
    
    NSString * _recordPayWay;
    
    IBOutlet UIView *_savedAddressView;
    
    IBOutlet UILabel *_savedReceiveName;
    
    IBOutlet UILabel *_savedReceiveAddress;
    IBOutlet UILabel *_savedMobile;
    
    BOOL hasAddress;
    NSArray * _postArray;
    
    NSMutableArray * _rows;
    NSString          *_cityId;
    ChoosePickerType  _pickerType;
    NSMutableArray    *_cityArray;
    NSMutableArray    *_areaArray;
    NSMutableArray    *_placeArray;
    
    BOOL _addressHasWrong;
    CGFloat _tableAddressHeight;
    
    //记录点击的下拉按钮的 tag 值
    int pullBtnTag;
    
    //记录textField指向，用于点击按钮时,让键盘隐藏
    UITextField * _recordCurrentTextField;
    
    AddressModel * _recordAddressModel;
    NSString * _recordPostCompanyCode;
    
    //激活地区选项标志
    BOOL isEnableAreaChoose;
}

@end

@implementation SubmitViewController_New

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _rows = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0,@0,@0, nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.

    
    _postCompanyTxt.layer.borderColor = [UIColor grayColor].CGColor;
    _postCompanyTxt.layer.borderWidth = 1.0;
    
    _pickerType = 0;
    _cityArray  = [[NSMutableArray alloc] init];
    _areaArray  = [[NSMutableArray alloc] init];
    _placeArray = [[NSMutableArray alloc] init];
    
    [self requestToGetPostCompany];
    _postCompanyTxt.leftViewMode = UITextFieldViewModeAlways;
    _postCompanyTxt.leftView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    
    //默认的收货地址  DATA_ENV.address
    selectBtnTag = 10002;
    savePayWayStr = UnionPayCode;
    [self selectedPayRadioBtnBySelectTag:selectBtnTag];
    
    hasAddress = ([_orderDetail.receiver isEqualToString:@""] || !_orderDetail.receiver) ? NO : YES;
    if (!hasAddress) {
        AddressModel * model = DATA_ENV.address;
        hasAddress = model.addressId ? YES : NO ;
    }
    if (!hasAddress) {
        //显示新增地址的情况
        [self getCityRequest];
        
    }else{
        
        if ([_orderDetail.receiver isEqualToString:@""]|| !_orderDetail.receiver) {
            
            AddressModel * model = DATA_ENV.address;
            [self updateAddressShowWithAddress:model];
            
        }else{
            
            _savedReceiveName.text = _orderDetail.receiver;
            _savedReceiveAddress.numberOfLines = 0;
            _savedReceiveAddress.width = GET_VIEW_WIDTH(_savedReceiveAddress);
            _savedReceiveAddress.text = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",_orderDetail.provinceId,_orderDetail.cityId,_orderDetail.boroughId,_orderDetail.address,_orderDetail.postCode];
            [_savedReceiveAddress sizeToFit];
            
            _savedMobile.text = [NSString stringWithFormat:@"电话: +86%@",_orderDetail.contact];
        }
    }
    
    _tableTop.tableHeaderView = _orderIntroduceView;
    _tableTop.tableFooterView = _postAndPayView;
    
    //    [self registerForKeyboardNotifications];
    _addressHasWrong =NO;
    
    _recordAddressModel = [[AddressModel alloc] init];
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
    _savedReceiveAddress.text = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",adm.province,adm.city,adm.area,adm.address,adm.postalNum];
    [_savedReceiveAddress sizeToFit];
    _savedMobile.text = [NSString stringWithFormat:@"电话:%@",adm.phone];
    [self requestToSaveAddress:adm];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableView delegate Methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableTop) {
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
                //#warning 返回_tableAddress的contentSize的高度
                if (_addressHasWrong) {
                    return _tableAddressHeight;
                }
                return 390;
            }
        }
        else{
            return 44;
        }
        
    }
    
    if (tableView == _tableAddress) {
        NSNumber * num = _rows[indexPath.row];
        if ([num integerValue] == 1) {
            return loginCellWrongheight;
        }
        return loginCellNormalHeight;
    }
    return 44;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableTop) {
        
        return [_orderDetail.products count]+2;
        
    }else{
        
        return [_rows count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableAddress) {
        static NSString * identifier = @"LoginCell";
        LoginCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [LoginCell loadFromXib];
        }
        switch (indexPath.row) {
            case 0:
//                ,最长可输入10个中文,30个英文
                cell.txtField.placeholder = @"姓名";
                cell.txtField.keyboardType = UIKeyboardTypeDefault;
                break;

            case 1:
                cell.txtField.placeholder = @"省或市";
                
                cell.txtField.enabled = NO;
                cell.pullBtn.hidden = NO;
                cell.pullBtn.tag = 101;
                [cell.pullBtn addTarget:self action:@selector(showAddressPickView:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 2:
                cell.txtField.placeholder = @"城市";
                cell.txtField.enabled = NO;
                cell.pullBtn.hidden = NO;
                cell.pullBtn.tag = 102;
                [cell.pullBtn addTarget:self action:@selector(showAddressPickView:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 3:
                
                cell.txtField.placeholder = @"地区";
                cell.txtField.keyboardType = UIKeyboardTypeDefault;
//                cell.txtField.enabled = NO;
                cell.pullBtn.hidden = !isEnableAreaChoose;
                cell.pullBtn.tag = 103;
                [cell.pullBtn addTarget:self action:@selector(showAddressPickView:) forControlEvents:UIControlEventTouchUpInside];
                
                break;
            case 4:
                cell.txtField.placeholder = @"地址";
                cell.txtField.keyboardType = UIKeyboardTypeDefault;
                break;
            case 5:
                cell.txtField.placeholder = @"邮编";
                cell.txtField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                break;
            case 6:
                cell.txtField.placeholder = @"手机";
                cell.txtField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                break;
                
            default:
                break;
        }
        cell.txtField.delegate = self;
//        cell.txtField.keyboardType = UIKeyboardTypeDefault;
        cell.txtField.inputAccessoryView = [[UIView alloc] init];
        cell.remindLBl.hidden = [_rows[indexPath.row] intValue] == 1 ? NO : YES;
        
        return cell;
        
    }
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
        cell.height = cell.infoLbl.height;
        return cell;
        
    }
    if(indexPath.row == [_orderDetail.products count]){
        static NSString *identifier = @"OrderShouldTotalPayCell";
        OrderShouldTotalPayCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [OrderShouldTotalPayCell loadFromXib];
        }
        NSString * strText =[NSString stringWithFormat:@"%@  ￥%@", _orderDetail.totalCount, _orderDetail.totalPrice] ;
        cell.strContent = strText;
        
        return cell;
    }
    
    if (indexPath.row == [_orderDetail.products count]+1) {
        
        static NSString * identifier = @"customTableView";
        UITableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:identifier ];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (hasAddress) {
            [cell.contentView addSubview:_savedAddressView];
            [self.view bringSubviewToFront:_savedAddressView];
        }else{
            _tableAddress.tableHeaderView = _addressHeader;
            _tableAddress.tableFooterView = _addressFooter;
            [cell.contentView addSubview:_tableAddress];
        }
        return cell;
    }
    return nil;
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
    NSLog(@"model = %@",model);
    UITableViewCell * cell = [_tableTop.visibleCells lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    _savedReceiveName.text = model.name;
    NSString * address = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",model.province,model.city,model.area,model.address,model.postalNum];
    _savedReceiveAddress.width = 290;
    _savedReceiveAddress.numberOfLines = 0;
    _savedReceiveAddress.text = address;
    [_savedReceiveAddress sizeToFit];
    _savedMobile.text = [NSString stringWithFormat:@"电话: +86%@",model.phone];
    
    hasAddress = YES;
    [_tableTop reloadData];
}


#pragma mark - textFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //    for (int i =0; i<7; i++) {
    //        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
    //        LoginCell * cell = (LoginCell *)[_tableAddress cellForRowAtIndexPath:indexPath];
    //        switch (i) {
    //            case 0:
    //            {
    //                //姓名
    //                if (!(cell.txtField == textField)) {
    //                    break;
    //                }
    //
    //                if ([textField.text isEqualToString:@""]) {
    //                    [_rows removeObjectAtIndex:0];
    //                    [_rows insertObject:@1 atIndex:0];
    //                    cell.remindLBl.hidden = NO;
    //                    cell.remindLBl.text = @"姓名不能为空";
    //                    [_tableAddress beginUpdates];
    //                    [_tableAddress reloadData];
    //                    [_tableAddress endUpdates];
    //                }else{
    //                    [_rows removeObjectAtIndex:0];
    //                    [_rows insertObject:@0 atIndex:0];
    //                    cell.remindLBl.hidden = YES;
    //                    [_tableAddress beginUpdates];
    //                    [_tableAddress reloadData];
    //                    [_tableAddress endUpdates];
    //
    //                }
    //            }
    //                break;

    //            case 1:
    //            {
    //                //省市
    //                cell.pullBtn.hidden = NO;
    //                if (!(cell.txtField == textField)) {
    //                    break;
    //                }
    //                if ([textField.text isEqualToString:@""]) {
    //                    [_rows removeObjectAtIndex:1];
    //                    [_rows insertObject:@1 atIndex:1];
    //                    cell.remindLBl.hidden = NO;
    //                    cell.remindLBl.text = @"省或市不能为空";
    //                    [_tableAddress beginUpdates];
    //                    [_tableAddress reloadData];
    //                    [_tableAddress endUpdates];
    //                }else{
    //                    [_rows removeObjectAtIndex:1];
    //                    [_rows insertObject:@0 atIndex:1];
    //                    cell.remindLBl.hidden = YES;
    //                    [_tableAddress beginUpdates];
    //                    [_tableAddress reloadData];
    //                    [_tableAddress endUpdates];
    //
    //                }
    //
    //            }
    //                break;
    //            case 2:
    //            {
    //                //城市
    //                cell.pullBtn.hidden = NO;
    //                if (!(cell.txtField == textField)) {
    //                    break;
    //                }
    //                if ([textField.text isEqualToString:@""]) {
    //                    [_rows removeObjectAtIndex:2];
    //                    [_rows insertObject:@1 atIndex:2];
    //                    cell.remindLBl.hidden = NO;
    //                    cell.remindLBl.text = @"城市不能为空";
    //                    [_tableAddress beginUpdates];
    //                    [_tableAddress reloadData];
    //                    [_tableAddress endUpdates];
    //                }else{
    //                    [_rows removeObjectAtIndex:2];
    //                    [_rows insertObject:@0 atIndex:2];
    //                    cell.remindLBl.hidden = YES;
    //                    [_tableAddress beginUpdates];
    //                    [_tableAddress reloadData];
    //                    [_tableAddress endUpdates];
    //
    //                }
    //
    //            }
    //                break;
    //            case 3:
    //            {
    //                //地区
    //                if (!(cell.txtField == textField)) {
    //                    break;
    //                }
    //                if ([textField.text isEqualToString:@""]) {
    //                    [_rows removeObjectAtIndex:3];
    //                    [_rows insertObject:@1 atIndex:3];
    //                    cell.remindLBl.hidden = NO;
    //                    cell.remindLBl.text = @"地区不能为空";
    //                    [_tableAddress beginUpdates];
    //                    [_tableAddress reloadData];
    //                    [_tableAddress endUpdates];
    //                }else{
    //                    [_rows removeObjectAtIndex:3];
    //                    [_rows insertObject:@0 atIndex:3];
    //                    cell.remindLBl.hidden = YES;
    //                    [_tableAddress beginUpdates];
    //                    [_tableAddress reloadData];
    //                    [_tableAddress endUpdates];
    //
    //                }
    //
    //            }
    //                break;
    //            case 4:
    //            {
    //                //地址
    //
    //                if (!(cell.txtField == textField)) {
    //                    break;
    //                }
    //                if ([textField.text isEqualToString:@""]) {
    //                    [_rows removeObjectAtIndex:4];
    //                    [_rows insertObject:@1 atIndex:4];
    //                    cell.remindLBl.hidden = NO;
    //                    cell.remindLBl.text = @"地址不能为空";
    //                    [_tableAddress beginUpdates];
    //                    [_tableAddress reloadData];
    //                    [_tableAddress endUpdates];
    //                }else{
    //                    [_rows removeObjectAtIndex:4];
    //                    [_rows insertObject:@0 atIndex:4];
    //                    cell.remindLBl.hidden = YES;
    //                    [_tableAddress beginUpdates];
    //                    [_tableAddress reloadData];
    //                    [_tableAddress endUpdates];
    //
    //                }
    //            }
    //                break;
    //            case 5:
    //            {
    //                //邮编
    //                if (!(cell.txtField == textField)) {
    //                    break;
    //                }
    //                if (![NSRegularExpression validatePostcode:textField.text]) {
    //                    [_rows removeObjectAtIndex:5];
    //                    [_rows insertObject:@1 atIndex:5];
    //                    cell.remindLBl.hidden = NO;
    //                    cell.remindLBl.text = @"邮编不合法";
    //                    [_tableAddress beginUpdates];
    //                    [_tableAddress reloadData];
    //                    [_tableAddress endUpdates];
    //                }else{
    //                    [_rows removeObjectAtIndex:5];
    //                    [_rows insertObject:@0 atIndex:5];
    //                    cell.remindLBl.hidden = YES;
    //                    [_tableAddress beginUpdates];
    //                    [_tableAddress reloadData];
    //                    [_tableAddress endUpdates];
    //
    //                }
    //
    //            }
    //                break;
    //            case 6:
    //            {
    //                //手机
    //                if (!(cell.txtField == textField)) {
    //                    break;
    //                }
    //
    //                if (![NSRegularExpression validateMobile:textField.text]) {
    //                    [_rows removeObjectAtIndex:6];
    //                    [_rows insertObject:@1 atIndex:6];
    //                    cell.remindLBl.text = @"手机号不合法";
    //                    cell.remindLBl.hidden = NO;
    //                    [_tableAddress beginUpdates];
    //                    [_tableAddress reloadData];
    //                    [_tableAddress endUpdates];
    //                }else{
    //                    [_rows removeObjectAtIndex:6];
    //                    [_rows insertObject:@0 atIndex:6];
    //                    cell.remindLBl.hidden = YES;
    //                    [_tableAddress beginUpdates];
    //                    [_tableAddress reloadData];
    //                    [_tableAddress endUpdates];
    //                }
    //            }
    //                break;
    //            default:
    //                break;
    //        }
    //    }
    //
    //    NSArray * cellAddress = _tableAddress.visibleCells;
    //    __block CGFloat height;
    //    [cellAddress enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    //        LoginCell * cell = (LoginCell *)obj;
    //        height += cell.contentView.height;
    //    }];
    //    height += _tableAddress.tableHeaderView.height + _tableAddress.tableFooterView.height;
    //
    //    NSLog(@"height = %f",height);
    //
    ////    NSIndexPath * indexPath = [NSIndexPath indexPathForRow: [_orderDetail.products count]+1 inSection:0];
    ////    UITableViewCell * cell = [_tableTop cellForRowAtIndexPath:indexPath];
    ////    cell.height = height;
    ////    [cell.contentView setHeight:height];
    //    _addressHasWrong = YES;
    //    _tableAddressHeight = height;
    //    [_tableTop reloadData];
    
    
}



- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _recordCurrentTextField = textField;
    _pickSuperView.hidden = YES;
    
    NSLog(@"textField.origin.y = %f",textField.origin.y);
    NSLog(@"addressCell.origin.y = %f",[textField superview].origin.y);
    //    [_tableTop setContentOffset:CGPointMake(0, 0)];
    
    //获取文本框针对self.view的相对位置
    CGPoint  convertPoint = [textField convertPoint:textField.origin toView:self.view];
    NSLog(@"convertPoint = %@",NSStringFromCGPoint(convertPoint));
    
    //计算文本框的起始点和高度的和
    CGFloat startWithHeight = convertPoint.y + textField.size.height;
    
    //得到self.view - keyboardHeight 的高度
    CGFloat distanceKeyboard = self.view.height - 210;
    if (startWithHeight >= distanceKeyboard) {
        //        [UIView animateWithDuration:0.2f animations:^{
        //            if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        //                [_tableTop setContentOffset:CGPointMake(_tableTop.origin.x,  startWithHeight - distanceKeyboard)];
        //            }else{
        //                [_tableTop setContentOffset:CGPointMake(_tableTop.origin.x,  startWithHeight - distanceKeyboard + 20)];
        //            }
        //        }];
    }
    
    
    //计算
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    NSLog(@"field.tag = %d",textField.tag);
    //    [_tableTop setContentOffset:CGPointMake(0, 0)];
    return YES;
}

-(void)updateFieldContent:(UITextField *)sender
{
    UITextField * field = (UITextField *)sender.inputAccessoryView;
    field.text = sender.text;
    
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
    int rowCount = 0;
    switch (_pickerType) {
        case kUnkown:
        {
            return 0;
        }
            break;
        case ksheng:
        {
            rowCount =  _cityArray.count;
        }
            break;
        case kcity:
        {
            rowCount =  _areaArray.count;
        }
            break;
        case karea:
        {
            rowCount =  _placeArray.count;
        }
            break;
        case kpostCompany:
        {
            rowCount =  [_postArray count];
        }
        default:
            break;
    }
    
    pickerView.userInteractionEnabled = rowCount == 0 ? NO : YES;
    return rowCount;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (_pickerType) {
        case kUnkown:
        {
            return 0;
        }
            break;
        case ksheng:
        {
            CityModel *city = [_cityArray objectAtIndex:row];
            return city.cityName;
        }
            break;
        case kcity:
        {
            CityModel *city = [_areaArray objectAtIndex:row];
            return city.cityName;
        }
            break;
        case karea:
        {
            CityModel *city = [_placeArray objectAtIndex:row];
            return city.cityName;
        }
        case kpostCompany:
        {
            PostCompanyModel * model = _postArray[row];
            return model.carrierName;
        }
            break;
        default:
            break;
    }
    
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (_pickerType) {
        case kUnkown:
        {
            return;
        }
            break;
        case ksheng:
        {
            if (!_cityArray || _cityArray.count == 0) {
                return;
            }
            CityModel *city = [_cityArray objectAtIndex:row];
            _cityId = city.shengId;
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            LoginCell * cell = (LoginCell *)[_tableAddress cellForRowAtIndexPath:indexPath];
            cell.txtField.text = city.cityName;
            [self getAreaRequestWithString:_cityId];
            
            NSIndexPath * indexPathCity = [NSIndexPath indexPathForRow:2 inSection:0];
            LoginCell * cellCity = (LoginCell *)[_tableAddress cellForRowAtIndexPath:indexPathCity];
            cellCity.txtField.text = nil;
            
            NSIndexPath * indexPathArea = [NSIndexPath indexPathForRow:3 inSection:0];
            LoginCell * cellArea = (LoginCell *)[_tableAddress cellForRowAtIndexPath:indexPathArea];
            cellArea.txtField.text =nil;
            
            
            _recordAddressModel.province = city.cityName;
            _recordAddressModel.provinceId = city.shengId;
            
        }
            break;
        case kcity:
        {
            if (!_areaArray || _areaArray.count == 0) {
                return;
            }
            CityModel *city = [_areaArray objectAtIndex:row];
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            LoginCell * cell = (LoginCell *)[_tableAddress cellForRowAtIndexPath:indexPath];
            cell.txtField.text = city.cityName;
            _cityId = city.shengId;
            [self getAreaRequestWithString:_cityId];
            
            NSIndexPath * indexPathArea = [NSIndexPath indexPathForRow:3 inSection:0];
            LoginCell * cellArea = (LoginCell *)[_tableAddress cellForRowAtIndexPath:indexPathArea];
            cellArea.txtField.text =nil;
            
            _recordAddressModel.city = city.cityName;
            _recordAddressModel.cityId = city.shengId;
        }
            break;
        case karea:
        {
            if (!_placeArray || _placeArray.count == 0) {
                return;
            }
            CityModel *city = [_placeArray objectAtIndex:row];
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
            LoginCell * cell = (LoginCell *)[_tableAddress cellForRowAtIndexPath:indexPath];
            cell.txtField.text = city.cityName;
            
            _recordAddressModel.area = city.cityName;
            _recordAddressModel.areaId = city.shengId;
        }
            break;
        case kpostCompany:
        {
            PostCompanyModel * model = _postArray[row];
            _postCompanyTxt.text =  model.carrierName;
            _recordPostCompanyCode = model.carriderCode;
            
        }
            break;
        default:
            break;
            
    }
}


#pragma mark - Button Methods

/**
 *  返回上一级
 *
 *  @param sender
 */
- (IBAction)backToPreviewAction:(id)sender {
    if (_recordCurrentTextField) {
        [_recordCurrentTextField resignFirstResponder];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  保存收货地址
 *
 *  @param sender
 */
- (IBAction)addAddressAction:(id)sender {
    __block BOOL hasNull = NO;
    //    __block AddressModel * addModel = [[AddressModel alloc] init];
    
    for (int idx = 0; idx<7; idx++)  {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
        
        LoginCell * cell = (LoginCell *)[_tableAddress cellForRowAtIndexPath:indexPath];
        cell.txtField.text = [self ReplaceAllSpaceWithString:cell.txtField.text];
        if (!cell.txtField.text || [cell.txtField.text isEqualToString:@""]) {
            hasNull = YES;
            [_rows replaceObjectAtIndex:idx withObject:@1];
            cell.remindLBl.hidden = NO;
        }else{
            
            [_rows replaceObjectAtIndex:idx withObject:@0];
            cell.remindLBl.hidden = YES;
            cell.remindLBl.text = nil;
        }
        
        switch (idx) {
            case 0:
                _recordAddressModel.name = cell.txtField.text;
                if (!cell.txtField.text || [cell.txtField.text isEqualToString:@""]) {
                    cell.remindLBl.text = @"姓名不能为空";
                    [_rows replaceObjectAtIndex:idx withObject:@1];
                }else{
                    if ([cell.txtField.text lengthOfBytesUsingEncoding:NSUTF8StringEncoding]>30) {
                        hasNull = YES;
                        cell.remindLBl.text = @"姓名可容纳字符(中文10个、英文30个)";
                        [_rows replaceObjectAtIndex:idx withObject:@1];
                    }
                }
                break;
                
            case 1:
                _recordAddressModel.province = cell.txtField.text;
                if (!cell.txtField.text || [cell.txtField.text isEqualToString:@""]) {
                    cell.remindLBl.text = @"省或市不能为空";
                }
                
                break;
                
            case 2:
                _recordAddressModel.city = cell.txtField.text;
                if (!cell.txtField.text || [cell.txtField.text isEqualToString:@""]) {
                    cell.remindLBl.text = @"城市不能为空";
                }
                break;
                
            case 3:
                _recordAddressModel.area = cell.txtField.text;
                if (!cell.txtField.text || [cell.txtField.text isEqualToString:@""]) {
                    cell.remindLBl.text = @"地区不能为空";
                }
                
                break;
            case 4:
                
                _recordAddressModel.address = cell.txtField.text;
                if (!cell.txtField.text || [cell.txtField.text isEqualToString:@""]) {
                    cell.remindLBl.text = @"地址不能为空";
                }else{
                    if (cell.txtField.text.length > MaxLengthOfAddressInput) {
                        hasNull = YES;
                        [_rows removeObjectAtIndex:idx];
                        [_rows insertObject:@1 atIndex:idx];
                        cell.remindLBl.text = [NSString stringWithFormat:@"最多能输入%d个字符",MaxLengthOfAddressInput];
                        cell.remindLBl.hidden = NO;
                    }
                }
                break;

            case 5:
                _recordAddressModel.postalNum = cell.txtField.text;
                if (![NSRegularExpression validatePostcode:cell.txtField.text]) {
                    hasNull = YES;
                    cell.remindLBl.hidden = NO;
                    [_rows removeObjectAtIndex:5];
                    [_rows insertObject:@1 atIndex:5];
                    if (!cell.txtField.text || [cell.txtField.text isEqualToString:@""]) {
                        cell.remindLBl.text = @"邮编不能为空";
                        
                    }else{
                        cell.remindLBl.text = @"邮编格式错误";
                    }
                }else{
                    cell.remindLBl.hidden = YES;
                    [_rows removeObjectAtIndex:5];
                    [_rows insertObject:@0 atIndex:5];
                }
                
                break;
                
            case 6:
                _recordAddressModel.phone = cell.txtField.text;
                if (![NSRegularExpression validateMobile:cell.txtField.text]) {
                    hasNull = YES;
                    cell.remindLBl.hidden = NO;
                    [_rows removeObjectAtIndex:6];
                    [_rows insertObject:@1 atIndex:6];
                    if (cell.txtField.text == nil || [cell.txtField.text isEqualToString:@""]) {
                        cell.remindLBl.text = @"手机不能为空";
                    }else{
                        cell.remindLBl.text = @"手机不合法";
                    }
                    
                }else{
                    cell.remindLBl.hidden = YES;
                    [_rows removeObjectAtIndex:6];
                    [_rows insertObject:@0 atIndex:6];
                }
                
                break;
                
                
            default:
                break;
        }
        
    };
    
    if (hasNull) {
        _addressHasWrong = YES;
        _tableAddressHeight = 0;
        [_tableAddress beginUpdates];
        [_tableAddress reloadData];
        [_tableAddress endUpdates];
        for (int idx = 0; idx<7; idx++)  {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            LoginCell * cell = (LoginCell *)[_tableAddress cellForRowAtIndexPath:indexPath];
            _tableAddressHeight += cell.contentView.height;
            
        }
        
        _tableAddressHeight += _tableAddress.tableFooterView.height + _tableAddress.tableHeaderView.height;
        [_tableTop reloadData];
        return;
    }
    [self requestToSaveAddress:_recordAddressModel];
    //将信息赋值给收货信息视图中得对应字段
    
    //将视图从父视图中删除
    [_tableAddress removeFromSuperview];
    hasAddress = YES;
    
    //将收货信息添加到视图中
    //#warning 更新视图，显示添加的收货地址
    [self updateAddressViewWithAddress:_recordAddressModel];
}

-(NSString *)ReplaceAllSpaceWithString:(NSString *)str
{
    NSString *strValue = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    return strValue;
}


- (IBAction)hidePickView:(id)sender {
    _pickSuperView.hidden = YES;
    switch (_pickerType) {
            //省份
        case ksheng:
        {
            if ([_cityArray count] == 0 || !_cityArray) {
                break;
            }
            
            CityModel *city = _cityArray[[_postCompanyPickView selectedRowInComponent:0]];
            
            _recordAddressModel.province = city.cityName;
            _recordAddressModel.provinceId = city.shengId;
            
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            LoginCell * cell = (LoginCell *)[_tableAddress cellForRowAtIndexPath:indexPath];
            if (![cell.txtField.text isEqualToString:city.cityName]) {
                NSIndexPath * indexPathCity = [NSIndexPath indexPathForRow:2 inSection:0];
                LoginCell * cellCity = (LoginCell *)[_tableAddress cellForRowAtIndexPath:indexPathCity];
                
                NSIndexPath * indexPathArea = [NSIndexPath indexPathForRow:3 inSection:0];
                LoginCell * cellArea = (LoginCell *)[_tableAddress cellForRowAtIndexPath:indexPathArea];
                
                cellCity.txtField.text = nil;
                cellArea.txtField.text = nil;
            }
            
            cell.txtField.text = city.cityName;
            
            [self getAreaRequestWithString:city.shengId];
            
        }
            break;
            
            //城市
        case kcity:
        {
            if ([_areaArray count] == 0 || !_areaArray) {
                break;
            }
            CityModel *city = _areaArray[[_postCompanyPickView selectedRowInComponent:0]];
            
            _recordAddressModel.city = city.cityName;
            _recordAddressModel.cityId = city.shengId;
            
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            LoginCell * cell = (LoginCell *)[_tableAddress cellForRowAtIndexPath:indexPath];
            if (![cell.txtField.text isEqualToString:city.cityName]) {
                
                NSIndexPath * indexPathArea = [NSIndexPath indexPathForRow:3 inSection:0];
                LoginCell * cellArea = (LoginCell *)[_tableAddress cellForRowAtIndexPath:indexPathArea];
                
                cellArea.txtField.text = nil;
            }
            
            
            cell.txtField.text = city.cityName;
            [self getAreaRequestWithString:city.shengId];
            
        }
            break;
            //地区
        case karea:
        {
            if ([_placeArray count] == 0 || !_placeArray) {
                break;
            }
            CityModel *city = _placeArray[[_postCompanyPickView selectedRowInComponent:0]];
            
            _recordAddressModel.area = city.cityName;
            _recordAddressModel.areaId = city.shengId;
            
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
            LoginCell * cell = (LoginCell *)[_tableAddress cellForRowAtIndexPath:indexPath];
            cell.txtField.text = city.cityName;
            
        }
            break;
        case kpostCompany:
        {
            PostCompanyModel * model = _postArray[[_postCompanyPickView selectedRowInComponent:0]];
            _postCompanyTxt.text =  model.carrierName;
            _recordPostCompanyCode = model.carriderCode;
        }
            break;
            
        default:
            break;
    }
    [_tableAddress reloadData];
    
}



/**
 *  选择支付方式
 *
 *  @param sender
 */
- (IBAction)choosePayRadioAction:(id)sender {
    UIButton * btn =(UIButton *)sender;
    selectBtnTag = btn.tag;
    switch (btn.tag) {
        case 10001:
            //            savePayWayStr = @"支付宝";
            savePayWayStr = AliPayCode;
            _airPayRadio.image = [UIImage imageNamed:@"radioBtnChecked.png"];
            _unionPayRadio.image = [UIImage imageNamed:@"radioBtn.png"];
            break;
        case 10002:
            //            savePayWayStr = @"银行卡支付";
            savePayWayStr = UnionPayCode;
            _airPayRadio.image = [UIImage imageNamed:@"radioBtn.png"];
            _unionPayRadio.image = [UIImage imageNamed:@"radioBtnChecked.png"];
            break;
            
        default:
            break;
    }
    
    NSLog(@"savePayWay = %@",savePayWayStr);
}

-(void)selectedPayRadioBtnBySelectTag:(int)tag
{
    switch (tag) {
        case 10001:
            savePayWayStr = AliPayCode;
            _airPayRadio.image = [UIImage imageNamed:@"radioBtnChecked.png"];
            _unionPayRadio.image = [UIImage imageNamed:@"radioBtn.png"];
            break;
        case 10002:
            savePayWayStr = UnionPayCode;
            _airPayRadio.image = [UIImage imageNamed:@"radioBtn.png"];
            _unionPayRadio.image = [UIImage imageNamed:@"radioBtnChecked.png"];
            break;
            
        default:
            break;
    }
    
}

- (IBAction)gotoPayAction:(id)sender {
    NSLog(@"我要支付了");
    
    NSLog(@"hasAddress = %d",hasAddress);
    
    if (!hasAddress) {
        [UIAlertView promptTipViewWithTitle:nil message:@"您尚未填写收货地址信息" cancelBtnTitle:@"确定" otherButtonTitles:nil onDismiss:nil onCancel:^{
            
        }];
        return;
    }
    
    //保存快递公司和支付方式
    [self requestToUpdatePostCompanyAndPayWay];
    
    if (selectBtnTag == 10002) {
        [self RequestToGetUnionPayTradeNum];
        return;
    }else{
        //        [[ActivityRemindView loadFromXib] showActivityViewInView:self.view withMsg:@"暂不支持!" inSeconds:2.0];
        [self aliPayAction];
        return;
    }
    
}

/**
 *  给支付宝提供商品名称
 *
 *  @return
 */
-(NSString *)getProductNameForAlipay
{
    NSString * strName = nil;
    ProductInfoModel * p = _orderDetail.products[0];
    if (_orderDetail.products.count>1) {
        strName = [NSString stringWithFormat:@"%@等多件",p.info];
    }else{
        strName = [NSString stringWithFormat:@"%@",p.info];
    }
    return strName;
}

/**
 *  给支付宝提供文件的显示地址
 *
 *  @return
 */
-(NSString *)getPictureURLForAlipay
{
    ProductInfoModel * model = _orderDetail.products[0];
    return model.imageUrl;
}

-(void)gotoMyOrderController
{
    //update at 20140529 because of the order is not refresh currently
    [self requestUpdateOrderState];
}

-(void)aliPayAction
{
    AlixPayOrder *order = [[AlixPayOrder alloc] init];
	order.partner = PartnerID;
	order.seller = SellerID;
	order.tradeNO = _orderDetail.orderNumber; //订单ID（由商家自行制定）
//    order.tradeNO = [_orderDetail.orderNumber stringByAppendingString:@"|PAY_ZFB"];
    
	order.productName = @"绫致时装"; //商品标题
	order.productDescription = [self getProductNameForAlipay]; //商品描述
	order.amount = [NSString stringWithFormat:@"%.2f",[_orderDetail.totalPrice doubleValue]]; //商品价格
	order.notifyURL = ALiPay_Notify_Url; //回调URL
    
    order.serviceName = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
//    order.showUrl = @"m.alipay.com";
    order.showUrl = [self getPictureURLForAlipay];
    
    //	//应用注册scheme,在AlixPayDemo-Info.plist定义URL types
	NSString *appScheme = APPURLSCHEME;
    //将商品信息拼接成字符串
	NSString *orderSpec = [order description];
	NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
	id<DataSigner> signer = CreateRSADataSigner(PartnerPrivKey);
	NSString *signedString = [signer signString:orderSpec];
    NSLog(@"signedString = %@",signedString);
    
    //	//将签名成功字符串格式化为订单字符串,请严格按照该格式
	NSString *orderString = nil;
	if (signedString != nil) {
		orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        NSLog(@"orderString = %@",orderString);
        
        [AlixLibService setFullScreen];
        [AlixLibService payOrder:orderString AndScheme:appScheme seletor:@selector(paymentResult:) target:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoMyOrderController) name:NOTIFICATION_ALIPAY_KEY object:nil];
    }
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
 *  @param sender
 */
- (IBAction)showOrHidePostCompanyPickView:(id)sender {
    _pickerType = kpostCompany;
    _pickSuperView.hidden = !_pickSuperView.hidden;
    [_postCompanyPickView reloadAllComponents];
    
}

-(void)showAddressPickView:(id)sender
{
    if (_recordCurrentTextField) {
        [_recordCurrentTextField resignFirstResponder];
    }
    
    UIButton * btn = (UIButton *)sender;
    int tag = btn.tag;
    pullBtnTag = tag;
    switch (tag) {
        case 101:
            _pickerType = ksheng;
            [_postCompanyPickView reloadAllComponents];
            break;
        case 102:
        {
            
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            BOOL isWrong = [self updateRowAtIndexPathOfAddressTableView:indexPath andRemindMsg:@"省或市不能为空"];
            if (isWrong) {
                return;
            }
            _pickerType = kcity;
            [_postCompanyPickView reloadAllComponents];
            
        }
            break;
        case 103:
        {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            BOOL isWrong = [self updateRowAtIndexPathOfAddressTableView:indexPath andRemindMsg:@"城市不能为空"];
            if (isWrong) {
                return;
            }
            _pickerType = karea;
            [_postCompanyPickView reloadAllComponents];
            break;
        }
        default:
            break;
    }
    
    _pickSuperView.hidden = !_pickSuperView.hidden;
    
}


/**
 *  根据制定 addressTable 中的indexPath 和类容来更新表视图
 *
 *  @param indexPath 制定的地址编辑项中的indexPath
 *  @param remindMsg 制定的要显示的内容
 *
 *  @return YES 表示为null NO 表示不为null
 */
- (BOOL)updateRowAtIndexPathOfAddressTableView:(NSIndexPath *)indexPath andRemindMsg:(NSString *)remindMsg
{
    
    BOOL hasNull = NO;
    
    NSIndexPath * indexPathOfCell = indexPath;
    
    LoginCell * cell = (LoginCell *)[_tableAddress cellForRowAtIndexPath:indexPathOfCell];
    if (!cell.txtField.text || [cell.txtField.text isEqualToString:@""]) {
        hasNull = YES;
        [_rows removeObjectAtIndex:indexPath.row];
        [_rows insertObject:@1 atIndex:indexPath.row];
        cell.remindLBl.hidden = NO;
        cell.remindLBl.text = remindMsg;
    }else{
        
        [_rows removeObjectAtIndex:indexPath.row];
        [_rows insertObject:@0 atIndex:indexPath.row];
        cell.remindLBl.hidden = YES;
        cell.remindLBl.text = nil;
    }
    
    //    if (hasNull) {
    _addressHasWrong = YES;
    _tableAddressHeight = 0;
    [_tableAddress beginUpdates];
    [_tableAddress reloadData];
    [_tableAddress endUpdates];
    for (int idx = 0; idx<7; idx++)  {
        NSIndexPath * indexPathOfAddress = [NSIndexPath indexPathForRow:idx inSection:0];
        LoginCell * cell = (LoginCell *)[_tableAddress cellForRowAtIndexPath:indexPathOfAddress];
        _tableAddressHeight += cell.contentView.height;
        
    }
    _tableAddressHeight += _tableAddress.tableFooterView.height + _tableAddress.tableHeaderView.height;
    [_tableTop reloadData];
    //        return hasNull;
    //    }
    return hasNull;
}

#pragma mark 管理地址的代理方法 ，是否选择了一个地址
- (void)didChooseAddress:(AddressModel *)model
{
    NSLog(@"%@",model);
    [_tableAddress removeFromSuperview];
    [self updateAddressViewWithAddress:model];
    [self requestToSaveAddress:model];
}



#pragma mark - Request Methods
-(void)requestToSaveAddress:(AddressModel *)address
{
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:DATA_ENV.userInfo.userId forKey:@"userId"];
    [parameter setObject:self.orderDetail.orderId forKey:@"orderId"];
    [parameter setObject:address.name forKey:@"receiver"];
    [parameter setObject:address.address forKey:@"receiveAddress"];
    [parameter setObject:address.provinceId forKey:@"province"];
    [parameter setObject:address.cityId forKey:@"city"];
    if (address.areaId == nil || [address.areaId isEqualToString:@""]) {
        [parameter setObject:address.area forKey:@"borough"];
    }else{
        [parameter setObject:address.areaId forKey:@"borough"];
    }
    
//    [parameter setObject:address.areaId forKey:@"borough"];
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
                                           NSString * strMsg = request.handleredResult[@"messg"];
                                           strMsg = ([strMsg isEqualToString:@""]||!strMsg)?@"保存失败":strMsg;
                                           [UIAlertView promptTipViewWithTitle:Nil message:strMsg cancelBtnTitle:@"确定" otherButtonTitles:Nil onDismiss:^(int buttonIndex) {
                                               
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
                                         if (!_postCompanyTxt.text || [_postCompanyTxt.text isEqualToString:@""]) {
                                             PostCompanyModel * model = [_postArray firstObject];
                                             _postCompanyTxt.text = model.carrierName;
                                             _recordPostCompanyCode = model.carriderCode;
                                         }
                                     }
                                     
                                 } onRequestCanceled:nil
                                   onRequestFailed:^(ITTBaseDataRequest *request) {

                                   }];
    
    
}


- (void)getCityRequest
{
    [GetCityListRequest requestWithParameters:nil
                            withIndicatorView:self.view
                            withCancelSubject:@"GetCityListRequest"
                               onRequestStart:nil
                            onRequestFinished:^(ITTBaseDataRequest *request) {
                                if ([request isSuccess]) {
                                    _pickerType = ksheng;
                                    [_cityArray removeAllObjects];
                                    [_cityArray addObjectsFromArray:request.handleredResult[@"keyModel"]];
                                    NSLog(@"_cityArray = %@",_cityArray);
                                }
                            }
                            onRequestCanceled:nil
                              onRequestFailed:^(ITTBaseDataRequest *request) {
                                  
                              }];
}

- (void)getAreaRequestWithString:(NSString *)str
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:str forKey:@"areaId"];
    
    [GetAreaListRequest requestWithParameters:parameter
                            withIndicatorView:self.view
                            withCancelSubject:@"GetAreaListRequest"
                               onRequestStart:nil
                            onRequestFinished:^(ITTBaseDataRequest *request) {
                                if ([request isSuccess]) {
                                    if (_pickerType == ksheng) {
                                        [_areaArray removeAllObjects];
                                        [_areaArray addObjectsFromArray:request.handleredResult[@"keyModel"]];
                                        _pickerType = kcity;
                                        [_postCompanyPickView reloadAllComponents];
                                    }else if (_pickerType == kcity){
                                        [_placeArray removeAllObjects];
                                        [_placeArray addObjectsFromArray:request.handleredResult[@"keyModel"]];
                                        if (_placeArray.count>0) {
                                            isEnableAreaChoose = YES;
                                            [_tableAddress reloadData];

                                            _pickerType = karea;
                                            [_postCompanyPickView reloadAllComponents];
                                        }else{
                                            isEnableAreaChoose = NO;
                                            [_tableAddress reloadData];
                                        }
                                        
                                    }
                                    
                                }
                            }
                            onRequestCanceled:nil
                              onRequestFailed:^(ITTBaseDataRequest *request) {

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
    //    [parameter setObject:_postCompanyTxt.text forKey:@"expressCompany"];
    [parameter setObject:_recordPostCompanyCode forKey:@"expressCompany"];
    [parameter setObject:savePayWayStr forKey:@"payCompany"];
    
    [RequestToUpdatePostAndPayCompany requestWithParameters:parameter
                                          withIndicatorView:nil
                                          withCancelSubject:@"RequestToUpdatePostAndPayCompany"
                                             onRequestStart:nil
                                          onRequestFinished:^(ITTBaseDataRequest *request) {
                                              if ([request isSuccess]) {
                                                  
                                              }
                                              
                                          } onRequestCanceled:nil
                                            onRequestFailed:^(ITTBaseDataRequest *request) {
                                            }];
    
}


/**
 *  支付成功以后调用此接口改变订单状态
 */
-(void)requestUpdateOrderState
{
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    
    [parameter setObject:_orderDetail.orderId forKey:@"orderId"];
    [parameter setObject:DATA_ENV.userInfo.userId forKey:@"userId"];
    [parameter setObject:[NSNumber numberWithInt:oWaitPost] forKey:@"orderStateId"];
    
    __weak SubmitViewController_New * conVc = self;
    [RequestToUpdateOrderState requestWithParameters:parameter
                                   withIndicatorView:nil
                                   withCancelSubject:@"RequestToUpdateOrderState"
                                      onRequestStart:nil
                                   onRequestFinished:^(ITTBaseDataRequest *request) {
                                       if ([request isSuccess]) {
                                           [UIView animateWithDuration:0.3 animations:^{
                                               MyOrderViewController * orderListVc =[[MyOrderViewController alloc] init];
                                               [conVc.navigationController pushViewController:orderListVc animated:NO];
                                           }];
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
                                        [UPPayPlugin startPay:tradeNo mode:@"00" viewController:self delegate:self];
                                        
                                    }
                                    
                                } onRequestCanceled:nil
                                  onRequestFailed:^(ITTBaseDataRequest *request) {
                                      
                                  }];
    
    
}

#pragma mark - 加密字符串
/**
 *  加密字符串
 *
 *  @param str
 *  @param times
 *
 *  @return
 */
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
        [UIView animateWithDuration:0.3 animations:^{
            MyOrderViewController * orderListVc =[[MyOrderViewController alloc] init];
            [self.navigationController pushViewController:orderListVc animated:NO];
        }];
        
    }else{
        //交易失败
        NSLog(@"result =%@",result);
        [[ActivityRemindView loadFromXib] showActivityViewInView:self.view withMsg:@"用户中途取消" inSeconds:1.0];
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
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ALIPAY_KEY object:nil];

			}
        }
        else
        {
            //交易失败
            [[ActivityRemindView loadFromXib] showActivityViewInView:self.view withMsg:result.statusMessage inSeconds:1.0];
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
	order.notifyURL = nil; //回调URL
	
	return [order description];
}


-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}




@end
