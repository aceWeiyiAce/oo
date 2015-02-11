//
//  EditAddressViewController.m
//  LingZhi
//
//  Created by boguoc on 14-3-11.
//
//
typedef enum{
    kUnkown = 0,
	ksheng,
	kcity,
    karea
} ChoosePickerType;

typedef void (^methodFinish)(BOOL finish);

#import "EditAddressViewController.h"
#import "EditAddressCell.h"
#import "EditAddressModel.h"
#import "CityModel.h"
#import "NSRegularExpression+Addition.h"
#import "AddressEditViewController.h"

@interface EditAddressViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,EditAddressCellDelegate>
{
    __weak IBOutlet UILabel         *_navBarTitleLabel;
    __weak IBOutlet UITableView     *_tableView;
    __weak IBOutlet UIPickerView    *_pickerView;
    __weak IBOutlet UIView          *_pickerSuperView;
    __weak IBOutlet UIView          *_tableSuperView;

    NSMutableArray                  *_editArray;
    NSMutableArray                  *_editErrorArr;
    NSMutableArray                  *_cityArray;
    NSMutableArray                  *_areaArray;
    NSMutableArray                  *_placeArray;
    NSMutableArray                  *_addressArray;
    NSMutableArray                  *_cellHeightArray;
    
    BOOL                            _isCityPicker;
    BOOL                            _isSave;
    NSString                        *_cityId;
    NSString                        *_placeId;
    ChoosePickerType                _pickerType;
    float                           _tableViewHeight;
    
    int                             _areaId;
    int                             _pickNum;
}
@end

@implementation EditAddressViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    if (_addressArr.count>0) {
        _addressArray = [[NSMutableArray alloc]initWithArray:_addressArr];
    }
    _pickerType = 0;
    _cityId = [_addressArr objectAtIndex:7];
    _placeId = [_addressArray objectAtIndex:8];
    
    _isCityPicker = NO;
    _isSave = NO;
    // Do any additional setup after loading the view from its nib.
    if (!_editArray) {
        _editArray = [[NSMutableArray alloc]init];
        _editErrorArr = [[NSMutableArray alloc]init];
        _cityArray = [[NSMutableArray alloc]init];
        _areaArray = [[NSMutableArray alloc]init];
        _placeArray = [[NSMutableArray alloc]init];
        _cellHeightArray = [[NSMutableArray alloc]init];
        [self getCityRequest];
        
        [_editArray addObjectsFromArray:[EditAddressModel createAddressModelsWithArray:_addressArr]];
        [_tableView reloadData];
    }
    if (_isAddressEdit) {
        _navBarTitleLabel.text = @"修改地址";
    }
//    NSLog(@"%@",_addressModel);
}

#pragma mark - Request Methods
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
                                    if (_cityId.length>0) {
                                        [self getAreaRequestWithString:_cityId];
                                    }
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
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [GetAreaListRequest requestWithParameters:parameter
                            withIndicatorView:window
                            withCancelSubject:@"GetAreaListRequest"
                               onRequestStart:nil
                            onRequestFinished:^(ITTBaseDataRequest *request) {
                                if ([request isSuccess]) {
                                    if (_pickerType == ksheng) {
                                        [_areaArray removeAllObjects];
                                        [_areaArray addObjectsFromArray:request.handleredResult[@"keyModel"]];
                                        _pickerType = kcity;
                                        [_pickerView reloadAllComponents];
                                    }else if (_pickerType == kcity){
                                        [_placeArray removeAllObjects];
                                        [_placeArray addObjectsFromArray:request.handleredResult[@"keyModel"]];
//                                        NSLog(@"%@",_placeArray);
                                        EditAddressModel *model = [_editArray objectAtIndex:4];
                                        if (_placeArray.count>0) {
                                            model.isPicker = @"1";
                                            _pickerType = karea;
                                            [_cellHeightArray removeAllObjects];
                                            [_tableView reloadData];
                                            [_pickerView reloadAllComponents];
                                            [self showPickerView];
                                        } else {
                                            [self hidenPickerView];
                                            model.isPicker = @"0";
                                            [_cellHeightArray removeAllObjects];
                                            [_tableView reloadData];
                                        }
                                    }
                                    
                                }
                            }
                            onRequestCanceled:nil
                              onRequestFailed:^(ITTBaseDataRequest *request) {
                                  
                              }];
}

