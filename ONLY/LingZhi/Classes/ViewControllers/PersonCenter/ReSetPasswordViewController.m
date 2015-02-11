//
//  ReSetPasswordViewController.m
//  LingZhi
//
//  Created by pk on 14-3-16.
//
//

#import "ReSetPasswordViewController.h"
#import "NSRegularExpression+Addition.h"
#import "LoginCell.h"
#import "PKBaseRequest.h"
#import "LoginViewController.h"
#import "RemindMsgCell.h"

#define  MobileWrongRemindMsg    @"您输入的用户名不存在"
#define  PasswordWrongRemindMsg  @"您输入的密码与用户名不匹配"

@interface ReSetPasswordViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

{
    
    __weak IBOutlet UITableView *_tableView;
    IBOutlet UIView *_footView;
    
    NSMutableArray *_rows;
    NSMutableArray * _remindMsgArr;
    NSMutableArray * _textValueArr;

    NSString * _firstPassword;
    
    NSString * _pwd;
    
    UIButton * _getCodeBtn;
    NSString * _recordIdentifyCode;
    NSString * _mobileNumber;
    NSString * _email;
    NSString * _password;
    
    BOOL timeStart;
    
    UITextField * _RecordtextField;
    

    BOOL resetGetCodeBtn;
    
}
@end

@implementation ReSetPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         _rows = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0, nil];
        _remindMsgArr = [NSMutableArray arrayWithObjects:@"手机号为空",@"验证码为空",@"密码为空",@"确认密码为空",@"", nil];
        _textValueArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"", nil];

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
    resetGetCodeBtn = YES;
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
    
    if (indexPath.row == 4) {
        return remindCellHeightForOneLine;
    }
    return loginCellNormalHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    static NSString *identifier = @"LoginCell";
    NSString *identifier = [NSString stringWithFormat:@"LoginCell%d",indexPath.row];
    static NSString *remindIdentifier = @"RemindMsgCell";
    
    if (indexPath.row == 4) {
        RemindMsgCell * remindCell = [tableView dequeueReusableCellWithIdentifier:remindIdentifier];
        if (!remindCell) {
            remindCell = [RemindMsgCell loadFromXib];
        }
        remindCell.remindStr = @"请输入一个6-12位的密码";
        return remindCell;
    }
    
    LoginCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [LoginCell loadFromXib];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.txtField.placeholder = @"手机号码";
//            cell.txtField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case 1:
        {
            cell.txtField.placeholder   = @"输入验证码";
            CGRect celltxtFieldFrame    = cell.txtField.frame;
            celltxtFieldFrame.size      = CGSizeMake(135, GET_VIEW_HEIGHT(cell.txtField));
            cell.txtField.frame         = celltxtFieldFrame;
            
            //增加获取验证码的按钮
            if (!_getCodeBtn) {
                _getCodeBtn             = [UIButton buttonWithType:UIButtonTypeCustom];
                _getCodeBtn.backgroundColor = [UIColor blackColor];
                _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
                [_getCodeBtn addTarget:self action:@selector(getIdentifyCode:) forControlEvents:UIControlEventTouchUpInside];
                [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                _getCodeBtn.frame           = CGRectMake(165, 3, 137, 30);
//                [cell.contentView addSubview:_getCodeBtn];
//                [self reuseGetButton];
            }
            [cell.contentView addSubview:_getCodeBtn];
            [self reuseGetButton];

            CGRect frameOfRemind        = cell.remindLBl.frame;
            frameOfRemind.size          = CGSizeMake(135, GET_VIEW_HEIGHT(cell.remindLBl));
            cell.remindLBl.frame        = frameOfRemind;
            
        }
            break;

        case 2:
            cell.txtField.placeholder = @"输入新密码";
            cell.txtField.secureTextEntry = YES;
            break;
        case 3:
            cell.txtField.placeholder   = @"确认新密码";
            cell.txtField.secureTextEntry = YES;
            break;
            
        default:
            break;
    }
    
    
    cell.txtField.delegate = self;
    cell.txtField.tag = 100 + indexPath.row;
    cell.remindLBl.hidden = [_rows[indexPath.row] intValue] == 1 ? NO : YES;
    cell.remindLBl.text = _remindMsgArr[indexPath.row];
    cell.txtField.text = _textValueArr[indexPath.row];
    return cell;
}





