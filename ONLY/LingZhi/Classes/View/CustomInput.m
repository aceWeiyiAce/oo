//
//  CustomInput.m
//  LingZhi
//
//  Created by kping on 14-8-12.
//
//

#import "CustomInput.h"


@interface CustomInput ()<UITextFieldDelegate>
{
    NSString * _strContent;
    
}

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end

@implementation CustomInput

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    _textField.layer.borderWidth = 1.0;
    _textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    _textField.leftViewMode = UITextFieldViewModeAlways;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)deleteTextAction:(id)sender {
    _strContent = @"";
    self.textField.text = @"";
    if ([_delegate respondsToSelector:@selector(textInputValue:sender:)]) {
        [_delegate textInputValue:_strContent sender:self];
    }
}





-(NSString *)inputText
{
    return _strContent;
}

-(UIView *)getTheTopestSuperView
{
    UIView * sup = [self superview];
    if (sup) {
        return sup;
    }
    return nil;
}

-(void)makeDisabledForTextFieldAndBtn
{
    _textField.enabled =  false;
    _deleteBtn.hidden = YES;
    
}

#pragma mark -TextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UIView * sup = [self getTheTopestSuperView];
    if (sup) {
        CGFloat heihgt = _superestView.height - sup.bottom;
        NSLog(@"superEst.frame = %@",NSStringFromCGRect(_superestView.frame));
        NSLog(@"sup.frame = %@",NSStringFromCGRect(sup.frame));
        NSLog(@"%f----  %f",sup.bottom,sup.bottom - KeyBoardHeight);
        if (heihgt - KeyBoardHeight<0) {
            
            double temp = fabs(heihgt - KeyBoardHeight) + 20;
            [UIView animateWithDuration:0.3 animations:^{
                _superestView.top =  - temp;
                if (IOS7) {
//                    [[UIApplication sharedApplication] setStatusBarHidden:YES];
                }
            }];
        }else{
            if (IOS7) {
                [UIView animateWithDuration:0.3 animations:^{
                    _superestView.top = 44;
                }];
            }else{
                [UIView animateWithDuration:0.3 animations:^{
                    _superestView.top = 44;
                }];
            }
            
        }
        
    }
    return YES;
    
}


//- (void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
//- (void)textFieldDidEndEditing:(UITextField *)textField;             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
//
//- (BOOL)textFieldShouldClear:(UITextField *)textField;               // called when clear button pressed. return NO to ignore (no notifications)
//- (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (_superestView.top!= 20) {

        [UIView animateWithDuration:0.3 animations:^{
            if (IOS7) {
                _superestView.top = 44;
//                [[UIApplication sharedApplication] setStatusBarHidden:NO];
            }else{
                _superestView.top = 44;
            }
            
        }];
    }
//    _strContent = textField.text;
//    if ([_delegate respondsToSelector:@selector(textInputValue:sender:)]) {
//        [_delegate textInputValue:_strContent sender:self];
//    }
    return YES;
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _strContent = textField.text;
    if ([_delegate respondsToSelector:@selector(textInputValue:sender:)]) {
        [_delegate textInputValue:_strContent sender:self];
    }
}



@end
