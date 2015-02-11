//
//  AddressViewController.m
//  LingZhi
//
//  Created by boguoc on 14-2-27.
//
//

#import "AddressViewController.h"
#import "AddressCell.h"
#import "AddressModel.h"
#import "EditAddressViewController.h"
#import "ActivityRemindView.h"

#import "AddAddressViewController.h"

@interface AddressViewController ()<UITableViewDataSource,UITableViewDelegate,AddressCellDelegate,EditAddressViewControllerDelegate>
{
    __weak IBOutlet UIView          *_contentView;
    __weak IBOutlet UIView          *_newView;
    __weak IBOutlet UIView          *_listView;
    __weak IBOutlet UITableView     *_tableView;
    __weak IBOutlet UIView          *_bottomBarView;
    __weak IBOutlet UIView          *_404View;
    
    __weak IBOutlet UIButton        *_cancelButton;
    __weak IBOutlet UIButton        *_finishButton;
    
    NSMutableArray                  *_addressArray;
    NSMutableArray                  *_updataArray;
    NSString                        *_deleteStr;
    
    BOOL                            _isEdit;
    BOOL                            _hasSaved;
}
@end

@implementation AddressViewController

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
    _isEdit = YES;
    _hasSaved = NO;
    
    if (!_addressArray) {
        _addressArray = [[NSMutableArray alloc]initWithArray:_addresses];
        _updataArray = [[NSMutableArray alloc]init];
        if (_addressArray.count > 0) {
            [_tableView reloadData];
            return;
        }
    }
    if (_isAddAddress) {
        [self performSelector:@selector(onAddButton:) withObject:nil afterDelay:0];
        return;
    }

    [self getAddressListRequest];
}

- (void)getAddressListRequest
{

    NSDictionary *paramter = [NSDictionary dictionaryWithObjectsAndKeys:DATA_ENV.userInfo.userId,@"loginName", nil];
    [getAddressListRequest requestWithParameters:paramter
                               withIndicatorView:self.view
                               withCancelSubject:@"getAddressListRequest"
                                  onRequestStart:nil
                               onRequestFinished:^(ITTBaseDataRequest *request) {
                                   if ([request isSuccess]) {
                                       [_addressArray removeAllObjects];
                                       [_addressArray addObjectsFromArray:request.handleredResult[@"keyModel"]];
                                       [self dataCacheDefaultAddress];
                                   }
                                   [self addressListRequestError];
                               }
                               onRequestCanceled:nil
                                 onRequestFailed:^(ITTBaseDataRequest *request) {
                                     [self addressListRequestError];
                                     _404View.hidden = NO;
                                 }];
}

- (void)addressListRequestError
{
    if (_addressArray.count<1) {
        _listView.hidden = YES;
        _newView.hidden = NO;
        _bottomBarView.hidden = YES;
        _finishButton.hidden = YES;
    } else {
        _finishButton.hidden = NO;
        _listView.hidden = NO;
        _newView.hidden = YES;
        _bottomBarView.hidden = NO;
        [_tableView reloadData];
    }
    
}

#pragma mark - Button Methods

- (IBAction)onCancelButton:(id)sender
{
    for (AddressModel *model in _addressArray) {
        model.isSelect = @"0";
    }
    if (_productController) {
        [self.navigationController popToViewController:_productController animated:YES];
    } else if (_isAddressEdit) {
        if (_hasSaved) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didBackAddressEditReturnAddress:)]) {
                [self.delegate didBackAddressEditReturnAddress:_addressArray];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)onFinishButton:(id)sender
{
    if (_updataArray.count > 0) {
        [self addJsonStrWithArray:_updataArray];
    } else {
        if (_isAddressEdit) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
//            ActivityRemindView *activity = [ActivityRemindView loadFromXib];
//            [activity showActivityViewInView:self.view withMsg:@"无效操作" inSeconds:2];
            _hasSaved =  YES;
        }
        
    }
}

- (IBAction)onSettingButton:(id)sender
{
    if (_addressArray.count < 1) {
        return;
    }
    
    //判断是否选中cell
    for (int i = 0; i < _addressArray.count; i++) {
        AddressModel *model = _addressArray[i];
        if ([model.isSelect isEqualToString:@"1"]) {
            _deleteStr = [NSString stringWithFormat:@"%d",i];
        }
    }
    //如果选中cell则提示删除，否则提示选择地址
    if (_deleteStr) {

        for (AddressModel *model in _addressArray) {
            model.isDefault = @"0";
            model.type = @"0";
        }
        
        AddressModel *model = [_addressArray objectAtIndex:[_deleteStr integerValue]];
        if (![model.operation isEqualToString:@"save"]) {
            model.operation = @"update";
        }
        model.isDefault = @"1";
        model.type = @"1";
        [_updataArray addObject:model];
        [_tableView reloadData];
        
    } else {
        [UIAlertView promptTipViewWithTitle:nil message:@"请选择要设置地址" cancelBtnTitle:@"确认" otherButtonTitles:nil onDismiss:^(int buttonIndex) {} onCancel:^{}];
    }
}

