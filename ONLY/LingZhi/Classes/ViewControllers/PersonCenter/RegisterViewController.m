//
//  RegisterViewController.m
//  LingZhi
//
//  Created by pk on 3/14/14.
//
//

#import "RegisterViewController.h"
#import "LoginCell.h"
#import "NSRegularExpression+Addition.h"
#import "PKBaseRequest.h"
#import "UIAlertView+ITTAdditions.h"
#import "UserProtocolView.h"
#import "RemindMsgCell.h"

@interface RegisterViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    IBOutlet UITableView *_tableView;
    
    
    NSMutableArray * _rows;
    NSMutableArray * _remindMsgArr;
    NSMutableArray * _textValueArr;

    UIButton * _getCodeBtn;
    NSString * _recordIdentifyCode;
    NSString * _mobileNumber;
    NSString * _email;
    NSString * _password;
    
    NSString * _firstPassword;
    
    
    
    //footView
    IBOutlet UIView *_footView;
    __weak IBOutlet UIButton *_checkBtn;
    __weak IBOutlet UIButton *_conditionsBtn;
    __weak IBOutlet UIButton *_resignBtn;
    
    BOOL timeStart;
    int isChecked;
    
    BOOL hasWrong;
    NSString * _wrongEmailMsg;
    
    UITextField * _recordTxtField;
    
    BOOL resetGetCodeBtn;
    
}
@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _rows = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0,@0,@0, nil];
        _remindMsgArr = [NSMutableArray arrayWithObjects:@"手机号为空",@"验证码为空",@"电子邮箱为空",@"",@"密码为空",@"",@"确认密码为空", nil];
        _textValueArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"", nil];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    isChecked = 1;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 15)];
    _tableView.tableFooterView = _footView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    hasWrong = NO;
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
    NSLog(@"rowNum = %d",[num intValue]);
    if ([num integerValue] == 1) {

        return loginCellWrongheight;
    }
    
    if (indexPath.row == 5) {
        return remindCellHeightForOneLine;
    }
    
    return loginCellNormalHeight;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *remindIdentifier =@"RemindMsgCell";
    
    if (indexPath.row == 5) {
        RemindMsgCell * remindCell = [tableView dequeueReusableCellWithIdentifier:remindIdentifier];
        if (!remindCell) {
            remindCell = [RemindMsgCell loadFromXib];
        }
        
        switch (indexPath.row) {
            case 3:
                remindCell.remindStr = @"请输入常用电子邮件地址以作为找回密码邮件接收地址";
                break;
            case 5:
                remindCell.remindStr = @"请输入一个8-12位的密码";
////            remindCell.remindStr = @"请输入一个8-12位的密码，必须包含至少一位数字或字母，字母区分大小写";
                break;
            default:
                break;
        }
        return remindCell;
        
    }
    NSString *identifier = [NSString stringWithFormat:@"LoginCell%d",indexPath.row];
    LoginCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [LoginCell loadFromXib];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.txtField.placeholder = @"手机号码";
            cell.txtField.secureTextEntry = NO;
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
            
            if ([_rows[1] intValue]!=1) {
                cell.remindLBl.hidden = YES;
            }else{
                cell.remindLBl.hidden = NO;
            }
            cell.txtField.secureTextEntry = NO;
        }
            break;
        case 2:
        {
            cell.txtField.secureTextEntry = NO;
            cell.txtField.placeholder  = @"电子邮箱";
            cell.txtField.keyboardType = UIKeyboardTypeEmailAddress;
            if ([_rows[2] intValue]==1) {
                cell.remindLBl.hidden = NO;
                cell.remindLBl.text = _wrongEmailMsg;
            }
        }
            break;

        case 4:
        {
            cell.txtField.placeholder     = @"密码";
            cell.txtField.secureTextEntry = YES;
        }
            break;
            
        case 6:
        {
            cell.txtField.placeholder     = @"确认密码";
            cell.txtField.secureTextEntry = YES;
        }
            break;
            
        default:
            break;
    }
    if ([_rows[indexPath.row] intValue] == 1) {
        cell.remindLBl.hidden = NO;
    }
    cell.remindLBl.text = _remindMsgArr[indexPath.row];
    cell.txtField.text = _textValueArr[indexPath.row];
    cell.txtField.tag = 100 + indexPath.row;
    cell.txtField.delegate = self;
    return cell;
}