#pragma mark - textFieldDelegate



-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    //获取文本框针对self.view的相对位置
    CGPoint  convertPoint = [textField convertPoint:textField.origin toView:self.view];
    NSLog(@"convertPoint = %@",NSStringFromCGPoint(convertPoint));
    
    //计算文本框的起始点和高度的和
    CGFloat startWithHeight = convertPoint.y + textField.size.height;
    
    //得到self.view - keyboardHeight 的高度
    CGFloat distanceKeyboard = self.view.height - KeyBoardHeight;
    if (startWithHeight >= distanceKeyboard) {
        if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
            [_tableView setContentOffset:CGPointMake(_tableView.origin.x,  startWithHeight - distanceKeyboard)];
        }else{
            [_tableView setContentOffset:CGPointMake(_tableView.origin.x,  startWithHeight - distanceKeyboard + 20)];
        }
    }
    
    _tableView.size = CGSizeMake(320, SCREEN_HEIGHT - KeyBoardHeight);
    
    _RecordtextField = textField;
}



-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [_textValueArr replaceObjectAtIndex:(textField.tag - 100) withObject:textField.text];
//    //验证码
//    NSIndexPath * indexPathOfMobile = [NSIndexPath indexPathForRow:0 inSection:0];
//    LoginCell * cellMobile = (LoginCell *)[_tableView cellForRowAtIndexPath:indexPathOfMobile];
//    if (cellMobile.txtField == textField) {
//        _mobileNumber = textField.text;
//        if (![NSRegularExpression validateMobile:textField.text]) {
//            [_rows removeObjectAtIndex:0];
//            [_rows insertObject:@1 atIndex:0];
//            cellMobile.remindLBl.hidden = NO;
//            if (!textField.text || [textField.text isEqualToString:@""]) {
//                cellMobile.remindLBl.text = @"手机号为空";
//            } else {
//                cellMobile.remindLBl.text = @"请输入有效的手机号";
//            }
//        }else{
//            [_rows removeObjectAtIndex:0];
//            [_rows insertObject:@0 atIndex:0];
//            cellMobile.remindLBl.text = nil;
//            cellMobile.remindLBl.hidden = YES;
//           
//        }
//    }
//
//    
//    //验证码
//    NSIndexPath * indexPathOfVcode = [NSIndexPath indexPathForRow:1 inSection:0];
//    LoginCell * cellVCode = (LoginCell *)[_tableView cellForRowAtIndexPath:indexPathOfVcode];
//    if (cellVCode.txtField == textField) {
//        if (![cellVCode.txtField.text isEqualToString:_recordIdentifyCode]) {
//            [_rows removeObjectAtIndex:1];
//            [_rows insertObject:@1 atIndex:1];
//             cellVCode.remindLBl.hidden = NO;
//            if (!cellVCode.txtField.text || [textField.text isEqualToString:@""]) {
//                cellVCode.remindLBl.text = @"验证码为空";
//            } else {
//                cellVCode.remindLBl.text = @"验证码输入错误";
//            }
//        }else{
//            [_rows removeObjectAtIndex:1];
//            [_rows insertObject:@0 atIndex:1];
//            cellVCode.remindLBl.text = nil;
//            cellVCode.remindLBl.hidden = YES;
//          
//        }
//    }
//
//    
//    //密码
//    NSIndexPath * indexPathOfPassword = [NSIndexPath indexPathForRow:2 inSection:0];
//    LoginCell * cellPassword = (LoginCell *)[_tableView cellForRowAtIndexPath:indexPathOfPassword];
//    if (cellPassword.txtField == textField) {
//        _firstPassword = textField.text;
//        if (![NSRegularExpression validatePassword:textField.text]) {
//            
//            [_rows removeObjectAtIndex:2];
//            [_rows insertObject:@1 atIndex:2];
//            cellPassword.remindLBl.text = @"无效密码";
//            cellPassword.remindLBl.hidden = NO;
//          
//        }else{
//            [_rows removeObjectAtIndex:2];
//            [_rows insertObject:@0 atIndex:2];
//            cellPassword.remindLBl.text = nil;
//            cellPassword.remindLBl.hidden = YES;
//          
//        }
//    }
//    
//    //确认密码
//    NSIndexPath * indexPathOfConfirmPassword = [NSIndexPath indexPathForRow:3 inSection:0];
//    LoginCell * cellConfirmPassword = (LoginCell *)[_tableView cellForRowAtIndexPath:indexPathOfConfirmPassword];
//    if (cellConfirmPassword.txtField == textField) {
//
//        _pwd = textField.text;
//        if (![textField.text isEqualToString:_firstPassword]) {
//            [_rows removeObjectAtIndex:3];
//            [_rows insertObject:@1 atIndex:3];
//            cellConfirmPassword.remindLBl.text = @"两次密码输入不一致，请重新输入";
//            cellConfirmPassword.remindLBl.hidden = NO;
//          
//        }else{
//            [_rows removeObjectAtIndex:3];
//            [_rows insertObject:@0 atIndex:3];
//            cellConfirmPassword.remindLBl.hidden = YES;
//           
//        }
//    }
//    
//    [_tableView beginUpdates];
//    [_tableView reloadData];
//    [_tableView endUpdates];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_textValueArr replaceObjectAtIndex:(textField.tag - 100) withObject:textField.text];
    [textField resignFirstResponder];
    _tableView.frame = CGRectMake(0, 44, 320, SCREEN_HEIGHT - 64);
    return YES;
};


