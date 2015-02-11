//
//  ChangePsdViewController.m
//  LingZhi
//
//  Created by feng on 14-8-20.
//
//

#import "ChangePsdViewController.h"

#import "NoticeView.h"

@interface ChangePsdViewController ()<UITextFieldDelegate>

@end

@implementation ChangePsdViewController
{
    NoticeView *notice;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressForPsdChange:(UIButton *)btn
{
    if (btn.tag == 999) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self requestToUpdatePassword];
    }
}

- (IBAction)textfieldPressForPsdChange:(UITextField *)field
{
    if (field == self.oldPsd) {
        if (self.oldPsd.text.length == 0) {
            [notice makeViewShow:@"请输入旧密码！"];
            return;
        }
    }
    if (field == self.nePsdOne) {
        if (self.oldPsd.text.length == 0) {
            [notice makeViewShow:@"请输入旧密码！"];
            return;
        }
        if (self.nePsdOne.text.length == 0) {
            [notice makeViewShow:@"请输入新密码!"];
            return;
        }
        if (self.nePsdOne.text.length < 6 || self.nePsdOne.text.length > 12) {
            [notice makeViewShow:@"输入一个6-12位的密码！"];
            return;
        }
    }
    if (field == self.nePsdTwo) {
        [self checkAllPsdText];
    }
    [field resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.nePsdOne) {
        if (self.oldPsd.text.length == 0) {
            [notice makeViewShow:@"请输入旧密码！"];
            return YES;
        }
    }
    if (textField == self.nePsdTwo) {
        if (self.oldPsd.text.length == 0) {
            [notice makeViewShow:@"请输入旧密码！"];
            return YES;
        }
        if (self.nePsdOne.text.length == 0) {
            [notice makeViewShow:@"请输入新密码!"];
            return YES;
        }
        if (self.nePsdOne.text.length < 6 || self.nePsdOne.text.length > 12) {
            [notice makeViewShow:@"输入一个6-12位的密码！"];
            return YES;
        }
    }
    return YES;
}

- (void)checkAllPsdText
{
    if (self.oldPsd.text.length == 0) {
        [notice makeViewShow:@"请输入旧密码！"];
        return;
    }
    if (self.nePsdOne.text.length == 0) {
        [notice makeViewShow:@"请输入新密码!"];
        return;
    }
    if (self.nePsdOne.text.length < 6 || self.nePsdOne.text.length > 12) {
        [notice makeViewShow:@"输入一个6-12位的密码！"];
        return;
    }
    if (![self.nePsdOne.text isEqualToString:self.nePsdTwo.text]) {
        [notice makeViewShow:@"两次密码不一致！"];
        return;
    }
}

-(void)requestToUpdatePassword
{
    if (self.oldPsd.text.length == 0) {
        [notice makeViewShow:@"请输入旧密码！"];
        return;
    }
    if (self.nePsdOne.text.length == 0) {
        [notice makeViewShow:@"请输入新密码!"];
        return;
    }
    if (self.nePsdOne.text.length < 6 || self.nePsdOne.text.length > 12) {
        [notice makeViewShow:@"输入一个6-12位的密码！"];
        return;
    }
    if (![self.nePsdOne.text isEqualToString:self.nePsdTwo.text]) {
        [notice makeViewShow:@"两次密码不一致！"];
        return;
    }
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:DATA_ENV.userInfo.userId forKey:@"userName"];
    [parameter setObject:self.oldPsd.text forKey:@"oldPassword"];
    [parameter setObject:self.nePsdOne.text forKey:@"newPassword"];
    
    [loginToUpdatePasswordRequest requestWithParameters:parameter
                                      withIndicatorView:self.view
                                      withCancelSubject:@"loginToUpdatePasswordRequest"
                                         onRequestStart:nil
                                      onRequestFinished:^(ITTBaseDataRequest *request) {
                                          
                                          if ([request isSuccess]) {
                                              
                                              NSLog(@"reslut = %@",request.handleredResult);
                                              
                                              if ([request.handleredResult[@"status"] isEqualToString:@"0"]) {
                                                  
                                                  [[ActivityRemindView loadFromXib] showActivityViewInView:self.view withMsg:@"修改成功!" inSeconds:1.0];
                                                  
                                                  
                                                  [self performSelector:@selector(backtoPrePage) withObject:nil afterDelay:1.0];
                                                  
                                              }
                                              
                                          }else{
                                              NSString * errorMsg = request.handleredResult[@"data"][@"message"];
                                              [notice makeViewShow:errorMsg];
                                          }
                                          
                                      } onRequestCanceled:nil
                                        onRequestFailed:^(ITTBaseDataRequest *request) {
                                            NSLog(@"request = %@",request);
                                            NSLog(@"code failed");
                                        }];
    
    
}

-(void)backtoPrePage
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