-(void)reuseGetButton
{
//    if (!timeStart) {
//        [_getCodeBtn setBackgroundColor:[UIColor blackColor]];
//        _getCodeBtn.enabled = YES;
//    }else{
//        [_getCodeBtn setBackgroundColor:[UIColor grayColor]];
//        _getCodeBtn.enabled = NO;
//    }
    
    //update at 20140528
    if (resetGetCodeBtn) {
        [_getCodeBtn setBackgroundColor:[UIColor blackColor]];
        _getCodeBtn.enabled = YES;
    }else{
        [_getCodeBtn setBackgroundColor:[UIColor grayColor]];
        _getCodeBtn.enabled = NO;
    }
}




#pragma mark - textFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _recordTxtField = textField;
    //验证码
    NSIndexPath * indexPathOfCode = [NSIndexPath indexPathForRow:1 inSection:0];
    LoginCell * cellCode = (LoginCell *)[_tableView cellForRowAtIndexPath:indexPathOfCode];
    if (cellCode.txtField == textField) {
        textField.text = nil;
    }
    
    
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
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{

    [_textValueArr replaceObjectAtIndex:(textField.tag - 100) withObject:textField.text];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [_textValueArr replaceObjectAtIndex:(textField.tag - 100) withObject:textField.text];
    
    NSLog(@"_textValueArr = %@",_textValueArr);
    [textField resignFirstResponder];
    
    _tableView.frame = CGRectMake(0, 44, 320, SCREEN_HEIGHT - 64);
    return YES;
};


