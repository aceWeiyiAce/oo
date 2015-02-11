//
//  OnlyRegisterViewController.m
//  LingZhi
//
//  Created by feng on 14-8-13.
//
//

#import "OnlyRegisterViewController.h"

#import "NoticeView.h"

#import "UserProtocolView.h"

#import "NSRegularExpression+Addition.h"

#import "CompleteSelfInfomationController.h"

#import "JiuBaUrl.h"

#import "AFNetworking.h"

#import "JBshouyeViewController.h"

@interface OnlyRegisterViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *conditionBtn;
@property (nonatomic, assign) NSJSONReadingOptions readingOptions;
@property (nonatomic , retain) NSString *sid;
@property (nonatomic , retain) NSString *uid;
@property (nonatomic , retain) NSString *name;
@property (nonatomic , retain) NSString *phone;
@property (nonatomic , retain) NSString *birthday;
@property (nonatomic , retain) NSString *email;
@property (nonatomic , retain) NSString *adress;
@property (nonatomic , retain) NSString *sex;
@property (nonatomic , retain) NSString *work;

@end

@implementation OnlyRegisterViewController
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
    changeNum = 59;
    _conditionBtn.selected =  YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hiddenKeyboard];
    [super touchesBegan:touches withEvent:event];
}

- (void)hiddenKeyboard
{
    [self.phoneField resignFirstResponder];
    [self.numberField resignFirstResponder];
    [self.mailField resignFirstResponder];
    [self.psdSureField resignFirstResponder];
    [self.psdField resignFirstResponder];
    [self gobackDefault];
}

