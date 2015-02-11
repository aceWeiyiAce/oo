//
//  OnlyRegisterViewController.h
//  LingZhi
//
//  Created by feng on 14-8-13.
//
//

#import <UIKit/UIKit.h>

#import "CustomTextField.h"

#import "BaseViewController.h"

@interface OnlyRegisterViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *topNavBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet CustomTextField *phoneField;
@property (weak, nonatomic) IBOutlet CustomTextField *numberField;
@property (weak, nonatomic) IBOutlet CustomTextField *mailField;
@property (weak, nonatomic) IBOutlet CustomTextField *psdField;
@property (weak, nonatomic) IBOutlet CustomTextField *psdSureField;
@property (weak, nonatomic) IBOutlet UIButton *getNumBtn;

- (IBAction)buttonPressForRegister:(UIButton *)btn;

- (IBAction)textfieldPressForRegister:(UITextField *)field;

@end
