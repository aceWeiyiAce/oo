//
//  CompleteSelfInfomationController.m
//  LingZhi
//
//  Created by kping on 14-8-12.
//
//

#import "CompleteSelfInfomationController.h"
#import "CustomDatePicker.h"
#import "CustomTextField.h"
#import "LoginViewController.h"
#import "PKBaseRequest.h"
#import "CustomError.h"

@interface CompleteSelfInfomationController ()<CustomDatePickerDelegate,UITextFieldDelegate>
{
    NSString * _name;
    NSString * _birthDay;

    CustomDatePicker * _datePicker;
    CustomError * _error;
    CGFloat _recordContainsViewTop;
    BOOL isPageFirstAppear;
    
    NSString * sex;
}

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *stateView;
@property (weak, nonatomic) IBOutlet UIView *containsDateView;
@property (weak, nonatomic) IBOutlet CustomTextField *nameTxt;
@property (weak, nonatomic) IBOutlet CustomTextField *birthDayTxt;
@property (weak, nonatomic) IBOutlet UIButton *birthDayBtn;
@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;
@property (weak, nonatomic) IBOutlet UIButton *becomeVipBtn;
@property (weak, nonatomic) IBOutlet UIView *containsErrorView;
@property (weak, nonatomic) IBOutlet UIButton *runOverBtn;



@end

@implementation CompleteSelfInfomationController

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
    // Do any additional setup after loading the view from its nib.
    [_mainView sendSubviewToBack:_contentView];
    _datePicker = [[CustomDatePicker alloc] initWithFrame:self.containsDateView.bounds];
    _datePicker.delegate = self;
    [_containsDateView addSubview:_datePicker];
    _error = [CustomError loadFromXib];
    [_containsErrorView addSubview:_error];
    [self.view bringSubviewToFront:_containsErrorView];
    [self requestToGetUserDetailInfo];
}

-(void)fillContent
{
    if (_detailInfo) {
        _nameTxt.text     = _detailInfo.realName;
        _birthDayTxt.text = _detailInfo.birthday;
        
    }
    
    if (_detailInfo.sex.length>0) {
        if ([_detailInfo.sex isEqualToString:@"0"]) {
            _femaleBtn.selected = YES;
            _manBtn.selected    = NO;
            sex                 = @"0";
        }else{
            _femaleBtn.selected = NO;
            _manBtn.selected    = YES;
            sex                 = @"1";
        }
        [_becomeVipBtn setTitle:@"保 存" forState:UIControlStateNormal];
        _birthDayBtn.enabled = NO;
    }else{
        _femaleBtn.selected = YES;
        _manBtn.selected    = NO;
        sex                 = @"0";
    }
    if (self.isShowSaveText) {
        _runOverBtn.hidden = YES;

    }
    _contentView.hidden = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    if (!isPageFirstAppear) {
        _recordContainsViewTop    = _containsDateView.top;
        _datePicker.hideTopHeight = _mainView.height;
        _containsDateView.top     = GET_VIEW_HEIGHT(_contentView);
        _datePicker.hideTopHeight = _mainView.height;
        _containsDateView.top     = GET_VIEW_HEIGHT(_contentView);
        isPageFirstAppear         = YES;
    }
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)becomeVipAction:(id)sender {
    if (![self judgeTextFieldIsRightOrNot]) {
        return;
    }
    
//    BOOL isRgiht = YES;
//    if (![_nameTxt.text length]>0) {
//        isRgiht = NO;
//        [_error showErrorMsg:@"姓名不能为空"];
//    }
//    
//    if (![_birthDayTxt.text length]>0) {
//        [_error showErrorMsg:@"生日不能为空"];
//        isRgiht = NO;
//    }
//    if (isRgiht) {
//        [self requestToBecomeVip];
//    }
     [self requestToBecomeVip];
}

- (IBAction)femaleBtnAction:(id)sender {
    _femaleBtn.selected = YES;
    _manBtn.selected    = NO;
    sex                 = @"0";
    
//    GuidBinderViewController * bindVC = [[GuidBinderViewController alloc] init];
//    [self.navigationController pushViewController:bindVC animated:YES];
}

- (IBAction)manBtnAction:(id)sender {
    _manBtn.selected    = YES;
    sex                 = @"1";
    _femaleBtn.selected = NO;
}


