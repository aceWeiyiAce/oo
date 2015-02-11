//
//  CardBindingViewController.m
//  LingZhi
//
//  Created by feng on 14-8-11.
//
//

#import "CardBindingViewController.h"

#import "UserProtocolView.h"

#import "USEBaseRequest.h"

#import "NSRegularExpression+Addition.h"

#import "NoticeView.h"

#import "PromptView.h"

@interface CardBindingViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *conditionBtn;

@end

@implementation CardBindingViewController
{
    NSString *vcode;
    NoticeView *notice;
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
    [self drawLinesForLabel:self.labelLIine1];
    [self drawLinesForLabel:self.labelLine2];
    [self drawLinesForLabel:self.labelLine3];
    [self drawLinesForLabel:self.labelLine4];
    if (IOS7) {
        self.topView.frame = CGRectMake(0, 0, 320, 20);
    }else {
        self.topNavBar.frame = CGRectMake(0, 0, 320, 44);
    }
    changeNum = 60;
    self.cardAddView.frame = CGRectMake(0, Height, 320, SCREEN_HEIGHT-Height);
    
    _conditionBtn.selected = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [self hiddenKeyboard];
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - HiddenKeyboard
- (void)hiddenKeyboard
{
    [self.phoneTextfield resignFirstResponder];
    [self.numberTextfield resignFirstResponder];
    [self.psdTextfield resignFirstResponder];
    [self.surePsdTextfield resignFirstResponder];
    [UIView animateWithDuration:0.3f animations:^{
        self.cardAddView.frame = CGRectMake(0, Height, 320, SCREEN_HEIGHT-Height);

    }];
}

#pragma mark - TextFieldKeyboardPress
- (IBAction)hiddenKeyboardsForPress:(UITextField *)field
{
    [self hiddenKeyboard];
    if (field == self.phoneTextfield) {
        if (field.text.length == 0) {
            [notice makeViewShow:@"请输入手机号！"];
            return;
        }
        if (![NSRegularExpression validateMobile:self.phoneTextfield.text]) {
            [notice makeViewShow:@"手机号码不合法!"];
            return;
        }
    }
    if (field == self.numberTextfield) {
        if (self.phoneTextfield.text.length == 0) {
            [notice makeViewShow:@"请输入手机号！"];
            return;
        }
        if (![NSRegularExpression validateMobile:self.phoneTextfield.text]) {
            [notice makeViewShow:@"手机号码不合法!"];
            return;
        }
        if (![self.numberTextfield.text isEqualToString:vcode]) {
            [notice makeViewShow:@"验证码不正确!"];
            return;
        }
    }
    if (field == self.psdTextfield) {
        if (self.phoneTextfield.text.length == 0) {
            [notice makeViewShow:@"请输入手机号！"];
            return;
        }
        if (![NSRegularExpression validateMobile:self.phoneTextfield.text]) {
            [notice makeViewShow:@"手机号码不合法!"];
            return;
        }
        if (![self.numberTextfield.text isEqualToString:vcode]) {
            [notice makeViewShow:@"验证码不正确!"];
            return;
        }
        if (self.psdTextfield.text.length == 0) {
            [notice makeViewShow:@"请输入密码!"];
            return;
        }
        if (self.psdTextfield.text.length < 6 || self.psdTextfield.text.length > 12) {
            [notice makeViewShow:@"密码应为6-12的长度。"];
            return;
        }
    }
    if (field == self.surePsdTextfield) {
        if (self.phoneTextfield.text.length == 0) {
            [notice makeViewShow:@"请输入手机号！"];
            return;
        }
        if (![NSRegularExpression validateMobile:self.phoneTextfield.text]) {
            [notice makeViewShow:@"手机号码不合法!"];
            return;
        }
        if (![self.numberTextfield.text isEqualToString:vcode]) {
            [notice makeViewShow:@"验证码不正确!"];
            return;
        }
        if (self.psdTextfield.text.length == 0) {
            [notice makeViewShow:@"请输入密码!"];
            return;
        }
        if (self.psdTextfield.text.length < 6 || self.psdTextfield.text.length > 12) {
            [notice makeViewShow:@"密码应为6-12的长度。"];
            return;
        }
        if (![self.psdTextfield.text isEqualToString:self.surePsdTextfield.text]) {
            [notice makeViewShow:@"两次密码不一致!"];
            return;
        }
    }
}

#pragma mark - ButtonsPress
- (IBAction)buttonPressForCardBinding:(UIButton *)btn
{
    switch (btn.tag) {
        case 111:
            ///获取验证码
            [self getRequestForGetNumber];
            break;
        case 222:
        {
            UserProtocolView *view = [UserProtocolView loadFromXib];
            [view showUserProtocolViewWithSuperView:self.view];
        }
            ///条款政策
            break;
        case 555:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 125:
        {
            btn.selected = !btn.selected;
        }
            break;
        default:
            ///绑定实体卡
        {
            UIButton *choseBtn = ((UIButton *)[self.view viewWithTag:125]);
            if (choseBtn.selected) {
                [self getRequestForCardBing];
            }else {
                [notice makeViewShow:@"请先阅读\"条款&政策\""];
            }
        }
            break;
    }
}

- (void)getRequestForGetNumber
{
    [self.phoneTextfield resignFirstResponder];
    if (![NSRegularExpression validateMobile:self.phoneTextfield.text]) {
        [notice makeViewShow:@"手机号码不合法!"];
        return;
    }
    [self hiddenKeyboard];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.phoneTextfield.text forKey:@"loginName"];
    [dic setObject:AppSystemId forKey:@"brandCode"];
    NSLog(@"%@",dic);
    [USEBaseRequest requestWithParameters:dic
                        withIndicatorView:self.view
                        withCancelSubject:@"USEBaseRequest"
                           onRequestStart:nil
                        onRequestFinished:^(ITTBaseDataRequest *request) {
                            
                            NSLog(@"result = %@",request.handleredResult);
                            if ([[request.handleredResult objectForKey:@"status"] integerValue] == 0) {
                                NSDictionary *data = [request.handleredResult objectForKey:@"data"];
                                vcode = [data objectForKey:@"vcode"];
                                changeNum = 59;
                                timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(toChange) userInfo:nil repeats:YES];
                                [notice makeViewShow:@"验证码发送成功，请查收短信！"];
                                NSLog(@"success");
                                
                                //Write for test by pk at 20140902
//                                [notice makeViewShow:vcode];
                            }else {
                                
                                [notice makeViewShow:[request.handleredResult objectForKey:@"messg"]];
                                NSLog(@"error = %@",[request.handleredResult objectForKey:@"messg"]);
                            }
                            
                        } onRequestCanceled:nil
                          onRequestFailed:^(ITTBaseDataRequest *request) {
                              NSLog(@"code failed");
                              
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
    [self.getNumBtn setBackgroundColor:[UIColor grayColor]];
    changeNum --;
    [self.getNumBtn setUserInteractionEnabled:NO];
}

- (void)getRequestForCardBing
{
    if (self.phoneTextfield.text.length == 0) {
        [notice makeViewShow:@"请输入手机号!"];
        return;
    }
    if (![NSRegularExpression validateMobile:self.phoneTextfield.text]) {
        [notice makeViewShow:@"手机号码不合法!"];
        return;
    }
    if (![self.numberTextfield.text isEqualToString:vcode]) {
        [notice makeViewShow:@"验证码不正确!"];
        return;
    }
    if (self.psdTextfield.text.length == 0) {
        [notice makeViewShow:@"请输入密码!"];
        return;
    }
    if (self.psdTextfield.text.length < 6 || self.psdTextfield.text.length > 12) {
        [notice makeViewShow:@"密码应为6-12的长度。"];
        return;
    }
    if (![self.psdTextfield.text isEqualToString:self.surePsdTextfield.text]) {
        [notice makeViewShow:@"两次密码不一致!"];
        return;
    }
    [self hiddenKeyboard];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.phoneTextfield.text forKey:@"loginName"];
    [dic setObject:self.psdTextfield.text forKey:@"password"];
    NSLog(@"%@",dic);
    [CardBindingRequest requestWithParameters:dic
                        withIndicatorView:self.view
                        withCancelSubject:@"CardBindingRequest"
                           onRequestStart:nil
                        onRequestFinished:^(ITTBaseDataRequest *request) {
                            
                            NSLog(@"result = %@",request.handleredResult);
                            if ([[request.handleredResult objectForKey:@"status"] integerValue] == 0) {
                                PromptView *prompt = [[PromptView alloc] initWithFrame:self.view.frame];
                                [prompt PromptShow:@"绑定实体卡"
                                        andMessage:@"绑定实体卡成功!"
                                        andSupview:self.view];
                                
                                UserInfo *userInfo = DATA_ENV.userInfo;
                                userInfo.userId = self.phoneTextfield.text;
                                DATA_ENV.userInfo = userInfo;
                                [self performSelector:@selector(toBackHomepage) withObject:self afterDelay:2.0f];
                                NSLog(@"success");
                                
                                [[NSNotificationCenter defaultCenter] postNotificationName:KEY_SHOW_COMPLETEBTN object:nil];
                            }else {
                                
                                [notice makeViewShow:[request.handleredResult objectForKey:@"messg"]];
                                NSLog(@"error = %@",[request.handleredResult objectForKey:@"messg"]);
                            }
                            
                        } onRequestCanceled:nil
                          onRequestFailed:^(ITTBaseDataRequest *request) {
                              NSLog(@"code failed");
                              
                          }];
}