#pragma mark - Button methods

- (IBAction)onSaveButton:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addressTextField" object:nil];

    [self checkErrorInfoFinish:^(BOOL finish) {
        if (finish) {
            [self checkAddressInfo];
        }
    }];

}

- (IBAction)onBackButton:(id)sender
{
    if (_isAddressEdit) {
//        AddressEditViewController *addressEdit = [[AddressEditViewController alloc]init];
        [self.navigationController popToViewController:_addressClass animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (IBAction)onPickerCancelButton:(id)sender
{
    _pickNum = 0;
    [self hidenPickerView];
}
- (IBAction)onPickOkButton:(id)sender
{
    switch (_pickerType) {
        case kUnkown:
        {
            return;
        }
            break;
        case ksheng:
        {
            if (_pickNum > _cityArray.count -1) {
                _pickNum = 0;
            }
            [self changeAddressPickWithIndex:_pickNum];
        }
            break;
        case kcity:
        {
            if (_pickNum > _areaArray.count -1) {
                _pickNum = 0;
            }
            CityModel *city = [_areaArray objectAtIndex:_pickNum];
            EditAddressModel *model = [_editArray objectAtIndex:3];
            model.content = city.cityName;
            [_addressArray replaceObjectAtIndex:8 withObject:city.shengId];
            //            NSLog(@"%@",_addressArray);
            _cityId = city.shengId;
            [self getAreaRequestWithString:_cityId];
            model = [_editArray objectAtIndex:4];
            model.content = @"";
            [_cellHeightArray removeAllObjects];
            [_tableView reloadData];
        }
            break;
        case karea:
        {
            if (_pickNum > _placeArray.count -1) {
                _pickNum = 0;
            }
            CityModel *city = [_placeArray objectAtIndex:_pickNum];
            EditAddressModel *model = [_editArray objectAtIndex:4];
            model.content = city.cityName;
            [_addressArray replaceObjectAtIndex:4 withObject:city.cityName];
            //update by pk at 20140610
            if (![city.shengId isEqualToString:@""]) {
                [_addressArray replaceObjectAtIndex:9 withObject:city.shengId];
            }
            //            model = [_editArray objectAtIndex:4];
            //            model.content = @"";
            [_cellHeightArray removeAllObjects];
            [_tableView reloadData];
            [self hidenPickerView];
        }
            break;
        default:
            break;
    }
    _pickNum = 0;
    
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditAddressModel *model = [_editArray objectAtIndex:indexPath.row];
    if ([model.isError isEqualToString:@"1"]) {
        NSNumber *number = [NSNumber numberWithFloat:70];
        [_cellHeightArray addObject:number];
        return 70;
    } else {
        NSNumber *number = [NSNumber numberWithFloat:30];
        [_cellHeightArray addObject:number];
        return 38;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _editArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditAddressModel *edit = [_editArray objectAtIndex:indexPath.row];
    static NSString *identifier = @"EditAddressCell";
    
    EditAddressCell *editCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!editCell) {
        editCell = [EditAddressCell loadFromXib];
        editCell.delegate = self;
        edit.indexPath = indexPath;
    }
    [editCell layoutEditAddressCellWithModel:edit];
    
    return editCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [_cellHeightArray removeAllObjects];
    [_tableView reloadData];

    if (_cityArray.count < 1 ) {
        return;
    }
    if (indexPath.row == 2) {
        _pickerType = ksheng;
        [_pickerView reloadAllComponents];
        [self showPickerView];
    } else if (indexPath.row == 3) {
        _pickerType = kcity;
        EditAddressModel *model = [_editArray objectAtIndex:2];
        if (!model.content.length>0) {
            [self hidenPickerView];
            return;
        } else{
            if (_areaArray.count<1) {
                _pickerType = ksheng;
                [self getAreaRequestWithString:_cityId];
            } else {
                [_pickerView reloadAllComponents];
            }
        }
        [self showPickerView];

    } else if (indexPath.row == 4) {
        if (_placeArray.count > 0) {
            [self showPickerView];
        } else {
            if (_cityId.length > 0) {
                _pickerType = kcity;
                [self getAreaRequestWithString:_placeId];
            }
        }
    } else {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"addressTextField" object:[NSString stringWithFormat:@"%d",indexPath.row]];
        return;
    }
}

#pragma mark - UIPickerViewDataSource && UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (_pickerType) {
        case kUnkown:
        {
            return 0;
        }
            break;
        case ksheng:
        {
            return _cityArray.count;
        }
            break;
        case kcity:
        {
            return _areaArray.count;
        }
            break;
        case karea:
        {
            return _placeArray.count;
        }
            break;
        default:
            break;
    }
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
            if (_cityArray.count == 0) {
                return nil;
            }
            CityModel *city = [_cityArray objectAtIndex:row];
            return city.cityName;
        }
            break;
        case kcity:
        {
            if (_areaArray.count == 0) {
                return nil;
            }
            CityModel *city = [_areaArray objectAtIndex:row];
            return city.cityName;
        }
            break;
        case karea:
        {
            if (_placeArray.count == 0) {
                return nil;
            }
            CityModel *city = [_placeArray objectAtIndex:row];
            return city.cityName;
        }
            break;
        default:
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _pickNum = row;
    return;
    switch (_pickerType) {
        case kUnkown:
        {
            return;
        }
            break;
        case ksheng:
        {
            [self changeAddressPickWithIndex:row];
        }
            break;
        case kcity:
        {
            CityModel *city = [_areaArray objectAtIndex:row];
            EditAddressModel *model = [_editArray objectAtIndex:3];
            model.content = city.cityName;
            [_addressArray replaceObjectAtIndex:8 withObject:city.shengId];
//            NSLog(@"%@",_addressArray);
            _cityId = city.shengId;
            [self getAreaRequestWithString:_cityId];
            model = [_editArray objectAtIndex:4];
            model.content = @"";
            [_cellHeightArray removeAllObjects];
            [_tableView reloadData];
        }
            break;
        case karea:
        {
            CityModel *city = [_placeArray objectAtIndex:row];
            EditAddressModel *model = [_editArray objectAtIndex:4];
            model.content = city.cityName;
            [_addressArray replaceObjectAtIndex:4 withObject:city.cityName];
//            model = [_editArray objectAtIndex:4];
//            model.content = @"";
            [_cellHeightArray removeAllObjects];
            [_tableView reloadData];
            [self hidenPickerView];
        }
            break;
        default:
            break;
    }
