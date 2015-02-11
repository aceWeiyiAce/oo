//
//  CardBindingViewController.h
//  LingZhi
//
//  Created by feng on 14-8-11.
//
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"

#import "CustomTextField.h"

@interface CardBindingViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *labelLIine1;
@property (weak, nonatomic) IBOutlet UILabel *labelLine2;
@property (weak, nonatomic) IBOutlet UILabel *labelLine3;
@property (weak, nonatomic) IBOutlet UILabel *labelLine4;
@property (weak, nonatomic) IBOutlet CustomTextField *phoneTextfield;
@property (weak, nonatomic) IBOutlet CustomTextField *numberTextfield;
@property (weak, nonatomic) IBOutlet CustomTextField *psdTextfield;
@property (weak, nonatomic) IBOutlet CustomTextField *surePsdTextfield;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *topNavBar;
@property (weak, nonatomic) IBOutlet UIButton *getNumBtn;
@property (strong, nonatomic) IBOutlet UIView *cardAddView;

- (IBAction)hiddenKeyboardsForPress:(UITextField *)field;

- (IBAction)buttonPressForCardBinding:(UIButton *)btn;

@end
