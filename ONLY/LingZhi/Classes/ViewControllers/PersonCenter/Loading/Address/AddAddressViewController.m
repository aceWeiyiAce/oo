//
//  AddAddressViewController.m
//  LingZhi
//
//  Created by feng on 14-8-22.
//
//

#import "AddAddressViewController.h"

@interface AddAddressViewController ()<UITextFieldDelegate>

@end

@implementation AddAddressViewController

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
    self.provField.inputView = self.upPickerview;
    self.cityField.inputView = self.upPickerview;
    self.regionField.inputView = self.upPickerview;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (IBAction)textfieldPressForAddress:(UITextField *)field
{
    [field resignFirstResponder];
}

- (IBAction)buttonPressForAddress:(UIButton *)btn
{
    if (btn.tag == 111) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        ////保存
    }
}

@end