//    if (_isCityPicker) {
//        
//    } else{
//        CityModel *city = [_areaArray objectAtIndex:row];
//        EditAddressModel *model = [_editArray objectAtIndex:3];
//        model.content = city.cityName;
//        [_tableView reloadData];
//    }
    if (_isSave) {
        [self checkErrorInfoFinish:^(BOOL finish) {
            
        }];
        [_cellHeightArray removeAllObjects];
        [_tableView beginUpdates];
        [_tableView reloadRowsAtIndexPaths:_editErrorArr withRowAnimation:UITableViewRowAnimationNone];
        [_tableView endUpdates];
    }
}

- (void)changeAddressPickWithIndex:(int)index
{
    CityModel *city = [_cityArray objectAtIndex:index];
    EditAddressModel *model = [_editArray objectAtIndex:2];
    model.content = city.cityName;
    [_addressArray replaceObjectAtIndex:7 withObject:city.shengId];
    _cityId = city.shengId;
    [self getAreaRequestWithString:_cityId];

    model = [_editArray objectAtIndex:3];
    model.content = @"";
    model = [_editArray objectAtIndex:4];
    model.content = @"";
    [_cellHeightArray removeAllObjects];
    [_tableView reloadData];
}

- (void)showPickerView
{
    [UIView animateWithDuration:.4f
                     animations:^{
                         _pickerSuperView.bottom = self.view.bottom;
                     }];
}

- (void)hidenPickerView
{
    [UIView animateWithDuration:.3f
                     animations:^{
                         _pickerSuperView.top = self.view.bottom;
                     }];
}

#pragma mark - checkInfo

