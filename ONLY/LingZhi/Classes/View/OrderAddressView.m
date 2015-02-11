//
//  OrderAddressView.m
//  LingZhi
//
//  Created by pk on 3/28/14.
//
//

#import "OrderAddressView.h"
#import "LoginCell.h"
#import "NSRegularExpression+Addition.h"
//#import "IQUIView+IQKeyboardToolbar.h"

#import "PKBaseRequest.h"

@interface OrderAddressView ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    
    IBOutlet UIView *_header;
    
    IBOutlet UIView *_footer;
    
    IBOutlet UITableView *_tableView;
    
    NSMutableArray * _rows;
    
}
@end

@implementation OrderAddressView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"OrderAddressView" owner:self options:nil];
        self = [nib objectAtIndex:0];
    }
    return self;
}

-(void)awakeFromNib
{
    _rows = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0,@0,@0, nil];
    

    [self addSubview:_tableView];
    _tableView.tableHeaderView = _header;
    _tableView.tableFooterView = _footer;
    
    [super awakeFromNib];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [_rows count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSNumber * num = _rows[indexPath.row];
    if ([num integerValue] == 1) {
        return loginCellWrongheight;
    }
    return loginCellNormalHeight;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"LoginCell";
    LoginCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [LoginCell loadFromXib];
    }
    switch (indexPath.row) {
        case 0:
            cell.txtField.placeholder = @"姓名";
            break;
        case 1:
            cell.txtField.placeholder = @"地址";
            break;
        case 2:
            cell.txtField.placeholder = @"省或市";
            break;
        case 3:
            cell.txtField.placeholder = @"城市";
            break;
        case 4:
            cell.txtField.placeholder = @"地区";
            break;
        case 5:
            cell.txtField.placeholder = @"邮编";
            break;
        case 6:
            cell.txtField.placeholder = @"手机";
            break;

        default:
            break;
    }
    cell.txtField.delegate = self;
    cell.txtField.inputAccessoryView = [[UIView alloc] init];
    return cell;
    
}

/*! doneAction. */
-(void)doneAction:(UIBarButtonItem*)barButton
{
    //doneAction
}

/**
 *  计算得到tableView的高度
 *
 *  @return
 */
-(CGFloat)tableHeight
{
    return _tableView.contentSize.height;
}

#pragma mark - Button Methods
- (IBAction)gotoUsefulAddressAction:(id)sender {
    _usefulAction();
}

- (IBAction)saveAddressInfoAction:(id)sender {
    
    NSArray * cells = _tableView.visibleCells;
    __block AddressModel * addModel = [[AddressModel alloc] init];
    [cells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        LoginCell * cell = (LoginCell *)obj;
        switch (idx) {
            case 0:
                addModel.name = cell.txtField.text;
                break;
            case 1:
                addModel.address = cell.txtField.text;
                break;
                
            case 2:
                addModel.province = cell.txtField.text;
                break;
                
            case 3:
                addModel.city = cell.txtField.text;
                break;
                
            case 4:
                addModel.area = cell.txtField.text;
                break;
                
            case 5:
                addModel.postalNum = cell.txtField.text;
                break;
                
            case 6:
                addModel.phone = cell.txtField.text;
                break;
                
                
            default:
                break;
        }
        
    }];
    [self requestToSaveAddress:addModel];
    //将信息赋值给收货信息视图中得对应字段
    
    //将视图从父视图中删除
    [self removeFromSuperview];
    //将收货信息添加到视图中
    _saveAddressAction(addModel);
    if (_delegate && [_delegate respondsToSelector:@selector(changeViewToShow:)]) {
        [_delegate changeViewToShow:addModel];
    }
}