- (IBAction)onAddButton:(id)sender
{
//    [self showDefautPage];
    AddressModel *model = [[AddressModel alloc]init];
    model.operation = @"save";//修改
    model.isAdd = @"1";
    model.type = @"0";
    NSDate *date = [NSDate date];
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    model.addressId = [NSString stringWithFormat:@"%.0f",timeInterval];
    model.fixIndex = [NSString stringWithFormat:@"%d",_addressArray.count];
    NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
    
    EditAddressViewController *edit = [[EditAddressViewController alloc]init];
    edit.addressArr = [NSMutableArray arrayWithArray:array];
    edit.addressModel = model;
    edit.delegate = self;
    NSLog(@"1111111111111");
    //update at 20140609 by pk because of the _addressClass is nil
//    if (_isAddressEdit) {
//        edit.isAddressEdit = YES;
//        edit.addressClass = _addressClass;
//    }
//    AddAddressViewController *add = [[AddAddressViewController alloc] init];
    [self.navigationController pushViewController:edit animated:YES];
}

- (IBAction)onDeleteButton:(id)sender
{
    if (_addressArray.count < 1) {
        return;
    }
    
    //判断是否选中cell    _deleteStr得到了选中了哪个cell
    for (int i = 0; i < _addressArray.count; i++) {
        AddressModel *model = _addressArray[i];
        if ([model.isSelect isEqualToString:@"1"]) {
            _deleteStr = [NSString stringWithFormat:@"%d",i];
        }
    }
    //如果选中cell则提示删除，否则提示选择地址
    if (_deleteStr) {
        [UIAlertView promptTipViewWithTitle:nil message:@"是否删除选中地址" cancelBtnTitle:@"取消" otherButtonTitles:@[@"删除"] onDismiss:^(int buttonIndex) {
            AddressModel *model = [_addressArray objectAtIndex:[_deleteStr integerValue]];
            model.operation = @"delete";
            if (_updataArray.count>0) {
                //非常正确地错误示范，枚举中改变被枚举对象
//                for (AddressModel *update in _updataArray) {
//                    if (model.addressId == update.addressId) {
//                        [_updataArray removeObject:update];
//                    } else {
//                        [_updataArray addObject:model];
//                    }
//                }
                
                int temp = _updataArray.count;
                for (int i = 0; i<temp; i++) {
                    AddressModel *updata = _updataArray[i];
                    if (model.addressId == updata.addressId) {
                        if ([updata.isDefault isEqualToString:@"1"]) {
                            updata.operation = @"delete";
                        } else {
                            [_updataArray removeObject:updata];
                        }

                    } else {
                        [_updataArray addObject:model];
                    }
                }
            } else {
                [_updataArray addObject:model];

            }

            //cell删除动画
            [_addressArray removeObjectAtIndex:[_deleteStr integerValue]];
            [_tableView beginUpdates];
            [_tableView deleteRowsAtIndexPaths:@[([NSIndexPath indexPathForRow:[_deleteStr integerValue] inSection:0])] withRowAnimation:UITableViewRowAnimationMiddle];
            [_tableView endUpdates];
            _deleteStr = nil;
        } onCancel:^{
            return ;
        }];
    } else {
        [UIAlertView promptTipViewWithTitle:nil message:@"请选择要删除地址" cancelBtnTitle:@"确认" otherButtonTitles:nil onDismiss:^(int buttonIndex) {} onCancel:^{}];
    }
    
    
    
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _addressArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"AddressCell";
    
    AddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!addressCell) {
        addressCell = [AddressCell loadFromXib];
        addressCell.delegate = self;
    }
    addressCell.index = indexPath.row;
    addressCell.isEdit = _isEdit;
    [addressCell layoutAddressCellWithModel:[_addressArray objectAtIndex:indexPath.row]];
    
    return addressCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //记录欲删除cell
    //    _deleteStr = [NSString stringWithFormat:@"%d",indexPath.row];
    //给cell加入选中状态
//    if (_isEdit) {
        for (AddressModel *model in _addressArray) {
            model.isSelect = @"0";
        }
        AddressModel *address = [_addressArray objectAtIndex:indexPath.row];
        address.isSelect = @"1";
        [_tableView reloadData];
//    }
    
}

#pragma mark - AddressCellDelegate

-(void)didOnEditButtonAtIndex:(NSInteger)index
{
    AddressModel *model = [_addressArray objectAtIndex:index];
    model.operation = @"update";//修改
    model.fixIndex = [NSString stringWithFormat:@"%d",index];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [array addObject:model.name];
    [array addObject:model.address];
    [array addObject:model.province];
    [array addObject:model.city];
    [array addObject:model.area];
    [array addObject:model.postalNum];
    [array addObject:model.phone];
    [array addObject:model.provinceId];
    [array addObject:model.cityId];
    if (model.areaId.length > 0) {
        [array addObject:model.areaId];
    } else {
        [array addObject:@""];
    }
    
    EditAddressViewController *edit = [[EditAddressViewController alloc]init];
    edit.addressArr = array;
    edit.addressModel = model;
    edit.isAddressEdit = YES;
    edit.delegate = self;
    edit.addressClass = self;
    [self.navigationController pushViewController:edit animated:YES];
}