- (IBAction)birthDayBtnAction:(id)sender {
    [_nameTxt resignFirstResponder];
    if (_containsDateView.top == _recordContainsViewTop) {
        return;
    }

    [self showDatePickView];
    _containsDateView.hidden = NO;
    [UIView animateWithDuration:.3f animations:^{
        
        _containsDateView.top = _recordContainsViewTop;
    }];
}

- (IBAction)jumpAction:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)showDatePickView
{
    CGFloat heihgt = _contentView.height - _birthDayTxt.superview.bottom;
    NSLog(@"heihgt = %f",heihgt);
    if (heihgt - 275<0) {
        
        double temp = fabs(heihgt - 275);
        [UIView animateWithDuration:0.3 animations:^{
            _contentView.top =  - temp;
            _containsDateView.top = _recordContainsViewTop;
        }];
    }else{
        if (IOS7) {
            [UIView animateWithDuration:0.3 animations:^{
                _contentView.top = 44;
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                _contentView.top = 44;
            }];
        }
        
    }
}
-(void)hideDatePickView
{
    if (_containsDateView.top == _recordContainsViewTop) {
        [UIView animateWithDuration:0.3f animations:^{
            _contentView.top = 44;
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(BOOL)judgeTextFieldIsRightOrNot
{
    BOOL isRgiht = YES;
    if (![_nameTxt.text length]>0) {
        isRgiht = NO;
        [_error showErrorMsg:@"姓名不能为空"];
        return isRgiht;
    }
    
    if (![_birthDayTxt.text length]>0) {
         [_error showErrorMsg:@"生日不能为空"];
         isRgiht = NO;
    }
    return isRgiht;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (_containsDateView.top == _recordContainsViewTop) {
        [self hideDatePickView];
        [UIView animateWithDuration:0.3 animations:^{
            _containsDateView.top = SCREEN_HEIGHT;
        } completion:^(BOOL finished) {
            
        }];
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _nameTxt) {
        if (textField.text.length<1) {
            [_error showErrorMsg:@"姓名不能为空"];
        }
        if ([textField.text lengthOfBytesUsingEncoding:NSUTF8StringEncoding]>20) {
            [_error showErrorMsg:@"姓名限制20字符以内"];
        }
        _name = _nameTxt.text;
    }
    if (textField == _birthDayTxt) {
        if (textField.text.length<1) {
            [_error showErrorMsg:@"生日不能为空"];
        }
        _birthDay = _birthDayTxt.text;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark -CustomDatePickerDelegate
-(void)getBirthDay:(NSString *)birth
{
    _birthDayTxt.text = birth;
    _birthDay = birth;
    [self hideDatePickView];
}

-(void)cancelInput
{
    if (_contentView.top != 44) {
        [self hideDatePickView];
    }
}

#pragma mark - requestMothod

-(void)requestToGetUserDetailInfo
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:DATA_ENV.userInfo.userId forKey:@"loginName"];
    [RequestToFindMemberInfo requestWithParameters:parameter
                                 withIndicatorView:self.view
                                 withCancelSubject:@"RequestToFindMemberInfo"
                                    onRequestStart:nil
                                 onRequestFinished:^(ITTBaseDataRequest *request) {
                                     if ([request isSuccess]) {
                                         _detailInfo = request.handleredResult[@"model"];
                                         
                                         [self fillContent];
                                     }
                                 }
                                 onRequestCanceled:nil
                                   onRequestFailed:^(ITTBaseDataRequest *request) {
                                       
                                   }];
    
}



-(void)requestToBecomeVip
{
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    [parameter setObject:DATA_ENV.userInfo.userId forKey:@"loginName"];
    [parameter setObject:_nameTxt.text forKey:@"realName"];
    [parameter setObject:sex forKey:@"sex"];
    [parameter setObject:_birthDayTxt.text forKey:@"birthday"];
    
    __weak CompleteSelfInfomationController * controller = self;
    
    [RequestToaddMember requestWithParameters:parameter
                             withIndicatorView:self.view
                             withCancelSubject:@"RequestToaddMember"
                                onRequestStart:nil
                             onRequestFinished:^(ITTBaseDataRequest *request) {
                                 if ([request isSuccess]) {
                                     if ([request.handleredResult[@"status"] isEqualToString:@"0"]) {
                                         [controller.navigationController popToRootViewControllerAnimated:YES];
                                     }
                                 }
                                 
                                 
                             } onRequestCanceled:nil
                               onRequestFailed:^(ITTBaseDataRequest *request) {
                                   
                               }];
    
}

@end
