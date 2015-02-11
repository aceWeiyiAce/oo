//
//  ChangePsdViewController.h
//  LingZhi
//
//  Created by feng on 14-8-20.
//
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"

#import "CustomTextField.h"

@interface ChangePsdViewController : BaseViewController

@property (weak, nonatomic) IBOutlet CustomTextField *oldPsd;
@property (weak, nonatomic) IBOutlet CustomTextField *nePsdOne;
@property (weak, nonatomic) IBOutlet CustomTextField *nePsdTwo;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *topNavBar;

- (IBAction)buttonPressForPsdChange:(UIButton *)btn;

- (IBAction)textfieldPressForPsdChange:(UITextField *)field;

@end
