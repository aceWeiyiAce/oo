//
//  LoginViewController.m
//  LingZhi
//
//  Created by pk on 3/13/14.
//
//

#import "LoginViewController.h"
#import "NSRegularExpression+Addition.h"
#import "LoginCell.h"
#import "RegisterViewController.h"
#import "ReSetPasswordViewController.h"
#import "PKBaseRequest.h"
#import "ITTDataCacheManager.h"
#import "UserInfo.h"
#import "AddressViewController.h"

#define  MobileWrongRemindMsg    @"您输入的用户名不存在"
#define  PasswordWrongRemindMsg  @"您输入的密码与用户名不匹配"


@interface LoginViewController ()<UITextFieldDelegate,ReSetPasswordViewControllerDelegate>
{
    
    __weak IBOutlet UIView *_containsView;
    IBOutlet UITableView *_tableView;
    IBOutlet UIView *_imageView;
    IBOutlet UIView *_funtionView;
    
    IBOutlet UIButton *_loginBtn;
    NSMutableArray * _wrongArr;
    
    NSString * _userName;
    NSString * _pwd;
    
    UITextField * _recordLoginName;
    
}
@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _wrongArr  = [NSMutableArray arrayWithObjects:@0,@0, nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _tableView.tableHeaderView = _imageView;    
    _tableView.tableFooterView = _funtionView;
    //    [[NSNotificationCenter defaultCenter] addObserver:_loginBtn selector:@selector(enableLoginBtn) name:@"enableLoginBtn" object:Nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)showRemind


#pragma mark - tableViewDelegate datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"LoginCell";
    
    LoginCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [LoginCell loadFromXib];
    }
    if (indexPath.row == 0) {
        cell.txtField.placeholder = @"手机号";
        _recordLoginName = cell.txtField;
        
    }
    if (indexPath.row == 1) {
        cell.txtField.placeholder = @"密码";
        cell.txtField.keyboardType = UIKeyboardTypeWebSearch;
        cell.txtField.returnKeyType = UIReturnKeyGo;
        cell.txtField.secureTextEntry = YES;
//        [cell.txtField addTarget:self action:@selector(enableLoginBtn) forControlEvents:UIControlEventEditingChanged];
        
    }
    [cell.txtField addTarget:self action:@selector(enableLoginBtn) forControlEvents:UIControlEventEditingChanged];
    cell.txtField.delegate = self;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber * num = _wrongArr[indexPath.row];
    if ([num integerValue] == 1) {
        return loginCellWrongheight;
    }
    return loginCellNormalHeight;
}




-(void)enableLoginBtn
{
    
    NSIndexPath * indexPathOfAccount = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath * indexPathOfPass = [NSIndexPath indexPathForRow:1 inSection:0];
    
    LoginCell * cell = (LoginCell *)[_tableView cellForRowAtIndexPath:indexPathOfAccount];
    LoginCell * cellPass = (LoginCell *)[_tableView cellForRowAtIndexPath:indexPathOfPass];
    if (![cell.txtField.text isEqualToString:@""] && ![cellPass.txtField.text isEqualToString:@""]) {
        
        _loginBtn.enabled = YES;
        
    }else{
        _loginBtn.enabled = NO;
    }
}




#pragma mark - textFieldelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    NSIndexPath * indexPathOfPass = [NSIndexPath indexPathForRow:1 inSection:0];
    LoginCell * cell = (LoginCell *)[_tableView cellForRowAtIndexPath:indexPathOfPass];
    if (cell.txtField == textField && ![self hasNullOrWrongvalue]) {
        [self requestToLogin];
    }
    


    [textField resignFirstResponder];
//    _tableView.size = CGSizeMake(320, SCREEN_HEIGHT - 64);
    _tableView.frame = CGRectMake(0, 44, 320, SCREEN_HEIGHT - 64);
    
    return YES;
}




