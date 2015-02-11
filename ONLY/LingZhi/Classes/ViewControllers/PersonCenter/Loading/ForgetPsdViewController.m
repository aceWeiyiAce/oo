//
//  ForgetPsdViewController.m
//  LingZhi
//
//  Created by feng on 14-8-19.
//
//

#import "ForgetPsdViewController.h"

#import "NoticeView.h"

#import "NSRegularExpression+Addition.h"

@interface ForgetPsdViewController ()<UITextFieldDelegate>

@end

@implementation ForgetPsdViewController
{
    NoticeView *notice;
    NSString *vcode;
    NSInteger changeNum;
    NSTimer *timer;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        notice = [[NoticeView alloc] initWithFrame:CGRectMake(0, Height, 320, 0) andView:self.view];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (IOS7) {
        self.topView.frame = CGRectMake(0, 0, 320, 20);
    }else {
        self.topNavBar.frame = CGRectMake(0, 0, 320, 44);
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.number) {
        if (self.phoneNum.text.length == 0) {
            [notice makeViewShow:@"请输入手机号!"];
            return YES;
        }
        if (![NSRegularExpression validateMobile:self.phoneNum.text]) {
            [notice makeViewShow:@"手机号码不合法!"];
            return YES;
        }
    }
    if (textField == self.onePsd) {
        if (self.phoneNum.text.length == 0) {
            [notice makeViewShow:@"请输入手机号!"];
            return YES;
        }
        if (![NSRegularExpression validateMobile:self.phoneNum.text]) {
            [notice makeViewShow:@"手机号码不合法!"];
            return YES;
        }
        if (![self.number.text isEqualToString:vcode]) {
            [notice makeViewShow:@"验证码错误！"];
            return YES;
        }
    }
    if (textField == self.surePsd) {
        if (self.phoneNum.text.length == 0) {
            [notice makeViewShow:@"请输入手机号!"];
            return YES;
        }
        if (![NSRegularExpression validateMobile:self.phoneNum.text]) {
            [notice makeViewShow:@"手机号码不合法!"];
            return YES;
        }
        if (![self.number.text isEqualToString:vcode]) {
            [notice makeViewShow:@"验证码错误！"];
            return YES;
        }
        if (self.onePsd.text.length == 0) {
            [notice makeViewShow:@"请输入密码！"];
            return YES;
        }
        if (self.onePsd.text.length < 6 || self.onePsd.text.length > 12) {
            [notice makeViewShow:@"输入一个6-12位的密码！"];
            return YES;
        }
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == self.number) {
        if (self.phoneNum.text.length == 0) {
            [notice makeViewShow:@"请输入手机号!"];
            return YES;
        }
        if (![NSRegularExpression validateMobile:self.phoneNum.text]) {
            [notice makeViewShow:@"手机号码不合法!"];
            return YES;
        }
    }
    if (textField == self.onePsd) {
        if (self.phoneNum.text.length == 0) {
            [notice makeViewShow:@"请输入手机号!"];
            return YES;
        }
        if (![NSRegularExpression validateMobile:self.phoneNum.text]) {
            [notice makeViewShow:@"手机号码不合法!"];
            return YES;
        }
        if (![self.number.text isEqualToString:vcode]) {
            [notice makeViewShow:@"验证码错误！"];
            return YES;
        }
    }
    if (textField == self.surePsd) {
        if (self.phoneNum.text.length == 0) {
            [notice makeViewShow:@"请输入手机号!"];
            return YES;
        }
        if (![NSRegularExpression validateMobile:self.phoneNum.text]) {
            [notice makeViewShow:@"手机号码不合法!"];
            return YES;
        }
        if (![self.number.text isEqualToString:vcode]) {
            [notice makeViewShow:@"验证码错误！"];
            return YES;
        }
        if (self.onePsd.text.length == 0) {
            [notice makeViewShow:@"请输入密码！"];
            return YES;
        }
        if (self.onePsd.text.length < 6 || self.onePsd.text.length > 12) {
            [notice makeViewShow:@"输入一个6-12位的密码！"];
            return YES;
        }
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == self.phoneNum) {
        
        NSUInteger lengthOfString = string.length;
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {//只允许数字输入
            unichar character = [string characterAtIndex:loopIndex];
            if (character < 48) return NO; // 48 unichar for 0
            if (character > 57) return NO; // 57 unichar for 9
        }
        
        // Check for total length
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 11) return NO;//限制长度
        return YES;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkFieldInfor
{
    if (self.phoneNum.text.length == 0) {
        [notice makeViewShow:@"请输入手机号!"];
        return;
    }
    if (![NSRegularExpression validateMobile:self.phoneNum.text]) {
        [notice makeViewShow:@"手机号码不合法!"];
        return;
    }
    if (![self.number.text isEqualToString:vcode]) {
        [notice makeViewShow:@"验证码错误！"];
        return;
    }
    if (self.onePsd.text.length == 0) {
        [notice makeViewShow:@"请输入密码！"];
        return;
    }
    if (self.onePsd.text.length < 6 || self.onePsd.text.length > 12) {
        [notice makeViewShow:@"输入一个6-12位的密码！"];
        return;
    }
    if (![self.onePsd.text isEqualToString:self.surePsd.text]) {
        [notice makeViewShow:@"两次密码不一样！"];
        return;
    }
}

- (IBAction)buttonPressForForgetPsd:(UIButton *)btn
{
    switch (btn.tag) {
        case 111:
            [self requestToUpdatePassword];
            break;
        case 333:
            [self requestToGetVCode];
            break;
        default:
            [self.navigationController popViewControllerAnimated:YES];
            break;
    }
}

- (IBAction)textfieldPressForForgetPsd:(UITextField *)field
{
    [field resignFirstResponder];
    if (field == self.phoneNum) {
        if (self.phoneNum.text.length == 0) {
            [notice makeViewShow:@"请输入手机号!"];
            return;
        }
        if (![NSRegularExpression validateMobile:self.phoneNum.text]) {
            [notice makeViewShow:@"手机号码不合法!"];
            return;
        }
    }
    if (field == self.number) {
        if (self.phoneNum.text.length == 0) {
            [notice makeViewShow:@"请输入手机号!"];
            return;
        }
        if (![NSRegularExpression validateMobile:self.phoneNum.text]) {
            [notice makeViewShow:@"手机号码不合法!"];
            return;
        }
        if (![self.number.text isEqualToString:vcode]) {
            [notice makeViewShow:@"验证码错误！"];
            return;
        }
    }
    if (field == self.onePsd) {
        if (self.phoneNum.text.length == 0) {
            [notice makeViewShow:@"请输入手机号!"];
            return;
        }
        if (![NSRegularExpression validateMobile:self.phoneNum.text]) {
            [notice makeViewShow:@"手机号码不合法!"];
            return;
        }
        if (![self.number.text isEqualToString:vcode]) {
            [notice makeViewShow:@"验证码错误！"];
            return;
        }
        if (self.onePsd.text.length == 0) {
            [notice makeViewShow:@"请输入密码！"];
            return;
        }
        if (self.onePsd.text.length < 6 || self.onePsd.text.length > 12) {
            [notice makeViewShow:@"输入一个6-12位的密码！"];
            return;
        }
    }
    if (field == self.surePsd) {
        [self checkFieldInfor];
    }
}

- (void)toChange
{
    if (changeNum == 0) {
        [self.getNumBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        [self.getNumBtn setBackgroundColor:[UIColor blackColor]];
        [self.getNumBtn setUserInteractionEnabled:YES];
        [timer invalidate];
        return;
    }
    [self.getNumBtn setTitle:[NSString stringWithFormat:@"%d秒后重新获取",changeNum] forState:UIControlStateNormal];
    changeNum --;
    [self.getNumBtn setBackgroundColor:[UIColor grayColor]];
    [self.getNumBtn setUserInteractionEnabled:NO];
}

#pragma mark - request methods
/**
 *  给服务器发送请求，获取手机验证码
 *
 *  @return
 */
-(void)requestToGetVCode
{
    if (self.phoneNum.text.length == 0) {
        [notice makeViewShow:@"请输入手机号!"];
        return;
    }
    if (![NSRegularExpression validateMobile:self.phoneNum.text]) {
        [notice makeViewShow:@"手机号码不合法!"];
        return;
    }
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:self.phoneNum.text forKey:@"userName"];
    [parameter setObject:AppSystemId forKey:@"brandCode"];
    
    [ForgetPassToGetCodeRequest requestWithParameters:parameter
                                    withIndicatorView:self.view
                                    withCancelSubject:@"ForgetPassToGetCodeRequest"
                                       onRequestStart:nil
                                    onRequestFinished:^(ITTBaseDataRequest *request) {

                                        if ([request.handleredResult[@"status"] isEqualToString:@"-1"]) {
                                            
                                            [notice makeViewShow:request.handleredResult[@"messg"]];
                                            
                                        }
                                        if ([request isSuccess]) {
                                            
                                            NSLog(@"reslut = %@",request.handleredResult);
                                            [notice makeViewShow:@"获取验证码成功，请查看短信！"];
                                            NSDictionary *data = [request.handleredResult objectForKey:@"data"];
                                            vcode = [data objectForKey:@"vcode"];
                                            changeNum = 59;
                                            timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(toChange) userInfo:nil repeats:YES];
                                        }
                                        
                                    } onRequestCanceled:nil
                                      onRequestFailed:^(ITTBaseDataRequest *request) {
                                          NSLog(@"code failed");
                                          
                                      }];
}

-(void)requestToUpdatePassword
{
    if (self.phoneNum.text.length == 0) {
        [notice makeViewShow:@"请输入手机号!"];
        return;
    }
    if (![NSRegularExpression validateMobile:self.phoneNum.text]) {
        [notice makeViewShow:@"手机号码不合法!"];
        return;
    }
    if (![self.number.text isEqualToString:vcode]) {
        [notice makeViewShow:@"验证码错误！"];
        return;
    }
    if (self.onePsd.text.length == 0) {
        [notice makeViewShow:@"请输入密码！"];
        return;
    }
    if (self.onePsd.text.length < 6 || self.onePsd.text.length > 12) {
        [notice makeViewShow:@"输入一个6-12位的密码！"];
        return;
    }
    if (![self.onePsd.text isEqualToString:self.surePsd.text]) {
        [notice makeViewShow:@"两次密码不一样！"];
        return;
    }
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:self.phoneNum.text forKey:@"userName"];
    [parameter setObject:self.onePsd.text forKey:@"password"];
    
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
