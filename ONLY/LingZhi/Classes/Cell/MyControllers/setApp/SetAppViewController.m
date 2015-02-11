//
//  SetAppViewController.m
//  JiuBa
//
//  Created by iFangSoft on 15/2/9.
//
//

#import "SetAppViewController.h"
#import "ChangePasswordViewController.h"
#import "AbutOurViewController.h"
#import "AgreementViewController.h"
#import "LoadingViewController.h"

@interface SetAppViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userPhoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *userEmailLabel;

@end

@implementation SetAppViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.userNameLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"name"];
    self.userPhoneNumberLabel.text = [[NSUserDefaults standardUserDefaults]stringForKey:@"phone"];
    self.userEmailLabel.text = [[NSUserDefaults standardUserDefaults]stringForKey:@"email"];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)changePasswordAction:(id)sender {
    ChangePasswordViewController *changePWDVC = [[ChangePasswordViewController alloc]initWithNibName:@"ChangePasswordViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:changePWDVC animated:YES];
}
- (IBAction)AbutAppAction:(id)sender {
    AbutOurViewController *abutVC = [[AbutOurViewController alloc]initWithNibName:@"AbutOurViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:abutVC animated:YES];
}
- (IBAction)AgreementAction:(id)sender {
    AgreementViewController *agreementVC = [[AgreementViewController alloc]initWithNibName:@"AgreementViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:agreementVC animated:YES];
}
- (IBAction)UpDataButtonAction:(id)sender {
}
- (IBAction)OutUserButtonAction:(id)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey: @"uid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey: @"name"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey: @"birthday"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey: @"sex"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey: @"sid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey: @"email"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey: @"work"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey: @"adress"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey: @"phone"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pwd"];
    
    LoadingViewController *loadVC = [[LoadingViewController alloc]initWithNibName:@"LoadingViewController" bundle:[NSBundle mainBundle]];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loadVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