//-(BOOL)checkVauleExistNullOrWrong
//{
//    
//    BOOL hasNullOrWrong = NO;
//    //手机号
//    NSIndexPath * indexPathOfPhone = [NSIndexPath indexPathForRow:0 inSection:0];
//    LoginCell * cell = (LoginCell *)[_tableView cellForRowAtIndexPath:indexPathOfPhone];
//    
//        NSLog(@"1");
//        _mobileNumber = cell.txtField.text;
//        if (![NSRegularExpression validateMobile:cell.txtField.text]) {
//            [_rows replaceObjectAtIndex:0 withObject:@1];
//            [_remindMsgArr replaceObjectAtIndex:0 withObject:@"手机号码无效,请重新填写"];
//            cell.remindLBl.text = @"手机号码无效,请重新填写";
//            cell.remindLBl.hidden = NO;
//            hasNullOrWrong = YES;
//        }else{
//        
//            [_rows replaceObjectAtIndex:0 withObject:@0];
//            cell.remindLBl.hidden = YES;
//        }
//    
//   
//    
//    //验证码
//    NSIndexPath * indexPathOfCode = [NSIndexPath indexPathForRow:1 inSection:0];
//    LoginCell * cellCode = (LoginCell *)[_tableView cellForRowAtIndexPath:indexPathOfCode];
//    
//    if (![cellCode.txtField.text isEqualToString:_recordIdentifyCode]) {
//        cellCode.remindLBl.hidden = NO;
//
//        [_rows replaceObjectAtIndex:1 withObject:@1];
//        if (!cellCode.txtField.text || [cellCode.txtField.text isEqualToString:@""]) {
//            cellCode.remindLBl.text = @"请输入验证码";
//        } else {
//            cellCode.remindLBl.text = @"验证码输入错误";
//            [_remindMsgArr replaceObjectAtIndex:1 withObject:@"验证码输入错误"];
//
//        }
//        hasNullOrWrong = YES;
//    }else{
//        cellCode.remindLBl.hidden = YES;
//        [_rows replaceObjectAtIndex:1 withObject:@0];
//    }
//
//    //电子邮箱
//    NSIndexPath * indexPathOfEmail = [NSIndexPath indexPathForRow:2 inSection:0];
//    LoginCell * cellEmail = (LoginCell *)[_tableView cellForRowAtIndexPath:indexPathOfEmail];
//
//    _email = cellEmail.txtField.text;
//    if (![NSRegularExpression validateEmail:cellEmail.txtField.text]) {
//
//        [_rows replaceObjectAtIndex:2 withObject:@1];
//        cellEmail.remindLBl.text = @"电子邮件地址无效，请重新填写";
//        [_remindMsgArr replaceObjectAtIndex:2 withObject:@"电子邮件地址无效，请重新填写"];
//        _wrongEmailMsg = @"电子邮件地址无效，请重新填写";
//        cellEmail.remindLBl.hidden = NO;
//        hasNullOrWrong = YES;
//    }else{
//        [_rows replaceObjectAtIndex:2 withObject:@0];
//        cellEmail.remindLBl.hidden = YES;
//    }
//    
//    //密码
//    NSIndexPath * indexPathOfPassword = [NSIndexPath indexPathForRow:4 inSection:0];
//    LoginCell * cellPassword = (LoginCell *)[_tableView cellForRowAtIndexPath:indexPathOfPassword];
//    
//    _firstPassword = cellPassword.txtField.text;
//    if (![NSRegularExpression validatePassword:cellPassword.txtField.text]) {
//
//        [_rows replaceObjectAtIndex:4 withObject:@1];
//        cellPassword.remindLBl.text = @"密码无效,请重新填写";
//         [_remindMsgArr replaceObjectAtIndex:4 withObject:@"密码无效,请重新填写"];
//        cellPassword.remindLBl.hidden = NO;
//        hasNullOrWrong = YES;
//        
//    }else{
//        [_rows replaceObjectAtIndex:4 withObject:@0];
//        cellPassword.remindLBl.hidden = YES;
//    }
//    
//    //确认密码
//    NSIndexPath * indexPathOfConfirmPassword = [NSIndexPath indexPathForRow:6 inSection:0];
//    LoginCell * cellConfirmPassword = (LoginCell *)[_tableView cellForRowAtIndexPath:indexPathOfConfirmPassword];
//   
//    _password = cellConfirmPassword.txtField.text;
//    if (![cellConfirmPassword.txtField.text isEqualToString:_firstPassword]) {
//        [_rows replaceObjectAtIndex:6 withObject:@1];
//        cellConfirmPassword.remindLBl.text = @"两次密码输入不一致";
//        [_remindMsgArr replaceObjectAtIndex:6 withObject:@"两次密码输入不一致"];
//        cellConfirmPassword.remindLBl.hidden = NO;
//        hasWrong = YES;
//    }else{
//        [_rows replaceObjectAtIndex:6 withObject:@0];
//        cellConfirmPassword.remindLBl.hidden = YES;
//    }
//    if ([cellConfirmPassword.txtField.text isEqualToString:@""]||!cellConfirmPassword.txtField.text) {
//
//        [_rows replaceObjectAtIndex:6 withObject:@1];
//        cellConfirmPassword.remindLBl.text = @"确认密码为空";
//        [_remindMsgArr replaceObjectAtIndex:6 withObject:@"确认密码为空"];
//
//        cellConfirmPassword.remindLBl.hidden = NO;
//        hasWrong = YES;
//    }
//    
//    hasWrong =  hasNullOrWrong;
//    
//    [_tableView beginUpdates];
//    [_tableView reloadData];
//    [_tableView endUpdates];
//    
//    return hasNullOrWrong;
//
//}