-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSIndexPath * indexPathOfAccount = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath * indexPathOfPass = [NSIndexPath indexPathForRow:1 inSection:0];
    
    LoginCell * cell = (LoginCell *)[_tableView cellForRowAtIndexPath:indexPathOfAccount];

    if (textField == cell.txtField) {
        NSLog(@"1");
        
        
    }
    LoginCell * cellPass = (LoginCell *)[_tableView cellForRowAtIndexPath:indexPathOfPass];
    if (cellPass.txtField == textField) {
        NSLog(@"2");
        textField.text = nil;
        _loginBtn.enabled = NO;
        
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



//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    NSIndexPath * indexPathOfAccount = [NSIndexPath indexPathForRow:0 inSection:0];
//    NSIndexPath * indexPathOfPass = [NSIndexPath indexPathForRow:1 inSection:0];
//    
//    LoginCell * cell = (LoginCell *)[_tableView cellForRowAtIndexPath:indexPathOfAccount];
//    //     CGRect tableRect = _tableView.frame;
//    if (textField == cell.txtField) {
//        NSLog(@"1");
//        _userName = textField.text;
//        if (![NSRegularExpression validateMobile:textField.text]) {
//            [_wrongArr removeObjectAtIndex:0];
//            [_wrongArr insertObject:@1 atIndex:0];
//            cell.remindLBl.text = MobileWrongRemindMsg;
//            cell.remindLBl.hidden = NO;
//        }
//        else{
//            [_wrongArr removeObjectAtIndex:0];
//            [_wrongArr insertObject:@0 atIndex:0];
//            cell.remindLBl.hidden = YES;
//        }
//        
//    }
//    LoginCell * cellPass = (LoginCell *)[_tableView cellForRowAtIndexPath:indexPathOfPass];
//    if (cellPass.txtField == textField) {
//        NSLog(@"2");
//        if (!textField.text || [textField.text isEqualToString:@""]) {
//            [_wrongArr removeObjectAtIndex:1];
//            [_wrongArr insertObject:@1 atIndex:1];
//            cellPass.remindLBl.hidden = NO;
//            cellPass.remindLBl.text = PasswordWrongRemindMsg;
//        }else{
//            [_wrongArr removeObjectAtIndex:1];
//            [_wrongArr insertObject:@0 atIndex:1];
//            cellPass.remindLBl.hidden = YES;
//        }
//        
//        _pwd = textField.text;
//        
//    }
//    [_tableView beginUpdates];
//    [_tableView reloadData];
//    [_tableView endUpdates];
//}

/**
 *  检查必填项是否为空
 *
 *  @return BOOL
 */
-(BOOL)hasNullOrWrongvalue
{
    
    BOOL hasWrong = NO;
    
    NSIndexPath * indexPathOfAccount = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath * indexPathOfPass = [NSIndexPath indexPathForRow:1 inSection:0];
    
    LoginCell * cell = (LoginCell *)[_tableView cellForRowAtIndexPath:indexPathOfAccount];
    _userName = cell.txtField.text;
    if (![NSRegularExpression validateMobile:cell.txtField.text]) {
        [_wrongArr replaceObjectAtIndex:0 withObject:@1];
        cell.remindLBl.text = @"手机号不合法";
        cell.remindLBl.hidden = NO;
        hasWrong = YES;
    }
    else{
        [_wrongArr replaceObjectAtIndex:0 withObject:@0];
        cell.remindLBl.hidden = YES;
    }
        
    
    LoginCell * cellPass = (LoginCell *)[_tableView cellForRowAtIndexPath:indexPathOfPass];
    _pwd = cellPass.txtField.text ;
    if (![NSRegularExpression validatePassword:cellPass.txtField.text ]) {
        [_wrongArr replaceObjectAtIndex:1 withObject:@1];
        cellPass.remindLBl.hidden = NO;
        cellPass.remindLBl.text = @"无效密码";
        hasWrong = YES;

    }
    else{
        [_wrongArr replaceObjectAtIndex:1 withObject:@0];
        cellPass.remindLBl.hidden = YES;
    }
        
    [_tableView beginUpdates];
    [_tableView reloadData];
    [_tableView endUpdates];

    return hasWrong;
 
}

#pragma mark - buttonMethods


- (IBAction)backToPreviewAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)loginAction:(id)sender {
    
    _tableView.frame = CGRectMake(0, 44, 320, SCREEN_HEIGHT - 64);
    
    NSLog(@"登录中......");
    
    if ([self hasNullOrWrongvalue]) {
        return;
    }

    [self requestToLogin];
}



- (IBAction)wantToRegisterAction:(id)sender {
    NSLog(@"我要注册....");
    
    RegisterViewController * registerVc = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVc animated:YES];
    
}

