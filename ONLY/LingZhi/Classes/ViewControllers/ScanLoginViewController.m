//
//  ScanLoginViewController.m
//  LingZhi
//
//  Created by MJ on 12/22/14.
//
//

#import "ScanLoginViewController.h"

@interface ScanLoginViewController ()
- (IBAction)backClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation ScanLoginViewController

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
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//返回
- (IBAction)backClick:(UIButton *)sender {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

//确认登录
- (IBAction)clickLogin:(UIButton *)sender {
    if(DATA_ENV.userInfo.userId.length < 1)
    {
        [UIAlertView promptTipViewWithTitle:@"提示" message:@"手机端尚未登录,请先登录手机端" cancelBtnTitle:@"确定" otherButtonTitles:nil onDismiss:^(int buttonIndex) {} onCancel:^{}];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    NSLog(@"%@---%@",[self.padunion class],[DATA_ENV.userInfo.userId class]);
    [param setObject:self.padunion forKey:@"padunion"];
    [param setObject:DATA_ENV.userInfo.userId forKey:@"loginName"];
    __weak typeof(self) weakSelf = self;
    self.loginButton.hidden = YES;
    [PadLoginRequest requestWithParameters:param
                                  withIndicatorView:self.view
                                  withCancelSubject:@"PadLoginRequest"
                                     onRequestStart:nil
                                  onRequestFinished:^(ITTBaseDataRequest *request) {
                                      if ([request isSuccess]) {
                                          ITTDPRINT(@"%@",request.handleredResult);
                                          NSString *message = request.handleredResult[@"messg"];
                                          ITTDPRINT(@"%@",message);
                                          if ([message isEqualToString:@"扫描登陆成功"] || [message isEqualToString:@"扫描登录成功"]) {
//
                                              [UIAlertView promptTipViewWithTitle:@"提示" message:message cancelBtnTitle:@"确定" otherButtonTitles:nil onDismiss:^(int buttonIndex) {
                                                  
                                              } onCancel:^{
//                                                  [weakSelf dismissModalViewControllerAnimated:YES];
                                                  [[UIApplication sharedApplication] setStatusBarHidden:NO];
                                                  [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                                              }];
                                          }
                                      }
                                  }
                                  onRequestCanceled:nil
                                    onRequestFailed:^(ITTBaseDataRequest *request) {
                                        
                                        
//                                        ITTDPRINT(@"%@",request.handleredResult);
                                        NSString *message = request.handleredResult[@"messg"];
//                                        ITTDPRINT(@"%@",message);
                                            [UIAlertView promptTipViewWithTitle:@"提示" message:message cancelBtnTitle:@"确定" otherButtonTitles:nil onDismiss:^(int buttonIndex) {
                                                
                                            } onCancel:^{
                                                weakSelf.loginButton.hidden = NO;
                                            }];
                                        
                                    }];}
//取消登录
- (IBAction)cancelLogin:(UIButton *)sender {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
}



@end