- (void)toBackHomepage
{
//    UIViewController *control = [self.navigationController.viewControllers objectAtIndex:(self.navigationController.viewControllers.count - 2)];
//    [self.navigationController popToViewController:control animated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSInteger height = 0;
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        if (textField == self.psdTextfield) {
            height = 63;
        }else if (textField == self.surePsdTextfield) {
            height = 100;
        }
        [UIView animateWithDuration:0.3f animations:^{
            self.cardAddView.frame = CGRectMake(0, Height-height, self.view.bounds.size.width, self.view.bounds.size.height);
//            if (IOS7) {
//                self.topView.frame = CGRectMake(0, height, self.topView.bounds.size.width, self.topView.bounds.size.height);
//                self.topNavBar.frame = CGRectMake(0, 20+height, self.topNavBar.bounds.size.width, self.topNavBar.bounds.size.height);
//            }else {
//                self.topView.frame = CGRectMake(0, height-20, self.topView.bounds.size.width, self.topView.bounds.size.height);
//                self.topNavBar.frame = CGRectMake(0, height, self.topNavBar.bounds.size.width, self.topNavBar.bounds.size.height);
//            }
            
        }];
    }
    
    
    if (textField == self.numberTextfield) {
        if (self.phoneTextfield.text.length == 0) {
            [notice makeViewShow:@"请输入手机号！"];
            return YES;
        }
        if (![NSRegularExpression validateMobile:self.phoneTextfield.text]) {
            [notice makeViewShow:@"手机号码不合法!"];
            return YES;
        }
    }
    if (textField == self.psdTextfield) {
        if (self.phoneTextfield.text.length == 0) {
            [notice makeViewShow:@"请输入手机号！"];
            return YES;
        }
        if (![NSRegularExpression validateMobile:self.phoneTextfield.text]) {
            [notice makeViewShow:@"手机号码不合法!"];
            return YES;
        }
        if (![self.numberTextfield.text isEqualToString:vcode]) {
            [notice makeViewShow:@"验证码不正确!"];
            return YES;
        }
    }
    if (textField == self.surePsdTextfield) {
        if (self.phoneTextfield.text.length == 0) {
            [notice makeViewShow:@"请输入手机号！"];
            return YES;
        }
        if (![NSRegularExpression validateMobile:self.phoneTextfield.text]) {
            [notice makeViewShow:@"手机号码不合法!"];
            return YES;
        }
        if (![self.numberTextfield.text isEqualToString:vcode]) {
            [notice makeViewShow:@"验证码不正确!"];
            return YES;
        }
        if (self.psdTextfield.text.length == 0) {
            [notice makeViewShow:@"请输入密码!"];
            return YES;
        }
        if (self.psdTextfield.text.length < 6 || self.psdTextfield.text.length > 12) {
            [notice makeViewShow:@"输入一个6-12位的密码！"];
            return YES;
        }
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.phoneTextfield) {
        if (textField.text.length == 0) {
            [notice makeViewShow:@"请输入手机号！"];
            return;
        }
        if (![NSRegularExpression validateMobile:self.phoneTextfield.text]) {
            [notice makeViewShow:@"手机号码不合法!"];
            return;
        }
    }
    if (textField == self.numberTextfield) {
        if (self.phoneTextfield.text.length == 0) {
            [notice makeViewShow:@"请输入手机号！"];
            return;
        }
        if (![NSRegularExpression validateMobile:self.phoneTextfield.text]) {
            [notice makeViewShow:@"手机号码不合法!"];
            return;
        }
        if (![self.numberTextfield.text isEqualToString:vcode]) {
            [notice makeViewShow:@"验证码不正确!"];
            return;
        }
    }
    if (textField == self.psdTextfield) {
        if (self.phoneTextfield.text.length == 0) {
            [notice makeViewShow:@"请输入手机号！"];
            return;
        }
        if (![NSRegularExpression validateMobile:self.phoneTextfield.text]) {
            [notice makeViewShow:@"手机号码不合法!"];
            return;
        }
        if (![self.numberTextfield.text isEqualToString:vcode]) {
            [notice makeViewShow:@"验证码不正确!"];
            return;
        }
        if (self.psdTextfield.text.length == 0) {
            [notice makeViewShow:@"请输入密码!"];
            return;
        }
        if (self.psdTextfield.text.length < 6 || self.psdTextfield.text.length > 12) {
            [notice makeViewShow:@"密码应为6-12的长度。"];
            return;
        }
    }
    if (textField == self.surePsdTextfield) {
        if (self.phoneTextfield.text.length == 0) {
            [notice makeViewShow:@"请输入手机号！"];
            return;
        }
        if (![NSRegularExpression validateMobile:self.phoneTextfield.text]) {
            [notice makeViewShow:@"手机号码不合法!"];
            return;
        }
        if (![self.numberTextfield.text isEqualToString:vcode]) {
            [notice makeViewShow:@"验证码不正确!"];
            return;
        }
        if (self.psdTextfield.text.length == 0) {
            [notice makeViewShow:@"请输入密码!"];
            return;
        }
        if (self.psdTextfield.text.length < 6 || self.psdTextfield.text.length > 12) {
            [notice makeViewShow:@"密码应为6-12的长度。"];
            return;
        }
        if (![self.psdTextfield.text isEqualToString:self.surePsdTextfield.text]) {
            [notice makeViewShow:@"两次密码不一致!"];
            return;
        }
    }

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self hiddenKeyboard];
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == self.phoneTextfield) {
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

@end
