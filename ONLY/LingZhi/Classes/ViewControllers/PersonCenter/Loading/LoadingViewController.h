//
//  LoadingViewController.h
//  LingZhi
//
//  Created by feng on 14-8-12.
//
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"

#import "CustomTextField.h"

@interface LoadingViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *imagePhone;
@property (weak, nonatomic) IBOutlet UIImageView *imagePsd;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *topNavBar;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *psdField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

- (IBAction)buttonPressForLoading:(UIButton *)btn;

- (IBAction)textfieldPressForLoading:(UITextField *)field;

@end