//修改因为tablecell重用导致的问题
-(BOOL)checkVauleExistNullOrWrong
{
    
    BOOL hasNullOrWrong = NO;
    //手机号
    
    NSLog(@"1");
    _mobileNumber = _textValueArr[0];
    if (![NSRegularExpression validateMobile:_mobileNumber]) {
        [_rows replaceObjectAtIndex:0 withObject:@1];
        [_remindMsgArr replaceObjectAtIndex:0 withObject:@"手机号码无效"];
        hasNullOrWrong = YES;
    }else{
        [_rows replaceObjectAtIndex:0 withObject:@0];
    }
    
    
    
    //验证码
   
    NSString * vCode = _textValueArr[1];
    if (![vCode isEqualToString:_recordIdentifyCode]) {
        [_rows replaceObjectAtIndex:1 withObject:@1];
        if (vCode && ![vCode isEqualToString:@""]) {
            
            [_remindMsgArr replaceObjectAtIndex:1 withObject:@"验证码输入错误"];
        }
        hasNullOrWrong = YES;
    }else{
        [_rows replaceObjectAtIndex:1 withObject:@0];
    }
    
    //电子邮箱

    _email = _textValueArr[2];

    if (![NSRegularExpression validateEmail:_email]) {
        
        [_rows replaceObjectAtIndex:2 withObject:@1];
        [_remindMsgArr replaceObjectAtIndex:2 withObject:@"电子邮件地址无效"];
        _wrongEmailMsg = @"电子邮件地址无效";
        hasNullOrWrong = YES;
    }else{
        [_rows replaceObjectAtIndex:2 withObject:@0];
    }
    
    //密码
    _firstPassword = _textValueArr[4];
    if (![NSRegularExpression validatePassword:_firstPassword]) {
        
        [_rows replaceObjectAtIndex:4 withObject:@1];
        [_remindMsgArr replaceObjectAtIndex:4 withObject:@"密码无效"];
        hasNullOrWrong = YES;
        
    }else{
        [_rows replaceObjectAtIndex:4 withObject:@0];
    }
    
    //确认密码
    NSIndexPath * indexPathOfConfirmPassword = [NSIndexPath indexPathForRow:6 inSection:0];
    LoginCell * cellConfirmPassword = (LoginCell *)[_tableView cellForRowAtIndexPath:indexPathOfConfirmPassword];
    
    _password = _textValueArr[6];
    if (![cellConfirmPassword.txtField.text isEqualToString:_firstPassword]) {
        [_rows replaceObjectAtIndex:6 withObject:@1];
        [_remindMsgArr replaceObjectAtIndex:6 withObject:@"两次密码输入不一致"];
        hasWrong = YES;
    }else{
        [_rows replaceObjectAtIndex:6 withObject:@0];
    }
    if ([cellConfirmPassword.txtField.text isEqualToString:@""]||!cellConfirmPassword.txtField.text) {
        
        [_rows replaceObjectAtIndex:6 withObject:@1];
        cellConfirmPassword.remindLBl.text = @"确认密码为空";
        [_remindMsgArr replaceObjectAtIndex:6 withObject:@"确认密码为空"];
        
        cellConfirmPassword.remindLBl.hidden = NO;
        hasWrong = YES;
    }
    
    hasWrong =  hasNullOrWrong;
    
    [_tableView beginUpdates];
    [_tableView reloadData];
    [_tableView endUpdates];
    
    return hasNullOrWrong;
    
}


