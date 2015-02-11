//
//  AddAddressViewController.h
//  LingZhi
//
//  Created by feng on 14-8-22.
//
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"

#import "CustomTextField.h"

@interface AddAddressViewController : BaseViewController

@property (weak, nonatomic) IBOutlet CustomTextField *nameField;
@property (weak, nonatomic) IBOutlet CustomTextField *addressField;
@property (weak, nonatomic) IBOutlet UITextField *provField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UITextField *regionField;
@property (weak, nonatomic) IBOutlet CustomTextField *postcodeField;
@property (weak, nonatomic) IBOutlet CustomTextField *phoneField;
@property (strong, nonatomic) IBOutlet UIView *upPickerview;

- (IBAction)textfieldPressForAddress:(UITextField *)field;

- (IBAction)buttonPressForAddress:(UIButton *)btn;

@end
