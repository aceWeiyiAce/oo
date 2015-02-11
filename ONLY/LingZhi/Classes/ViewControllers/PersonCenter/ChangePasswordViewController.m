//
//  ChangePasswordViewController.m
//  LingZhi
//
//  Created by boguoc on 14-2-27.
//
//

#import "ChangePasswordViewController.h"
#import "NSRegularExpression+Addition.h"
#import "LoginCell.h"
#import "PKBaseRequest.h"
#import "LoginViewController.h"


@interface ChangePasswordViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

{
    
    __weak IBOutlet UITableView *_tableView;
    IBOutlet UIView *_footView;
    
    NSMutableArray *_rows;
    NSString * _firstPassword;
    NSString * _oldPwd;
    NSString * _secondPwd;
    
    UITextField * _recordEditTextField;
}
@end

@implementation ChangePasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _rows = [NSMutableArray arrayWithObjects:@0,@0,@0,@0, nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    _tableView.tableFooterView = _footView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableViewDelegate
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
    
    if (indexPath.row == 3) {
        return remindCellHeightForOneLine;
    }
    return loginCellNormalHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"LoginCell";
    
    LoginCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [LoginCell loadFromXib];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.txtField.placeholder = @"旧密码";
            cell.txtField.secureTextEntry = YES;
            break;

        case 1:
            cell.txtField.placeholder = @"输入新密码";
            cell.txtField.secureTextEntry = YES;
            break;
        case 2:
            cell.txtField.placeholder   = @"确认新密码";
            cell.txtField.secureTextEntry = YES;
            break;
        case 3:
        {
            [cell.contentView removeAllSubviews];
            UIImageView * remindImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gantanhao.png"]];
            remindImage.frame         = CGRectMake(17, 5, 15, 15);
            [cell.contentView addSubview:remindImage];
            
            UILabel * remindMsg       = [[UILabel alloc] initWithFrame:CGRectMake(35, 5, 270, 0)];
            remindMsg.textColor       = [UIColor grayColor];
            remindMsg.font            = [UIFont systemFontOfSize:13.0];
//            remindMsg.text            = @"请输入一个8-12位的密码，必须包含至少一位数字或字母，字母区分大小写";
            remindMsg.text            = @"请输入一个8-12位的密码";
            remindMsg.numberOfLines   = 0;
            [remindMsg sizeToFit];
            [cell.contentView addSubview:remindMsg];
            
        }
            break;
            
        default:
            break;
    }
    
    
    cell.txtField.delegate = self;
    return cell;
}






#pragma mark - textFieldDelegate


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.text = @"";
    _recordEditTextField =  textField;
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //旧密码
    NSIndexPath * indexPathOfOldPass = [NSIndexPath indexPathForRow:0 inSection:0];
    LoginCell * cellOldPass = (LoginCell *)[_tableView cellForRowAtIndexPath:indexPathOfOldPass];
    if (cellOldPass.txtField == textField) {
        _oldPwd = textField.text;
        if (textField.text && ![textField.text isEqualToString:@""]) {
            [_rows replaceObjectAtIndex:0 withObject:@0];
            cellOldPass.remindLBl.text = Nil;
            cellOldPass.remindLBl.hidden = YES;
        }
    }

    //密码
    NSIndexPath * indexPathOfPassword = [NSIndexPath indexPathForRow:1 inSection:0];
    LoginCell * cellPassword = (LoginCell *)[_tableView cellForRowAtIndexPath:indexPathOfPassword];
    if (cellPassword.txtField == textField) {
        _firstPassword = textField.text;
        if (![NSRegularExpression validatePassword:textField.text]) {
             [_rows replaceObjectAtIndex:1 withObject:@1];
            if (!textField.text || [textField.text isEqualToString:@""]) {
                cellPassword.remindLBl.text = @"请输入新密码";
            }else{
                cellPassword.remindLBl.text = @"无效密码";
            }
            cellPassword.remindLBl.hidden = NO;
           
        }else{
            [_rows replaceObjectAtIndex:1 withObject:@0];
            
            cellPassword.remindLBl.text = Nil;
            cellPassword.remindLBl.hidden = YES;
            
        }
    }
    
    //确认密码
    NSIndexPath * indexPathOfConfirmPassword = [NSIndexPath indexPathForRow:2 inSection:0];
    LoginCell * cellConfirmPassword = (LoginCell *)[_tableView cellForRowAtIndexPath:indexPathOfConfirmPassword];
    if (cellConfirmPassword.txtField == textField) {
        _secondPwd = textField.text;
        if (![textField.text isEqualToString:_firstPassword]) {
            [_rows replaceObjectAtIndex:2 withObject:@1];
            if (!textField.text || [textField.text isEqualToString:@""]) {
                cellPassword.remindLBl.text = @"请再次输入新密码";
            }else{
                cellConfirmPassword.remindLBl.text = @"两次密码输入不一致";
            }

            
            cellConfirmPassword.remindLBl.hidden = NO;
        }else{
            [_rows replaceObjectAtIndex:2 withObject:@0];
            cellConfirmPassword.remindLBl.text = Nil;
            cellConfirmPassword.remindLBl.hidden = YES;
        }
    }
    [_tableView beginUpdates];
    [_tableView reloadData];
    [_tableView endUpdates];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
};