-(BOOL)hasNullOrWrongValue
{
    BOOL hasNull = NO;
    
    for (int idx = 0; idx<4; idx++)  {
        
       
        NSString * value = _textValueArr[idx];
        
        if (!value || [value isEqualToString:@""]) {
            hasNull = YES;
            [_rows replaceObjectAtIndex:idx withObject:@1];
        }else{
            [_rows replaceObjectAtIndex:idx withObject:@0];
        }
        
        switch (idx) {
            case 0:
            {
                if (![NSRegularExpression validateMobile:value]) {
                    [_remindMsgArr replaceObjectAtIndex:idx withObject:MobileWrongRemindMsg];
                    if (!value || [value isEqualToString:@""]) {
                        [_remindMsgArr replaceObjectAtIndex:idx withObject:@"手机号为空"];
                    }
                    hasNull = YES;
                    [_rows replaceObjectAtIndex:idx withObject:@1];
                }else{
                    [_rows replaceObjectAtIndex:idx withObject:@0];
                }
                
            }
                break;
            case 1:
            {
                if (![value isEqualToString:_recordIdentifyCode]) {
                    hasNull = YES;
                    [_rows replaceObjectAtIndex:idx withObject:@1];
                  
                    if (!value || [value isEqualToString:@""]) {
                        [_remindMsgArr replaceObjectAtIndex:idx withObject:@"验证码为空"];
                    } else {
                        [_remindMsgArr replaceObjectAtIndex:idx withObject:@"验证码输入错误"];
                    }
                }else{
                    [_rows replaceObjectAtIndex:idx withObject:@0];
                }
            }
                break;
                
            case 2:
            {
                _firstPassword = value;
                if (![NSRegularExpression validatePassword:value]) {
                    hasNull = YES;
                     [_rows replaceObjectAtIndex:idx withObject:@1];
                    [_remindMsgArr replaceObjectAtIndex:idx withObject:@"无效密码"];
       
                }else{
                     [_rows replaceObjectAtIndex:idx withObject:@0];
                }

            }
                break;
                
            case 3:
            {
                
                _pwd = value;

                if (![_pwd isEqualToString:_firstPassword]|| !_pwd || [_pwd isEqualToString:@""]) {
                    hasNull = YES;
                    [_rows replaceObjectAtIndex:idx withObject:@1];
    
                    [_remindMsgArr replaceObjectAtIndex:idx withObject: @"两次密码输入不一致"];
                    if (!_pwd || [_pwd isEqualToString:@""]) {
                    
                        [_remindMsgArr replaceObjectAtIndex:idx withObject:@"确认密码为空"];
                    }
                    
                }else{
                   [_rows replaceObjectAtIndex:idx withObject:@0];
                    
                }
               
            }
                break;
            default:
                break;
        }
        
    };
    
    [_tableView beginUpdates];
    [_tableView reloadData];
    [_tableView endUpdates];
    return hasNull;
}


