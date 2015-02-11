//
//  LoadingViewController.m
//  LingZhi
//
//  Created by feng on 14-8-12.
//
//

#import "LoadingViewController.h"

#import "CardBindingViewController.h"

#import "OnlyRegisterViewController.h"

#import "NoticeView.h"

#import "NSRegularExpression+Addition.h"

#import "ReSetPasswordViewController.h"

#import "PromptView.h"

#import "UIImage-Helpers.h"

#import "ForgetPsdViewController.h"

#import "JiuBaUrl.h"

#import "AFNetworking.h"

#import "JBshouyeViewController.h"

@interface LoadingViewController ()<ReSetPasswordViewControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *loginTopImage;
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

@implementation LoadingViewController
{
    NoticeView *notice;
    UIButton *phoneBtn;
    UIButton *psdBtn;
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

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad
{
    NSLog(@"%d",Height);
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self drawLinesForLabel:self.imagePhone];
    [self drawLinesForLabel:self.imagePsd];
    if (IOS7) {
        self.topView.frame = CGRectMake(0, 0, 320, 20);
    }else {
        self.topNavBar.frame = CGRectMake(0, 0, 320, 44);
    }
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        [self.scrollview setFrame:CGRectMake(0, Height, 320, 416)];
    }else {
        [self.scrollview setFrame:CGRectMake(0, Height, 320, 504)];
    }
    [self.scrollview setContentSize:CGSizeMake(320, 568)];
    
    self.loginTopImage.image = [_loginTopImage.image blurredImage:.8];
    
    phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneBtn.frame = CGRectMake(0, 0, 40, 40);
    [phoneBtn addTarget:self action:@selector(deleteSelfText) forControlEvents:UIControlEventTouchUpInside];
    [phoneBtn setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    phoneBtn.imageEdgeInsets = UIEdgeInsetsMake(13,18,13,8);
    self.phoneField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.phoneField.rightView addSubview:phoneBtn];
    self.phoneField.rightViewMode = UITextFieldViewModeWhileEditing;
    [self.phoneField addTarget:self action:@selector(textHadLength) forControlEvents:UIControlEventAllEvents];
    
    psdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    psdBtn.frame = CGRectMake(0, 0, 40, 40);
    [psdBtn addTarget:self action:@selector(deletePsdText) forControlEvents:UIControlEventTouchUpInside];
    [psdBtn setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    psdBtn.imageEdgeInsets = UIEdgeInsetsMake(13,18,13,8);
    self.psdField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.psdField.rightView addSubview:psdBtn];
    self.psdField.rightViewMode = UITextFieldViewModeWhileEditing;
    [self.psdField addTarget:self action:@selector(textPsdHadLength) forControlEvents:UIControlEventAllEvents];
}

-(void)deleteSelfText
{
    self.phoneField.text = @"";
    phoneBtn.hidden = YES;
}

-(void)textHadLength
{
    if (self.phoneField.text.length>0) {
        phoneBtn.hidden = NO;
    }else{
        phoneBtn.hidden = YES;
    }
}

-(void)deletePsdText
{
    self.psdField.text = @"";
    psdBtn.hidden = YES;
}

-(void)textPsdHadLength
{
    if (self.psdField.text.length>0) {
        psdBtn.hidden = NO;
    }else{
        psdBtn.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.phoneField resignFirstResponder];
    [self.psdField resignFirstResponder];
    [super touchesBegan:touches withEvent:event];
    if (self.phoneField.text.length == 0) {
        [notice makeViewShow:@"请输入用户名"];
        return;
    }
    if (![NSRegularExpression validateMobile:self.phoneField.text]) {
        [notice makeViewShow:@"用户名不合法!"];
        return;
    }
}

- (IBAction)buttonPressForLoading:(UIButton *)btn
{
    switch (btn.tag) {
        case 111:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 222:
            [self requestToLogin];
            break;
        case 333:
        {
            OnlyRegisterViewController *registe = [[OnlyRegisterViewController alloc] init];
            [self.navigationController pushViewController:registe animated:YES];
        }
            break;
        case 444:
            ///忘记密码
        {
            ForgetPsdViewController *forget = [[ForgetPsdViewController alloc] init];
            [self.navigationController pushViewController:forget animated:YES];
        }
            break;
        default:
        {
            CardBindingViewController *card = [[CardBindingViewController alloc] init];
            [self.navigationController pushViewController:card animated:YES];
        }
            break;
    }
}

- (IBAction)textfieldPressForLoading:(UITextField *)field
{
    [field resignFirstResponder];
    if (self.phoneField.text.length == 0) {
        [notice makeViewShow:@"请输入用户名"];
        return;
    }
    if (![NSRegularExpression validateMobile:self.phoneField.text]) {
        [notice makeViewShow:@"用户名不合法!"];
        return;
    }
    if (field == self.psdField) {
        if (field.text.length == 0) {
            [notice makeViewShow:@"请输入密码!"];
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (SCREEN_HEIGHT == 480.f) {
        [self.scrollview setContentOffset:CGPointMake(0, 90) animated:YES];
    }
    if (textField == self.psdField) {
        if (self.phoneField.text.length == 0) {
            [notice makeViewShow:@"请输入用户名"];
            return YES;
        }
        if (![NSRegularExpression validateMobile:self.phoneField.text]) {
            [notice makeViewShow:@"用户名不合法!"];
            return YES;
        }
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _phoneField) {
        if (self.phoneField.text.length == 0) {
            [notice makeViewShow:@"请输入用户名"];
        }
        else if (![NSRegularExpression validateMobile:self.phoneField.text]) {
            [notice makeViewShow:@"用户名不合法!"];
        }
    }
    if (textField == _psdField) {
        if (textField.text.length == 0) {
            [notice makeViewShow:@"请输入密码!"];
        }
    }
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == _phoneField) {
        
        NSUInteger lengthOfString = string.length;
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {//只允许数字输入
            unichar character = [string characterAtIndex:loopIndex];
            if (character < 65) return NO; // 48 unichar for 0
            if (character > 122) return NO; // 57 unichar for 9
        }
        
        // Check for total length
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 11) return NO;//限制长度
        return YES;
    }
    return YES;
}


-(void)updateMobileNumber:(NSString *)mobile
{
    self.phoneField.text = mobile;
}

/**
 *  向服务器发送登陆请求
 */
-(void)requestToLogin
{
    if (self.phoneField.text.length == 0) {
        [notice makeViewShow:@"请输入用户名"];
        return;
    }
    if (![NSRegularExpression validateMobile:self.phoneField.text]) {
        [notice makeViewShow:@"用户名不合法!"];
        return;
    }
    if (self.psdField.text.length == 0) {
        [notice makeViewShow:@"请输入密码"];
        return;
    }
    if (self.psdField.text.length < 2 || self.psdField.text.length > 12) {
        [notice makeViewShow:@"请输入2至12位的密码"];
        return;
    }
    
    NSDictionary *parameter = @{@"name":self.phoneField.text,@"password":self.psdField.text};
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:LoginUrl]];
    [[NSUserDefaults standardUserDefaults] setObject:self.psdField.text forKey:@"pwd"];
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

- (void)toBackHomePage
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