- (void)gobackDefault
{
    [UIView animateWithDuration:0.3f animations:^{
        self.scrollview.contentOffset = CGPointZero;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressForRegister:(UIButton *)btn
{
    switch (btn.tag) {
        case 333:
        {
            [self requestToGetVCode];
        }
            break;
        case 222:
        {
            UserProtocolView *view = [UserProtocolView loadFromXib];
            [view showUserProtocolViewWithSuperView:self.view];
        }
            break;
        case 111:
        {
//            UIButton *choseBtn = ((UIButton *)[self.view viewWithTag:125]);
//            if (choseBtn.selected) {
//                [self requestToRegister];
//            }else {
//                [notice makeViewShow:@"请先阅读\"条款&政策\""];
//            }
            [self requestToRegister];
        }
            break;
        case 125:
        {
            btn.selected = !btn.selected;
        }
            break;
        default:
            [self.navigationController popViewControllerAnimated:YES];
            break;
    }
}

- (IBAction)textfieldPressForRegister:(UITextField *)field
{
    [field resignFirstResponder];
    if (field == self.phoneField) {
        if (self.phoneField.text.length == 0) {
            [notice makeViewShow:@"请输入手机号！"];
            return;
        }
        if (![NSRegularExpression validateMobile:self.phoneField.text]) {
            [notice makeViewShow:@"手机号码不合法!"];
            return;
        }
    }
    if (field == self.numberField) {
        if (self.phoneField.text.length == 0) {
            [notice makeViewShow:@"请输入手机号！"];
            return;
        }
        if (![NSRegularExpression validateMobile:self.phoneField.text]) {
            [notice makeViewShow:@"手机号码不合法!"];
            return;
        }
        if (![self.numberField.text isEqualToString:@""]) {
            [notice makeViewShow:@"验证码不正确!"];
            return;
        }
    }
    if (field == self.mailField) {
        if (self.phoneField.text.length == 0) {
            [notice makeViewShow:@"请输入手机号！"];
            return;
        }
        if (![NSRegularExpression validateMobile:self.phoneField.text]) {
            [notice makeViewShow:@"手机号码不合法!"];
            return;
        }
        if (![self.numberField.text isEqualToString:@""]) {
            [notice makeViewShow:@"验证码不正确!"];
            return;
        }
        if (![NSRegularExpression validateEmail:self.mailField.text]) {
            [notice makeViewShow:@"邮箱不合法！"];
            return;
        }
    }
    if (field == self.psdField) {
        if (self.phoneField.text.length == 0) {
            [notice makeViewShow:@"请输入手机号！"];
            return;
        }
        if (![NSRegularExpression validateMobile:self.phoneField.text]) {
            [notice makeViewShow:@"手机号码不合法!"];
            return;
        }
        if (![self.numberField.text isEqualToString:@""]) {
            [notice makeViewShow:@"验证码不正确!"];
            return;
        }
        if (![NSRegularExpression validateEmail:self.mailField.text]) {
            [notice makeViewShow:@"邮箱不合法！"];
            return;
        }
        if (self.psdField.text.length == 0) {
            [notice makeViewShow:@"请输入密码！"];
            return;
        }
        if (self.psdField.text.length < 6 || self.psdField.text.length > 12) {
            [notice makeViewShow:@"输入一个6-12位的密码！"];
            return;
        }
    }
    if (field == self.psdSureField) {
        if (self.phoneField.text.length == 0) {
            [notice makeViewShow:@"请输入手机号！"];
            return;
        }
        if (![NSRegularExpression validateMobile:self.phoneField.text]) {
            [notice makeViewShow:@"手机号码不合法!"];
            return;
        }
        if (![self.numberField.text isEqualToString:@""]) {
            [notice makeViewShow:@"验证码不正确!"];
            return;
        }
        if (![NSRegularExpression validateEmail:self.mailField.text]) {
            [notice makeViewShow:@"邮箱不合法！"];
            return;
        }
        if (self.psdField.text.length == 0) {
            [notice makeViewShow:@"请输入密码！"];
            return;
        }
        if (self.psdField.text.length < 6 || self.psdField.text.length > 12) {
            [notice makeViewShow:@"输入一个6-12位的密码！"];
            return;
        }
        if (![self.psdField.text isEqualToString:self.psdSureField.text]) {
            [notice makeViewShow:@"两次密码不一致!"];
            return;
        }
    }
}

#pragma mark - TextfieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (textField == self.psdField) {
        
        if (is4InchScreen() == NO) {
            [UIView animateWithDuration:0.3f animations:^{
                self.scrollview.contentOffset = CGPointMake(0, 30);
            }];
        }
    }
    if (textField == self.psdSureField) {
        if (is4InchScreen()) {
            [UIView animateWithDuration:0.3f animations:^{
                self.scrollview.contentOffset = CGPointMake(0, 30);
            }];
        }else{
            [UIView animateWithDuration:0.3f animations:^{
                self.scrollview.contentOffset = CGPointMake(0, 115);
            }];
        }
        
    }
    
    if (textField == self.numberField) {
        if (self.phoneField.text.length == 0) {
            [notice makeViewShow:@"请输入手机号！"];
            return YES;
        }
        if (![NSRegularExpression validateMobile:self.phoneField.text]) {
            [notice makeViewShow:@"手机号码不合法!"];
            return YES;
        }
    }
    if (textField == self.mailField) {
        if (self.phoneField.text.length == 0) {
            [notice makeViewShow:@"请输入手机号！"];
            return YES;
        }
        if (![NSRegularExpression validateMobile:self.phoneField.text]) {
            [notice makeViewShow:@"手机号码不合法!"];
            return YES;
        }
        if (![self.numberField.text isEqualToString:@""]) {
            [notice makeViewShow:@"验证码不正确!"];
            return YES;
        }
    }
    if (textField == self.psdField) {
        if (self.phoneField.text.length == 0) {
            [notice makeViewShow:@"请输入手机号！"];
            return YES;
        }
        if (![NSRegularExpression validateMobile:self.phoneField.text]) {
            [notice makeViewShow:@"手机号码不合法!"];
            return YES;
        }
        if (![self.numberField.text isEqualToString:@""]) {
            [notice makeViewShow:@"验证码不正确!"];
            return YES;
        }
        if (![NSRegularExpression validateEmail:self.mailField.text]) {
            [notice makeViewShow:@"邮箱不合法！"];
            return YES;
        }
    }
    if (textField == self.psdSureField) {
        if (self.phoneField.text.length == 0) {
            [notice makeViewShow:@"请输入手机号！"];
            return YES;
        }
        if (![NSRegularExpression validateMobile:self.phoneField.text]) {
            [notice makeViewShow:@"手机号码不合法!"];
            return YES;
        }
        if (![self.numberField.text isEqualToString:@""]) {
            [notice makeViewShow:@"验证码不正确!"];
            return YES;
        }
        if (![NSRegularExpression validateEmail:self.mailField.text]) {
            [notice makeViewShow:@"邮箱不合法！"];
            return YES;
        }
        if (self.psdField.text.length == 0) {
            [notice makeViewShow:@"请输入密码！"];
            return YES;
        }
        if (self.psdField.text.length < 6 || self.psdField.text.length > 12) {
            [notice makeViewShow:@"输入一个6-12位的密码！"];
            return YES;
        }
    }
    return YES;
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.phoneField) {
        if (self.phoneField.text.length == 0) {
            [notice makeViewShow:@"请输入手机号！"];
            return;
        }
        if (![NSRegularExpression validateMobile:self.phoneField.text]) {
            [notice makeViewShow:@"手机号码不合法!"];
            return;
        }
    }
    if (textField == self.numberField) {
        if (self.phoneField.text.length == 0) {
            [notice makeViewShow:@"请输入手机号！"];
            return;
        }
        if (![NSRegularExpression validateMobile:self.phoneField.text]) {
            [notice makeViewShow:@"手机号码不合法!"];
            return;
        }
        if (![self.numberField.text isEqualToString:@""]) {
            [notice makeViewShow:@"验证码不正确!"];
            return;
        }
    }
    if (textField == self.mailField) {
        if (self.phoneField.text.length == 0) {
            [notice makeViewShow:@"请输入手机号！"];
            return;
        }
        if (![NSRegularExpression validateMobile:self.phoneField.text]) {
            [notice makeViewShow:@"手机号码不合法!"];
            return;
        }
        if (![self.numberField.text isEqualToString:@""]) {
            [notice makeViewShow:@"验证码不正确!"];
            return;
        }
        if (![NSRegularExpression validateEmail:self.mailField.text]) {
            [notice makeViewShow:@"邮箱不合法！"];
            return;
        }
    }
    if (textField == self.psdField) {
        if (self.phoneField.text.length == 0) {
            [notice makeViewShow:@"请输入手机号！"];
            return;
        }
        if (![NSRegularExpression validateMobile:self.phoneField.text]) {
            [notice makeViewShow:@"手机号码不合法!"];
            return;
        }
        if (![self.numberField.text isEqualToString:@""]) {
            [notice makeViewShow:@"验证码不正确!"];
            return;
        }
        if (![NSRegularExpression validateEmail:self.mailField.text]) {
            [notice makeViewShow:@"邮箱不合法！"];
            return;
        }
        if (self.psdField.text.length == 0) {
            [notice makeViewShow:@"请输入密码！"];
            return;
        }
        if (self.psdField.text.length < 6 || self.psdField.text.length > 12) {
            [notice makeViewShow:@"输入一个6-12位的密码！"];
            return;
        }
    }
    if (textField == self.psdSureField) {
        if (self.phoneField.text.length == 0) {
            [notice makeViewShow:@"请输入手机号！"];
            return;
        }
        if (![NSRegularExpression validateMobile:self.phoneField.text]) {
            [notice makeViewShow:@"手机号码不合法!"];
            return;
        }
        if (![self.numberField.text isEqualToString:@""]) {
            [notice makeViewShow:@"验证码不正确!"];
            return;
        }
        if (![NSRegularExpression validateEmail:self.mailField.text]) {
            [notice makeViewShow:@"邮箱不合法！"];
            return;
        }
        if (self.psdField.text.length == 0) {
            [notice makeViewShow:@"请输入密码！"];
            return;
        }
        if (self.psdField.text.length < 6 || self.psdField.text.length > 12) {
            [notice makeViewShow:@"输入一个6-12位的密码！"];
            return;
        }
        if (![self.psdField.text isEqualToString:self.psdSureField.text]) {
            [notice makeViewShow:@"两次密码不一致!"];
            return;
        }
    }

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self hiddenKeyboard];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == _phoneField) {
       
        NSUInteger lengthOfString = string.length;
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {//只允许数字输入
            unichar character = [string characterAtIndex:loopIndex];
            if (character < 65) return NO; // 48 unichar for 0
            if (character > 125) return NO; // 57 unichar for 9
        }
    
        // Check for total length
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 11)
            return NO;//限制长度
        else
            return YES;
    }
    return YES;
}