#pragma mark - textFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    for (int i =0; i<7; i++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        LoginCell * cell = (LoginCell *)[_tableView cellForRowAtIndexPath:indexPath];
        switch (i) {
            case 0:
            {
                //姓名
                if (!(cell.txtField == textField)) {
                    break;
                }
                
                if ([textField.text isEqualToString:@""]) {
                    [_rows removeObjectAtIndex:0];
                    [_rows insertObject:@1 atIndex:0];
                    cell.remindLBl.hidden = NO;
                    cell.remindLBl.text = @"姓名不能为空";
                    [_tableView beginUpdates];
                    [_tableView reloadData];
                    [_tableView endUpdates];
                }else{
                    [_rows removeObjectAtIndex:0];
                    [_rows insertObject:@0 atIndex:0];
                    cell.remindLBl.hidden = YES;
                    [_tableView beginUpdates];
                    [_tableView reloadData];
                    [_tableView endUpdates];

                }
            }
                break;
            case 1:
            {
                //地址

                if (!(cell.txtField == textField)) {
                    break;
                }
                if ([textField.text isEqualToString:@""]) {
                    [_rows removeObjectAtIndex:1];
                    [_rows insertObject:@1 atIndex:1];
                    cell.remindLBl.hidden = NO;
                    cell.remindLBl.text = @"地址不能为空";
                    [_tableView beginUpdates];
                    [_tableView reloadData];
                    [_tableView endUpdates];
                }else{
                    [_rows removeObjectAtIndex:1];
                    [_rows insertObject:@0 atIndex:1];
                    cell.remindLBl.hidden = YES;
                    [_tableView beginUpdates];
                    [_tableView reloadData];
                    [_tableView endUpdates];
                    
                }
            }
                break;
            case 2:
            {
                //省市
                if (!(cell.txtField == textField)) {
                    break;
                }
                if ([textField.text isEqualToString:@""]) {
                    [_rows removeObjectAtIndex:2];
                    [_rows insertObject:@1 atIndex:2];
                    cell.remindLBl.hidden = NO;
                    cell.remindLBl.text = @"省或市不能为空";
                    [_tableView beginUpdates];
                    [_tableView reloadData];
                    [_tableView endUpdates];
                }else{
                    [_rows removeObjectAtIndex:2];
                    [_rows insertObject:@0 atIndex:2];
                    cell.remindLBl.hidden = YES;
                    [_tableView beginUpdates];
                    [_tableView reloadData];
                    [_tableView endUpdates];
                    
                }

            }
                break;
            case 3:
            {
                //城市
                if (!(cell.txtField == textField)) {
                    break;
                }
                if ([textField.text isEqualToString:@""]) {
                    [_rows removeObjectAtIndex:3];
                    [_rows insertObject:@1 atIndex:3];
                    cell.remindLBl.hidden = NO;
                    cell.remindLBl.text = @"城市不能为空";
                    [_tableView beginUpdates];
                    [_tableView reloadData];
                    [_tableView endUpdates];
                }else{
                    [_rows removeObjectAtIndex:3];
                    [_rows insertObject:@0 atIndex:3];
                    cell.remindLBl.hidden = YES;
                    [_tableView beginUpdates];
                    [_tableView reloadData];
                    [_tableView endUpdates];
                    
                }

            }
                break;
            case 4:
            {
                //地区
                if (!(cell.txtField == textField)) {
                    break;
                }
                if ([textField.text isEqualToString:@""]) {
                    [_rows removeObjectAtIndex:4];
                    [_rows insertObject:@1 atIndex:4];
                    cell.remindLBl.hidden = NO;
                    cell.remindLBl.text = @"地区不能为空";
                    [_tableView beginUpdates];
                    [_tableView reloadData];
                    [_tableView endUpdates];
                }else{
                    [_rows removeObjectAtIndex:4];
                    [_rows insertObject:@0 atIndex:4];
                    cell.remindLBl.hidden = YES;
                    [_tableView beginUpdates];
                    [_tableView reloadData];
                    [_tableView endUpdates];
                    
                }

            }
                break;
            case 5:
            {
                //邮编
                if (!(cell.txtField == textField)) {
                    break;
                }
                if (![NSRegularExpression validatePostcode:textField.text]) {
                    [_rows removeObjectAtIndex:5];
                    [_rows insertObject:@1 atIndex:5];
                    cell.remindLBl.hidden = NO;
                    cell.remindLBl.text = @"邮编不合法";
                    [_tableView beginUpdates];
                    [_tableView reloadData];
                    [_tableView endUpdates];
                }else{
                    [_rows removeObjectAtIndex:5];
                    [_rows insertObject:@0 atIndex:5];
                    cell.remindLBl.hidden = YES;
                    [_tableView beginUpdates];
                    [_tableView reloadData];
                    [_tableView endUpdates];
                    
                }

            }
                break;
            case 6:
            {
                //手机
                if (!(cell.txtField == textField)) {
                    break;
                }

                if (![NSRegularExpression validateMobile:textField.text]) {
                    [_rows removeObjectAtIndex:6];
                    [_rows insertObject:@1 atIndex:6];
                    cell.remindLBl.text = @"手机号不合法";
                    cell.remindLBl.hidden = NO;
                    [_tableView beginUpdates];
                    [_tableView reloadData];
                    [_tableView endUpdates];
                }else{
                    [_rows removeObjectAtIndex:6];
                    [_rows insertObject:@0 atIndex:6];
                    cell.remindLBl.hidden = YES;
                    [_tableView beginUpdates];
                    [_tableView reloadData];
                    [_tableView endUpdates];

                }
            }
                break;
            default:
                break;
        }
    }
   
}