#pragma mark - EditAddressViewControllerDelegate

-(void)didFinishEditAddressModel:(AddressModel *)model areaId:(NSString *)areaId
{
//    model.areaId = areaId;
    if ([model.operation isEqualToString:@"update"]) {
        for (AddressModel *address in _addressArray) {
            if (address.addressId.length == 10) {
                address.operation = @"save";
            }
        }
        [_addressArray removeObjectAtIndex:[model.fixIndex integerValue]];
        [_addressArray insertObject:model atIndex:[model.fixIndex integerValue]];
        [_updataArray addObject:model];
    } else {
        [_addressArray insertObject:model atIndex:0];
        [_updataArray addObject:model];
    }
    //    [_addressArray replaceObjectAtIndex:[model.fixIndex integerValue] withObject:model];
    //    [_updataArray addObject:[_addressArray objectAtIndex:[model.fixIndex integerValue]]];
    [self addressListRequestError];
    [_tableView reloadData];
}

- (void)addJsonStrWithArray:(NSArray *)array
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < array.count; i++) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        AddressModel *mode = [array objectAtIndex:i];
        [dic setObject:DATA_ENV.userInfo.userId forKey:@"loginName"];
        [dic setObject:mode.name forKey:@"receiver"];
        [dic setObject:mode.address forKey:@"address"];
        [dic setObject:mode.type forKey:@"state"];
        [dic setObject:mode.provinceId forKey:@"province"];
        [dic setObject:mode.cityId forKey:@"city"];
        [dic setObject:mode.postalNum forKey:@"postCode"];
        [dic setObject:mode.phone forKey:@"mobile"];
        if (mode.areaId.length > 0) {
            [dic setObject:mode.areaId forKey:@"area"];
        } else {
            [dic setObject:mode.area forKey:@"area"];
        }
        [dic setObject:mode.operation forKey:@"operation"];
        if ([mode.isAdd isEqualToString:@"1"]) {
            [dic setObject:mode.addressId forKey:@"tempId"];
        } else {
            [dic setValue:mode.addressId forKey:@"addressId"];
        }
        [data setObject:dic forKey:[NSString stringWithFormat:@"%@",mode.addressId]];
    }
    NSString *jsonStr;
    for (int i = 0; i < array.count; i++) {
        jsonStr = [NSJSONSerialization jsonStringFromDictionary:data];
    }
    NSLog(@"%@",jsonStr);
    [self updataAddressRequestWithString:jsonStr];
}

- (void)updataAddressRequestWithString:(NSString *)str
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:str forKey:@"json"];
    
    [UpdataAddressRequest requestWithParameters:parameter
                              withIndicatorView:self.view
                              withCancelSubject:@"UpdataAddressRequest"
                                 onRequestStart:nil
                              onRequestFinished:^(ITTBaseDataRequest *request) {
                                  if ([request isSuccess]) {
                                      if (_isAddressEdit) { //地址选取页面，跳回
                                          ActivityRemindView *activity = [ActivityRemindView loadFromXib];
                                          [activity showActivityViewInView:self.view withMsg:@"保存成功" inSeconds:2];
                                          if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishAddressEditReturnAddress:)]) {
                                              [self.delegate didFinishAddressEditReturnAddress:_addressArray];
                                              [self.navigationController popViewControllerAnimated:YES];
                                          }
                                      } else {
                                          [self getAddressListRequest];
                                          ActivityRemindView *activity = [ActivityRemindView loadFromXib];
                                          [activity showActivityViewInView:self.view withMsg:@"保存成功" inSeconds:2];
                                      }
                                      [self dataCacheDefaultAddress];
                                      [self deleteCacheDefaultAddress];
                                      [_updataArray removeAllObjects];
                                      [self addressListRequestError];

                                  }
                              }
                              onRequestCanceled:nil
                                onRequestFailed:^(ITTBaseDataRequest *request) {
                                    
                                }];
}

- (void)dataCacheDefaultAddress
{
    for (AddressModel *model in _addressArray) {
        if ([model.isDefault isEqualToString:@"1"]) {
            AddressModel *address = DATA_ENV.address;
            address = model;
            DATA_ENV.address = address;
        }
    }
}

- (void)deleteCacheDefaultAddress
{
    int temp = 0;
    for (AddressModel *model in _addressArray) {
        if ([model.isDefault isEqualToString:@"1"]) {
            temp++;
        }
    }
    if (0 == temp && DATA_ENV.address.addressId.length > 0) {
        AddressModel *address = DATA_ENV.address;
        address.addressId = nil;
        DATA_ENV.address = address;
    }
}

- (void)hideNewView
{
    
}
@end