#pragma mark - request methods
/**
 *  给服务器发送请求，获取手机验证码
 *
 *  @return
 */
-(void)requestToGetVCode
{
    if (self.phoneField.text.length == 0) {
        [notice makeViewShow:@"请输入手机号！"];
        return;
    }
    if (![NSRegularExpression validateMobile:self.phoneField.text]) {
        [notice makeViewShow:@"手机号码不合法!"];
        return;
    }
    [self hiddenKeyboard];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:self.phoneField.text forKey:@"userName"];
    [parameter setObject:AppSystemId forKey:@"brandCode"];
    
    [RegisterCodeRequest requestWithParameters:parameter
                             withIndicatorView:self.view
                             withCancelSubject:@"RegisterCodeRequest"
                                onRequestStart:nil
                             onRequestFinished:^(ITTBaseDataRequest *request) {
                                 NSLog(@"reslut = %@",request.handleredResult);
                                 if ([request.handleredResult[@"status"] isEqualToString:@"-1"]) {
                                     
                                     [notice makeViewShow:[NSString stringWithFormat:@"%@",[request.handleredResult objectForKey:@"messg"]]];
                                 }
                                 if ([request isSuccess]) {
                                     
                                     [notice makeViewShow:@"验证码获取成功，请查收短信!"];
                                     NSDictionary *data = [request.handleredResult objectForKey:@"data"];
                                     vcode = [data objectForKey:@"vcode"];
                                     
                                     //Write for test by pk at 20140902
//                                     [notice makeViewShow:vcode];
                                     
                                     NSLog(@"success");
                                     changeNum = 59;
                                     timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(toChange) userInfo:nil repeats:YES];
                                 }
                                 
                             } onRequestCanceled:nil
                               onRequestFailed:^(ITTBaseDataRequest *request) {
                                   NSLog(@"code failed");
                                   [notice makeViewShow:@"网络有点慢，请检查网络！"];
                               }];
    
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

