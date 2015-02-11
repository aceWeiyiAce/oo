//
//  SubmitReturnsViewController.m
//  LingZhi
//
//  Created by apple on 14-8-22.
//
//

#import "SubmitReturnsViewController.h"
#import "PostCompanyModel.h"
#import "CustomError.h"


@interface SubmitReturnsViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    NSArray *pickerArray;
    BOOL isPickerShow;
    CustomError *_errorview;
}

@property (weak, nonatomic) IBOutlet UITextField *companyTextField;
@property (weak, nonatomic) IBOutlet UITextField *numTextField;
@property (weak, nonatomic) IBOutlet UIButton *determineBtn;
@property (strong, nonatomic) IBOutlet UIToolbar *doneTollBar;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *alertView;


- (IBAction)selectedButton:(id)sender;


@end

@implementation SubmitReturnsViewController

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
    _companyTextField.layer.borderColor = [[UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1.0]CGColor];
    _companyTextField.layer.borderWidth = 1.0;
    _numTextField.layer.borderColor = [[UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1.0]CGColor];
    _numTextField.layer.borderWidth = 1.0;
    _pickerView.frame = CGRectMake(0, self.view.height+_doneTollBar.height, _pickerView.width, _pickerView.height);
    _doneTollBar.frame = CGRectMake(0, self.view.height, _doneTollBar.width, _doneTollBar.height);
    isPickerShow = NO;
    [self requestToGetPostCompany];
    _errorview  = [CustomError loadFromXib];
    [_alertView addSubview:_errorview];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btn_backClicked:(id)sender
{    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)backgroundTouch:(id)sender
{
    [_numTextField resignFirstResponder];
    [self hiddenPicker];
}



- (IBAction)selectedButton:(id)sender
{
    [self didEndEditing];
    [self hiddenPicker];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [pickerArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    PostCompanyModel * model = pickerArray[row];
    return model.carrierName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    PostCompanyModel * model = pickerArray[row];
    _companyTextField.text =  model.carrierName;
}

- (IBAction)textFieldEditing:(id)sender
{
    if ([_numTextField isFirstResponder]) {
        [_numTextField resignFirstResponder];
        [self showPicker];
    }else{
        if (isPickerShow == YES) {
            [self hiddenPicker];
        }else{
            [self showPicker];
        }
    }
}

- (void)didEndEditing
{
    NSInteger row = [_pickerView selectedRowInComponent:0];
    PostCompanyModel * model = pickerArray[row];
    _companyTextField.text =  model.carrierName;
}

- (void)showPicker
{
    [UIView animateWithDuration:0.3 animations:^{
         _pickerView.frame = CGRectMake(0, self.view.height-_pickerView.height, _pickerView.width, _pickerView.height);
        _doneTollBar.frame = CGRectMake(0, self.view.height-_doneTollBar.height-_pickerView.height , _doneTollBar.width, _doneTollBar.height);
    }];
    isPickerShow = YES;
}

- (void)hiddenPicker
{
    [UIView animateWithDuration:0.3 animations:^{
        _pickerView.frame = CGRectMake(0, self.view.height+_doneTollBar.height, _pickerView.width, _pickerView.height);
        _doneTollBar.frame = CGRectMake(0, self.view.height, _doneTollBar.width, _doneTollBar.height);
    }];
    isPickerShow = NO;
}

- (IBAction)btn_sureCommitClicked:(id)sender
{
    if (_companyTextField.text.length == 0) {
        
        [ _errorview showErrorMsg:@"请选择您的快递公司"];
        
    }else{
        if (_numTextField.text.length == 0) {

            [_errorview showErrorMsg:@"请填写您的运单号"];

        }
        else{
            NSLog(@"可以上传了－－－－－－－－－－－－－－－－－");
        }
    }
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 0.0f, [pickerView rowSizeForComponent:component].width-12, [pickerView rowSizeForComponent:component].height)];
    PostCompanyModel *model = pickerArray[row];
    [label setText:model.carrierName];
    label.backgroundColor = [UIColor clearColor];
    [label setTextAlignment:NSTextAlignmentCenter];
    return label;
}

-(void)requestToGetPostCompany
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    pickerArray = nil;
    [RequestToGetPostCompany requestWithParameters:parameter
                                 withIndicatorView:self.view
                                 withCancelSubject:@"RequestToGetPostCompany"
                                    onRequestStart:nil
                                 onRequestFinished:^(ITTBaseDataRequest *request) {
                                     if ([request isSuccess]) {
                                         pickerArray =[NSArray arrayWithArray: request.handleredResult[@"keyModel"]];
                                         NSLog(@"array = %@",request.handleredResult[@"keyModel"]);
                                         [_pickerView reloadAllComponents];
                                         if ([_companyTextField.text isEqualToString:@""]) {
                                             PostCompanyModel * model = [pickerArray firstObject];
                                             _companyTextField.text = model.carrierName;
                                         }
                                     }
                                     
                                 } onRequestCanceled:nil
                                   onRequestFailed:^(ITTBaseDataRequest *request) {
                                       [UIAlertView promptTipViewWithTitle:Nil message:request.handleredResult[@"messg"] cancelBtnTitle:@"确定" otherButtonTitles:Nil onDismiss:^(int buttonIndex) {
                                           
                                       } onCancel:^{
                                           
                                       }];
                                   }];
}

@end