- (IBAction)forgetPasswordAction:(id)sender {
    NSLog(@"忘记密码....");
    ReSetPasswordViewController * resetVc = [[ReSetPasswordViewController alloc] init];
    resetVc.delegate = self;
    [self.navigationController pushViewController:resetVc animated:YES];
}

-(void)updateMobileNumber:(NSString *)mobile
{
    _recordLoginName.text = mobile;
}

/**
 *  向服务器发送登陆请求
 */
-(void)requestToLogin
{
    
    _loginBtn.enabled = NO;
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:_userName forKey:@"userName"];
    [parameter setObject:_pwd forKey:@"password"];
    
    [LoginRequest requestWithParameters:parameter
                      withIndicatorView:self.view
                      withCancelSubject:@"LoginRequest"
                         onRequestStart:nil
                      onRequestFinished:^(ITTBaseDataRequest *request) {
                          if ([request isSuccess]) {
                              
                              NSLog(@"reslut = %@",request.handleredResult);
                              
                              if ([request.handleredResult[@"status"] isEqualToString:@"0"]) {
                                  
                                  UserInfo *userInfo = DATA_ENV.userInfo;
                                  userInfo.userId = request.handleredResult[@"data"][@"phoneno"];
                                  DATA_ENV.userInfo = userInfo;
                                  
                                  [self pushCustomViewController];
//                                  [self.navigationController popToRootViewControllerAnimated:YES];
                                  [self getAddressListRequest];
                              }

                              
                          }else{
                              NSLog(@"sfsdfsf");
                              NSString * errorCode = request.handleredResult[@"data"][@"code"];
                              //1000 用户不存在    1001 密码不正确
                              if ([errorCode isEqualToString:@"1000"]) {
                                  
                                  LoginCell * cell = (LoginCell *)[[_tableView visibleCells] objectAtIndex:0];
                                  [_wrongArr replaceObjectAtIndex:0 withObject:@1];
                                  cell.remindLBl.text = MobileWrongRemindMsg;
                                  cell.remindLBl.hidden = NO;
                              }
                              if ([errorCode isEqualToString:@"1001"]) {
                                  LoginCell * cell = (LoginCell *)[[_tableView visibleCells] objectAtIndex:1];
                                  [_wrongArr replaceObjectAtIndex:1 withObject:@1];
                                  cell.remindLBl.text = PasswordWrongRemindMsg;
                                  cell.remindLBl.hidden = NO;
                              }
                              [_tableView beginUpdates];
                              [_tableView reloadData];
                              [_tableView endUpdates];
                          }
                          
                      } onRequestCanceled:nil
                        onRequestFailed:^(ITTBaseDataRequest *request) {
                            NSLog(@"code failed");
                        }];
    
}

- (void)pushCustomViewController
{
    if (_controllerName && _controllerName.length>0) {
        if ([_controllerName isEqualToString:@"AddressViewController"]) {
            AddressViewController * address = [[AddressViewController alloc]init];
            address.isAddressEdit = NO;
            [self.navigationController pushViewController:address animated:YES];
        } else {
            Class viewController = NSClassFromString(_controllerName);
            id customViewController = [[viewController alloc]init];
            [self.navigationController pushViewController:customViewController animated:YES];
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


- (void)getAddressListRequest
{
    
    
    NSMutableArray * addressArray = [[NSMutableArray alloc]init];
    
    NSDictionary *paramter = [NSDictionary dictionaryWithObjectsAndKeys:DATA_ENV.userInfo.userId,@"loginName", nil];
    [getAddressListRequest requestWithParameters:paramter
                               withIndicatorView:self.view
                               withCancelSubject:@"getAddressListRequest"
                                  onRequestStart:nil
                               onRequestFinished:^(ITTBaseDataRequest *request) {
                                   if ([request isSuccess]) {
                                       [addressArray addObjectsFromArray:request.handleredResult[@"keyModel"]];
                                       [self dataCacheDefaultAddress:addressArray]; //设置默认地址
                                   }
                               }
                               onRequestCanceled:nil
                                 onRequestFailed:^(ITTBaseDataRequest *request) {
                                     
                                 }];
}

- (void)dataCacheDefaultAddress:(NSMutableArray *)address     //设置默认地址
{
    for (AddressModel *model in address) {
        if ([model.isDefault isEqualToString:@"1"]) {
            AddressModel *address = DATA_ENV.address;
            address = model;
            DATA_ENV.address = address;
        }
    }

}

@end