/**
 *  向服务器发送注册请求
 */
-(void)requestToRegister
{
    if (self.phoneField.text.length == 0) {
        [notice makeViewShow:@"请输入手机号！"];
        return;
    }
    if (![NSRegularExpression validateMobile:self.phoneField.text]) {
        [notice makeViewShow:@"手机号码不合法!"];
        return;
    }
    if (![self.numberField.text isEqualToString:@""]) {
        [notice makeViewShow:@"验证码不正确!"];
        return;
    }
    if (![NSRegularExpression validateEmail:self.mailField.text]) {
        [notice makeViewShow:@"邮箱不合法！"];
        return;
    }
    if (self.psdField.text.length == 0) {
        [notice makeViewShow:@"请输入密码！"];
        return;
    }
    if (self.psdField.text.length < 6 || self.psdField.text.length > 12) {
        [notice makeViewShow:@"输入一个6-12位的密码！"];
        return;
    }
    if (![self.psdField.text isEqualToString:self.psdSureField.text]) {
        [notice makeViewShow:@"两次密码不一致!"];
        return;
    }
    [self hiddenKeyboard];
    NSDictionary *parameter = @{@"name":self.phoneField.text,@"password":self.psdField.text,@"email":self.mailField.text};
    [[NSUserDefaults standardUserDefaults] setObject:self.psdField.text forKey:@"pwd"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:RegisterUrl]];
    
    NSURLRequest * request = [client requestWithMethod:@"POST"
                                                  path:nil
                                            parameters:parameter];
    AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:self.readingOptions error:nil];
        NSLog(@"%@",dic);
        NSDictionary *dictionary = dic[@"status"];
        NSInteger status = [[dictionary valueForKey:@"succeed"] integerValue];
        NSDictionary *dic1 = dic[@"data"];
        NSDictionary *dic2 = dic1[@"session"];
        _sid = dic2[@"sid"];
        _uid = dic2[@"uid"];
        NSDictionary *dic3 = dic1[@"user"];
        _name = dic3[@"user_name"];
        _email = dic3[@"email"];
        _birthday = dic3[@"birthday"];
        _sex = @"";
        _work = @"";
        _phone = @"";
        _adress = @"";
        if (status == 1) {
            NSLog(@"登陆成功");
            [[NSUserDefaults standardUserDefaults] setObject:_uid forKey:@"uid"];
            [[NSUserDefaults standardUserDefaults] setObject:_name forKey:@"name"];
            [[NSUserDefaults standardUserDefaults] setObject:_birthday forKey:@"birthday"];
            [[NSUserDefaults standardUserDefaults] setObject:_sex forKey:@"sex"];
            [[NSUserDefaults standardUserDefaults] setObject:_sid forKey:@"sid"];
            [[NSUserDefaults standardUserDefaults] setObject:_email forKey:@"email"];
            [[NSUserDefaults standardUserDefaults] setObject:_work forKey:@"work"];
            [[NSUserDefaults standardUserDefaults] setObject:_adress forKey:@"adress"];
            [[NSUserDefaults standardUserDefaults] setObject:_phone forKey:@"phone"];
            
            JBshouyeViewController *JBshouyeVC = [[JBshouyeViewController alloc]initWithNibName:@"JBshouyeViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:JBshouyeVC animated:YES];
            
        }else{
            NSLog(@"登陆失败  原因");
            
        }
        //            [self.LoginCollectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"faild , error == %@ ", error);
    }];
    
    [operation start];
    
}

- (void)returnRootViewController
{
    CompleteSelfInfomationController *com = [[CompleteSelfInfomationController alloc] init];
    com.detailInfo.loginName = self.phoneField.text;
    [self.navigationController pushViewController:com animated:YES];
}

@end
