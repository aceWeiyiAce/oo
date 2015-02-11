//
//  ForgetPsdViewController.h
//  LingZhi
//
//  Created by feng on 14-8-19.
//
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"

#import "CustomTextField.h"

@interface ForgetPsdViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *topNavBar;
@property (weak, nonatomic) IBOutlet CustomTextField *phoneNum;
@property (weak, nonatomic) IBOutlet CustomTextField *number;
@property (weak, nonatomic) IBOutlet CustomTextField *onePsd;
@property (weak, nonatomic) IBOutlet CustomTextField *surePsd;
@property (weak, nonatomic) IBOutlet UIButton *getNumBtn;

- (IBAction)buttonPressForForgetPsd:(UIButton *)btn;

- (IBAction)textfieldPressForForgetPsd:(UITextField *)field;

@end