- (IBAction)backToPreviewAction:(id)sender
{
    [_recordEditTextField resignFirstResponder];
    if (_productController) {
        [self.navigationController popToViewController:_productController animated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)confrimAction:(id)sender {
    [_recordEditTextField resignFirstResponder];
    __block BOOL hasValue =YES;
    
    for (int idx = 0; idx<3; idx++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
        LoginCell * c = (LoginCell *)[_tableView cellForRowAtIndexPath:indexPath];
        [c.txtField resignFirstResponder];
        if (![NSRegularExpression validatePassword:c.txtField.text]) {
            hasValue = NO;
            [_rows removeObjectAtIndex:idx];
            [_rows insertObject:@1 atIndex:idx];
             c.remindLBl.hidden = NO;
            if (!c.txtField.text || [c.txtField.text isEqualToString:@""]) {
                
                switch (idx) {
                    case 0:
                        c.remindLBl.text = @"请输入旧密码";
                        break;
                    case 1:
                        c.remindLBl.text = @"请输入新密码";
                        
                        break;
                    case 2:
                        c.remindLBl.text = @"请再次输入新密码";
                        break;
                    default:
                        break;
                }
                
               
            }else{
                c.remindLBl.text = @"无效密码";
            }
        }
        else{
            
            [_rows removeObjectAtIndex:idx];
            [_rows insertObject:@0 atIndex:idx];
            c.remindLBl.text = Nil;
            c.remindLBl.hidden = YES;
            if (idx == 2) {
                if (![_firstPassword isEqualToString:_secondPwd]) {
                    [_rows replaceObjectAtIndex:2 withObject:@1];
                    c.remindLBl.text = @"两次密码输入不一致";
                    c.remindLBl.hidden = NO;
                    hasValue = NO;
                }
            }
            
        }
    }
    
    
    if (!hasValue) {
        [_tableView beginUpdates];
        [_tableView reloadData];
        [_tableView endUpdates];
        return;
    }
    
    [self requestToUpdatePassword];
}

-(void)backtoPrePage
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)requestToUpdatePassword
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:DATA_ENV.userInfo.userId forKey:@"userName"];
    [parameter setObject:_oldPwd forKey:@"oldPassword"];
    [parameter setObject:_firstPassword forKey:@"newPassword"];
        
    [loginToUpdatePasswordRequest requestWithParameters:parameter
                               withIndicatorView:self.view
                               withCancelSubject:@"loginToUpdatePasswordRequest"
                                  onRequestStart:nil
                               onRequestFinished:^(ITTBaseDataRequest *request) {
                                   
                                   if ([request isSuccess]) {
                                       
                                       NSLog(@"reslut = %@",request.handleredResult);
                                       
                                       if ([request.handleredResult[@"status"] isEqualToString:@"0"]) {
                                           
                                           [[ActivityRemindView loadFromXib] showActivityViewInView:self.view withMsg:@"修改成功!" inSeconds:1.0];
                                           NSIndexPath * indexPathOfOldPass = [NSIndexPath indexPathForRow:0 inSection:0];
                                           LoginCell * cellOldPass = (LoginCell *)[_tableView cellForRowAtIndexPath:indexPathOfOldPass];
                                        
                                            [_rows removeObjectAtIndex:0];
                                            [_rows insertObject:@0 atIndex:0];
                                            cellOldPass.remindLBl.text = Nil;
                                            cellOldPass.remindLBl.hidden = YES;
                                            [_tableView beginUpdates];
                                            [_tableView reloadData];
                                            [_tableView endUpdates];
                                       
                                           [self performSelector:@selector(backtoPrePage) withObject:nil afterDelay:1.0];

                                       }
                                       
                                   }else{
                                       NSString * errorMsg = request.handleredResult[@"data"][@"message"];
                                       NSIndexPath * indexPathOfOldPass = [NSIndexPath indexPathForRow:0 inSection:0];
                                       LoginCell * cellOldPass = (LoginCell *)[_tableView cellForRowAtIndexPath:indexPathOfOldPass];
                                       
                                       [_rows removeObjectAtIndex:0];
                                       [_rows insertObject:@1 atIndex:0];
                                       cellOldPass.remindLBl.text = errorMsg;
                                       cellOldPass.remindLBl.hidden = NO;
                                       [_tableView beginUpdates];
                                       [_tableView reloadData];
                                       [_tableView endUpdates];
                                   }
                                   
                               } onRequestCanceled:nil
                                 onRequestFailed:^(ITTBaseDataRequest *request) {
                                     NSLog(@"request = %@",request);
                                     NSLog(@"code failed");
                                 }];
    
    
}


@end