#pragma mark - button methods
- (IBAction)backToPreviewAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}



- (IBAction)confrimBtnAction:(id)sender {
    
    NSLog(@"确定");
    [_RecordtextField resignFirstResponder];
    
    if ([self hasNullOrWrongValue]) {
        return;
    }
    
    [self requestToUpdatePassword];
}

/**
 *  获取验证码
 *
 *  @param sender
 */
-(void)getIdentifyCode:(id)sender
{
    _tableView.frame = CGRectMake(0, 44, 320, SCREEN_HEIGHT - 64);
    NSLog(@"获取验证码......");

//    //手机号
    NSIndexPath * indexPathOfPhone = [NSIndexPath indexPathForRow:0 inSection:0];
    LoginCell * cell = (LoginCell *)[_tableView cellForRowAtIndexPath:indexPathOfPhone];
    [cell.txtField resignFirstResponder];
    _mobileNumber = cell.txtField.text;
    
    if (![NSRegularExpression validateMobile:cell.txtField.text]) {
        
        [_rows removeObjectAtIndex:0];
        [_rows insertObject:@1 atIndex:0];
        [_remindMsgArr replaceObjectAtIndex:0 withObject:@"手机号不合法"];
        if ([cell.txtField.text isEqualToString:@""] || !cell.txtField.text) {
            [_remindMsgArr replaceObjectAtIndex:0 withObject:@"手机号为空"];
        }
        
        cell.remindLBl.hidden = NO;
        [_tableView beginUpdates];
        [_tableView reloadData];
        cell.height =  88;
        
        [_tableView endUpdates];
        
        return;

    }else{
        [_rows removeObjectAtIndex:0];
        [_rows insertObject:@0 atIndex:0];
        cell.remindLBl.text = nil;
        cell.remindLBl.hidden = YES;
        [_tableView beginUpdates];
        [_tableView reloadData];
        [_tableView endUpdates];
    }

    
    [self requestToGetVCode];
    
  
}

/**
 *  验证码发送成功以后条用此方法 ，开始计时功能
 */
-(void)updateGetCodeBtn
{
    if (_getCodeBtn.isEnabled) {
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
        timeStart = YES;
        resetGetCodeBtn = YES;
    }
    _getCodeBtn.enabled = NO;
    [_getCodeBtn setBackgroundColor:[UIColor grayColor]];
}


-(void)reuseGetButton
{
   
    
    //update at 20140528
    if (resetGetCodeBtn) {
        [_getCodeBtn setBackgroundColor:[UIColor blackColor]];
        _getCodeBtn.enabled = YES;
    }else{
        [_getCodeBtn setBackgroundColor:[UIColor grayColor]];
        _getCodeBtn.enabled = NO;
    }
}


#pragma mark - 倒计时
- (void)timerFireMethod:(NSTimer *)theTimer
{
    NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    NSDateComponents *endTime = [[NSDateComponents alloc] init];    //初始化目标时间...
    NSDate *today = [NSDate date];    //得到当前时间
    
    NSDate *date = [NSDate dateWithTimeInterval:60 sinceDate:today];
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
        resetGetCodeBtn = NO;
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

    
    if([d second] > 0) {
        
        //计时尚未结束，do_something
        NSString * str = [NSString stringWithFormat:@"再次发送验证码(%d秒)",[d second]];
        [_getCodeBtn setTitle:str forState:UIControlStateNormal];
        [_getCodeBtn setTitle:str forState:UIControlStateDisabled];
        
    }else{
        _getCodeBtn.enabled = YES;
        resetGetCodeBtn = YES;
        NSString * str = [NSString stringWithFormat:@"再次发送验证码"];
        [_getCodeBtn setTitle:str forState:UIControlStateNormal];
         [_getCodeBtn setTitle:str forState:UIControlStateDisabled];
        //计时1分钟结束，do_something
        [_getCodeBtn setBackgroundColor:[UIColor blackColor]];
        [theTimer invalidate];
    }
    
}