#pragma mark - ButtonMethods
- (IBAction)backToPreviewAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)checkBtnAction:(id)sender {
    UIButton * btn = (UIButton *)sender;
    if (isChecked == 1) {
        isChecked = 0;
        [btn setImage:[UIImage imageNamed:@"grayCheck.png"] forState:UIControlStateNormal];
    } else {
        isChecked = 1;
        [btn setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
    }
    
}


/**
 *  获取验证码
 *
 *  @param sender
 */
-(void)getIdentifyCode:(id)sender
{
    [_recordTxtField resignFirstResponder];
    NSLog(@"获取验证码......");
    
    _tableView.frame = CGRectMake(0, 44, 320, SCREEN_HEIGHT - 64);
    
    //手机号
    NSIndexPath * indexPathOfPhone = [NSIndexPath indexPathForRow:0 inSection:0];
    LoginCell * cell = (LoginCell *)[_tableView cellForRowAtIndexPath:indexPathOfPhone];
    [cell.txtField resignFirstResponder];
    _mobileNumber = cell.txtField.text;
    
    if (![NSRegularExpression validateMobile:cell.txtField.text]) {
        
        [_rows replaceObjectAtIndex:0 withObject:@1];
        [_remindMsgArr replaceObjectAtIndex:0 withObject:@"手机号不合法"];
        if (!cell.txtField.text || [cell.txtField.text isEqualToString:@""]) {
             [_remindMsgArr replaceObjectAtIndex:0 withObject:@"手机号为空"];
        }
        
        cell.remindLBl.hidden = NO;
        [_tableView beginUpdates];
        [_tableView reloadData];
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


- (IBAction)conditionBtnAction:(id)sender
{
    UserProtocolView *view = [UserProtocolView loadFromXib];
    [view showUserProtocolViewWithSuperView:self.view];
    
}

- (IBAction)registerBtnAction:(id)sender {

    [_recordTxtField resignFirstResponder];

    
    if([self checkVauleExistNullOrWrong]){
        return;
    }
    
    if (isChecked == 0) {
        [UIAlertView promptTipViewWithTitle:Nil message:@"您尚未同意条款&政策" cancelBtnTitle:@"确定" otherButtonTitles:Nil onDismiss:^(int buttonIndex) {
            
        } onCancel:^{
            
        }];
        return;
    }
    [self requestToRegister];
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
    if (_mobileNumber == nil || [_mobileNumber isEqualToString:@""]) {
        return;
    }
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:_mobileNumber forKey:@"userName"];
    [parameter setObject:AppSystemId forKey:@"brandCode"];

    [RegisterCodeRequest requestWithParameters:parameter
                                withIndicatorView:self.view
                                withCancelSubject:@"RegisterCodeRequest"
                                   onRequestStart:nil
                                onRequestFinished:^(ITTBaseDataRequest *request) {
                                    
                                    
                                    LoginCell * cell = [[_tableView visibleCells] firstObject];
                                    if ([request.handleredResult[@"status"] isEqualToString:@"-1"]) {
                                        [_rows removeObjectAtIndex:0];
                                        [_rows insertObject:@1 atIndex:0];
                                        cell.remindLBl.hidden = NO;
//                                        cell.remindLBl.text = request.handleredResult[@"messg"];
                                    
                                        [_remindMsgArr replaceObjectAtIndex:0 withObject:request.handleredResult[@"messg"]];
                                        [_tableView beginUpdates];
                                        [_tableView reloadData];
                                        [_tableView endUpdates];

                                    }
                                    if ([request isSuccess]) {
                                       
                                        NSLog(@"reslut = %@",request.handleredResult);
    
                                        _recordIdentifyCode = [NSString stringWithFormat:@"%@",request.handleredResult[@"data"][@"vcode"]];
                                        NSLog(@"_recordIdentifyCode = %@",_recordIdentifyCode);

                                        [self updateGetCodeBtn];
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

-(void)returnRootViewController
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 *  向服务器发送注册请求
 */
-(void)requestToRegister
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:_mobileNumber forKey:@"userName"];
    [parameter setObject:_email forKey:@"email"];
    [parameter setObject:_password forKey:@"password"];
    
    [RegisterRequest requestWithParameters:parameter
                             withIndicatorView:self.view
                             withCancelSubject:@"RegisterRequest"
                                onRequestStart:nil
                             onRequestFinished:^(ITTBaseDataRequest *request) {
                                 if ([request isSuccess]) {
                                     
                                     [[ActivityRemindView loadFromXib] showActivityViewInView:self.view withMsg:@"注册成功!" inSeconds:1.0];
                                     
                                     UserInfo *userInfo = DATA_ENV.userInfo;
                                     userInfo.userId = _mobileNumber;
                                     DATA_ENV.userInfo = userInfo;

                                     
                                     [UIView animateWithDuration:1.0 animations:^{
                                          [self performSelector:@selector(returnRootViewController) withObject:Nil afterDelay:1.0];
                                     }];
                                 }

                                 LoginCell * cell = [[_tableView visibleCells] firstObject];
                                 if ([request.handleredResult[@"status"] isEqualToString:@"-1"]) {
                                     NSString * wrongCode = request.handleredResult[@"data"][@"code"];
                                     int value = [wrongCode intValue];
                                     //手机号
                                     if (value == 9999) {
                                         [_rows removeObjectAtIndex:0];
                                         [_rows insertObject:@1 atIndex:0];
                                         cell.remindLBl.hidden = NO;
                                         cell.remindLBl.text = request.handleredResult[@"messg"];
                                     }
                                     
                                     //邮箱
                                     if (value == 3002) {
                                         [_rows removeObjectAtIndex:2];
                                         [_rows insertObject:@1 atIndex:2];
                                         _wrongEmailMsg =  request.handleredResult[@"messg"];
//                                         cell.remindLBl.hidden = NO;
                                         cell.remindLBl.text = _wrongEmailMsg;

                                        

                                     }
                                     [UIAlertView promptTipViewWithTitle:nil message:request.handleredResult[@"messg"] cancelBtnTitle:@"确定" otherButtonTitles:nil onDismiss:^(int buttonIndex) {
                                         
                                     } onCancel:^{
                                         
                                     }];
//                                        [_tableView beginUpdates];
//                                     [_tableView reloadData];
//                                     [_tableView endUpdates];
                                     
                                 }


                                 
                             } onRequestCanceled:nil
                               onRequestFailed:^(ITTBaseDataRequest *request) {
                                   NSLog(@"code failed");
                               }];

}


@end