- (void)checkErrorInfoFinish:(methodFinish)finish
{
    [_editErrorArr removeAllObjects];
    for (EditAddressModel *model in _editArray) {
        model.isError = @"0";
    }
    for (int i = 0; i < 7; i++) {
        EditAddressModel *model = _editArray[i];
        
        if (i != 2 || i != 3) {
            [_addressArray replaceObjectAtIndex:i withObject:model.content];
        }
        if (i == 5) {
            if (![NSRegularExpression validatePostcode:model.content]) {
                model.isError = @"1";
                [_editErrorArr addObject:model.indexPath];
            }
        } else if (i == 6) {
            if (![NSRegularExpression validateMobile:model.content] || !model.content.length == 11) {
                model.isError = @"1";
                [_editErrorArr addObject:model.indexPath];
            }
        }
        else if (i == 1) {
            if (model.content.length > 35 || model.content.length == 0) {
                model.isError = @"1";
                [_editErrorArr addObject:model.indexPath];
            }
        }
        else {
            if (model.content.length<1 || [model.content lengthOfBytesUsingEncoding:NSUTF8StringEncoding]>30) {
                model.isError = @"1";
                [_editErrorArr addObject:model.indexPath];
            }
        }
    }
    finish(YES);
}

- (void)checkAddressInfo
{
    _isSave = YES;
//    [self checkErrorInfo];
    if (_editErrorArr.count > 0) {
        [_cellHeightArray removeAllObjects];
        [_tableView beginUpdates];
        [_tableView reloadRowsAtIndexPaths:_editErrorArr withRowAnimation:UITableViewRowAnimationNone];
        [_tableView endUpdates];
    } else {
        [_cellHeightArray removeAllObjects];
        [_tableView reloadData];
        [self resetAddressModelWithArray:_addressArray];
        [self.navigationController popViewControllerAnimated:YES];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishEditAddressModel:areaId:)]) {
            //update by pk at 20140610
//            CityModel *model = nil;
//            if (_placeArray.count > 0) {
//               model = [_placeArray objectAtIndex:_pickNum];
//            }
//            [self.delegate didFinishEditAddressModel:_addressModel areaId:model.shengId];
            [self.delegate didFinishEditAddressModel:_addressModel areaId:_addressArray[9]];

        }
    }
    
}

- (void)resetAddressModelWithArray:(NSArray *)array
{
    for (int i = 0; i<7; i++) {
        EditAddressModel *model = [_editArray objectAtIndex:i];
        if (0 == i) {
            _addressModel.name = _addressArray[i];
        } else if (1 == i) {
            _addressModel.address = _addressArray[i];
        } else if (2 == i) {
            _addressModel.provinceId = _addressArray[7];
            _addressModel.province = model.content;
        } else if (3 == i) {
            _addressModel.cityId = _addressArray[8];
            _addressModel.city = model.content;
        } else if (4 == i) {
            _addressModel.area = _addressArray[i];
            //update by pk at 20140610
//            CityModel *model = nil;
//            if (_placeArray.count > 0) {
//                model = [_placeArray objectAtIndex:_pickNum];
//                _addressModel.areaId = model.shengId;
//            }
            
            if (_placeArray.count > 0) {
                _addressModel.areaId =_addressArray[9];
            }else{
                _addressModel.areaId =@"";
                [_addressArray replaceObjectAtIndex:9 withObject:@""];
            }

        } else if (5 == i) {
            _addressModel.postalNum = _addressArray[i];
        } else if (6 == i) {
            _addressModel.phone = _addressArray[i];
        }
    }
}

#pragma mark - EditAddressCellDelegate

-(void)cellTextFieldBeingEditingAtIndexPath:(NSIndexPath *)index
{
//    if (_cellHeightArray.count<1) {
//        return;
//    }
    [self hidenPickerView];
    if (_tableSuperView.height == _tableView.height) {
        _tableView.height -= 240;
    }
}

-(void)cellTextFieldDidEndEditingAtIndexPath:(NSIndexPath *)index
{
    if (_isSave) {
        [self checkErrorInfoFinish:^(BOOL finish) {
        }];
        [_cellHeightArray removeAllObjects];
        [_tableView beginUpdates];
        [_tableView reloadRowsAtIndexPaths:_editErrorArr withRowAnimation:UITableViewRowAnimationNone];
        [_tableView endUpdates];
    } else {
        [_tableView beginUpdates];
        [_tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
        [_tableView endUpdates];
    }
}

-(void)cellTextFieldShouldReturnAtIndexPath:(NSIndexPath *)index
{
    if (_tableSuperView.height != _tableView.height) {
        _tableView.height += 240;
    }
    [_tableView reloadData];
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
    if (_tableSuperView.height != _tableView.height) {
        _tableView.height += 240;
    }
    [UIView animateWithDuration:.2f
                     animations:^{
                         _tableView.contentOffset = CGPointMake(0, 0);;
                     }];
}


@end