#pragma mark - request methods
/**
 *  给服务器发送请求，获取手机验证码
 *
 *  @return
 */
-(void)requestToGetVCode
{
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:_mobileNumber forKey:@"userName"];
    [parameter setObject:AppSystemId forKey:@"brandCode"];
    
    [ForgetPassToGetCodeRequest requestWithParameters:parameter
                             withIndicatorView:self.view
                             withCancelSubject:@"ForgetPassToGetCodeRequest"
                                onRequestStart:nil
                             onRequestFinished:^(ITTBaseDataRequest *request) {
                                 
                                 
                                 LoginCell * cell = [[_tableView visibleCells] firstObject];
                                 if ([request.handleredResult[@"status"] isEqualToString:@"-1"]) {
                                     
                                     [_rows replaceObjectAtIndex:0 withObject:@1];
                                     [_remindMsgArr replaceObjectAtIndex:0 withObject:request.handleredResult[@"messg"]];
                                     cell.remindLBl.hidden = NO;
                                     cell.remindLBl.text = request.handleredResult[@"messg"];
                                     [_tableView beginUpdates];
                                     [_tableView reloadData];
                                     [_tableView endUpdates];
                                     
                                 }
                                 if ([request isSuccess]) {
                                     
                                     NSLog(@"reslut = %@",request.handleredResult);
                                    [self updateGetCodeBtn];
                                     _recordIdentifyCode = [NSString stringWithFormat:@"%@",request.handleredResult[@"data"][@"vcode"]];
                                     NSLog(@"_recordIdentifyCode = %@",_recordIdentifyCode);
                                     
                                     if (!cell.remindLBl.hidden) {
                                         [_rows removeObjectAtIndex:0];
                                         [_rows insertObject:@0 atIndex:0];
                                         cell.remindLBl.hidden = YES;
                                         [_tableView beginUpdates];
                                         [_tableView reloadData];
                                         [_tableView endUpdates];
                                     }
                                     
                                 }
                                 
                             } onRequestCanceled:nil
                               onRequestFailed:^(ITTBaseDataRequest *request) {
                                   NSLog(@"code failed");
                                   
                               }];
    
}


-(void)requestToUpdatePassword
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:_mobileNumber forKey:@"userName"];
    [parameter setObject:_firstPassword forKey:@"password"];
    
    [UpdatePasswordRequest requestWithParameters:parameter
                               withIndicatorView:self.view
                               withCancelSubject:@"UpdatePasswordRequest"
                                  onRequestStart:nil
                               onRequestFinished:^(ITTBaseDataRequest *request) {
                                   
                                   if ([request isSuccess]) {
                                       
                                       NSLog(@"reslut = %@",request.handleredResult);
                                       
                                       if ([request.handleredResult[@"status"] isEqualToString:@"0"]) {
                                           
                                           [UIAlertView promptTipViewWithTitle:Nil message:@"修改成功" cancelBtnTitle:@"确定" otherButtonTitles:Nil onDismiss:^(int buttonIndex) {
                                               
                                           } onCancel:^{
                                               if ([_delegate respondsToSelector:@selector(updateMobileNumber:)]) {
                                                   [_delegate updateMobileNumber:_mobileNumber];
                                               }
                                               [self.navigationController popViewControllerAnimated:YES];
                                           }];
                                           
                                           
                                       }
                                       
                                   }else{
                                       NSString * errorMsg = request.handleredResult[@"messg"];
                                       [UIAlertView promptTipViewWithTitle:Nil message:errorMsg cancelBtnTitle:@"确定" otherButtonTitles:Nil onDismiss:^(int buttonIndex) {
                                           
                                       } onCancel:^{
                                           
                                       }];
                                   }
                                   
                               } onRequestCanceled:nil
                                 onRequestFailed:^(ITTBaseDataRequest *request) {
                                     NSLog(@"code failed");
                                 }];
    
    
}



@end
