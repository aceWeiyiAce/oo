//
//  GuidBinderViewController.m
//  LingZhi
//
//  Created by kping on 14-8-13.
//
//

#import "GuidBinderViewController.h"
#import "BindSuccessViewController.h"
#import "CustomTextField.h"
#import "CustomError.h"
#import "PKBaseRequest.h"

#define kAlphaNum   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@interface GuidBinderViewController ()<UITextFieldDelegate>
{
    NSString * _shopId;
    NSString * _workerId;
    CustomError * _error;
}

@property (weak, nonatomic) IBOutlet UIView   *contentView;
@property (weak, nonatomic) IBOutlet UILabel  *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel  *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel  *rightLabel;
@property (weak, nonatomic) IBOutlet CustomTextField *shopIdTxt;
@property (weak, nonatomic) IBOutlet CustomTextField *workIdTxt;



@property (weak, nonatomic) IBOutlet UIButton *bindBtn;
@property (weak, nonatomic) IBOutlet UIView *containsErrorView;


@end

@implementation GuidBinderViewController

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
    // Do any additional setup after loading
    _error = [CustomError loadFromXib];
    [_containsErrorView addSubview:_error];
    _workIdTxt.alwaysShowStr = @"DA";
}


#pragma mark -ButtonMethods

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)bindOrderAction:(id)sender {
    NSLog(@"订单绑定。。。。。。。");
    
    BindSuccessViewController * bindVc = [[BindSuccessViewController alloc] init];
    [self.navigationController pushViewController:bindVc animated:YES];
    
    BOOL isRight = YES;
    if (_shopIdTxt.text.length<4) {
        [_error showErrorMsg:@"店铺ID不能少于4位"];
        isRight = NO;
    }
    if (_workIdTxt.text.length <10) {
        [_error showErrorMsg:@"导购ID不能少于10位"];
        isRight = NO;
    }
    if (isRight) {
        [self requestToBinderOrder];
    }
    
}


#pragma mark -UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _workIdTxt) {
        _workIdTxt.text = @"DA";
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self autoEnabledBindBtn];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _shopIdTxt) {
        if (_shopIdTxt.text.length<4) {
            [_error showErrorMsg:@"店铺ID不能少于4位"];
        }
    }
    if (textField == _workIdTxt) {
        if (_workIdTxt.text.length <10) {
            [_error showErrorMsg:@"导购ID不能少于10位"];
        }
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == _workIdTxt) {
       
        NSUInteger lengthOfString = string.length;
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {//只允许数字输入
            unichar character = [string characterAtIndex:loopIndex];
            if (character < 48) return NO; // 48 unichar for 0
            if (character > 57) return NO; // 57 unichar for 9
        }
        
        // Check for total length
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 10 || proposedNewLength<2) return NO;//限制长度
        return YES;
    }
    if (textField == _shopIdTxt) {
   
        //判断是否超过 ACCOUNT_MAX_CHARS  个字符,注意要判断当string.leng>0
        //的情况才行，如果是删除的时候，string.length==0
        int length = textField.text.length;
        if (length >= 4  &&  string.length >0)
        {
            return  NO;
        }
        
        
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
        NSString *filtered =
        [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic = [string isEqualToString:filtered];
        return basic;
    }
    return YES;
}

-(void)autoEnabledBindBtn
{
    BOOL enabled = YES;
    if (_shopIdTxt.text.length < 4) {
        enabled = NO;
       
    }
    if (_workIdTxt.text.length <10) {
        
        enabled = NO;
    }
    _bindBtn.enabled = enabled;
    if (_bindBtn.isEnabled) {
        _bindBtn.backgroundColor = [UIColor blackColor];
    }else{
        _bindBtn.backgroundColor = [UIColor lightGrayColor];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)requestToBinderOrder
{
    
//    orderNumber	必选	String	订单号
//    shopID	    必选	String	店铺编号
//    guideID	    必选	String	导购ID
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    [parameter setObject:_orderNumber forKey:@"orderNumber"];
    [parameter setObject:_shopIdTxt.text forKey:@"shopID"];
    [parameter setObject:_workIdTxt.text forKey:@"guideID"];
    
    __weak GuidBinderViewController * controller = self;
    [RequestToAddGuidBinder requestWithParameters:parameter
                            withIndicatorView:self.view
                            withCancelSubject:@"RequestToAddGuidBinder"
                               onRequestStart:nil
                            onRequestFinished:^(ITTBaseDataRequest *request) {
                                if ([request isSuccess]) {
                                    if ([request.handleredResult[@"status"] isEqualToString:@"0"]) {
                                        BindSuccessViewController * bindSuccessVc = [[BindSuccessViewController alloc] init];
                                        bindSuccessVc.orderNum = _orderNumber;
                                        bindSuccessVc.guidName = _workIdTxt.text;
                                        [controller.navigationController pushViewController:bindSuccessVc animated:YES];
                                    }
                                }
                                
                                
                            } onRequestCanceled:nil
                              onRequestFailed:^(ITTBaseDataRequest *request) {
                                  NSLog(@"request = %@",request.handleredResult);
                              }];
}


@end