#pragma mark - textFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    UITextField * field = [[UITextField alloc] initWithFrame:textField.bounds];
    field.tag = 100;
    [field setBackground:[UIImage imageNamed:@"input-box.png"]];
   
    field.placeholder = textField.placeholder;
    textField.inputAccessoryView = field;
    
    [textField addTarget:self action:@selector(updateFieldContent:) forControlEvents:UIControlEventEditingChanged];
    
    NSLog(@"textField.Frame = %@",NSStringFromCGRect(textField.frame));
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//当用户按下ruturn，把焦点从textField移开那么键盘就会消失了
//    NSTimeInterval animationDuration = 0.30f;
//    CGRect frame = self.frame;
//    frame.origin.y +=216;
//    frame.size. height -=216;
//    self.frame = frame;
//	//self.view移回原位置
//	[UIView beginAnimations:@"ResizeView" context:nil];
// 	[UIView setAnimationDuration:animationDuration];
//    self.frame = frame;
//    [UIView commitAnimations];
    [textField resignFirstResponder];
    
    NSLog(@"field.tag = %d",textField.tag);
    
    return YES;
}

-(void)updateFieldContent:(UITextField *)sender
{
    UITextField * field = (UITextField *)sender.inputAccessoryView;
    field.text = sender.text;

}

-(void)requestToSaveAddress:(AddressModel *)address
{
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:DATA_ENV.userInfo.userId forKey:@"userId"];
    [parameter setObject:_orderId forKey:@"orderId"];
    [parameter setObject:address.name forKey:@"receiver"];
    [parameter setObject:address.address forKey:@"receiveAddress"];
    [parameter setObject:address.province forKey:@"province"];
    [parameter setObject:address.city forKey:@"city"];
    [parameter setObject:address.area forKey:@"borough"];
    [parameter setObject:address.phone forKey:@"contact"];
    [parameter setObject:address.postalNum forKey:@"postCode"];
    
    
    [RequestToSaveReceiceAddress requestWithParameters:parameter
                                     withIndicatorView:self
                                     withCancelSubject:@"RequestToSaveReceiceAddress"
                                        onRequestStart:nil
                                     onRequestFinished:^(ITTBaseDataRequest *request) {
                                         if ([request isSuccess]) {
                                             
                                             NSLog(@"sdfsfsfsfffsfdfs");
                                         }
                                         
                                     } onRequestCanceled:nil
                                       onRequestFailed:^(ITTBaseDataRequest *request) {
                                           [UIAlertView promptTipViewWithTitle:Nil message:request.handleredResult[@"messg"] cancelBtnTitle:@"确定" otherButtonTitles:Nil onDismiss:^(int buttonIndex) {
                                               
                                           } onCancel:^{
                                               
                                           }];
                                       }];
    
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
