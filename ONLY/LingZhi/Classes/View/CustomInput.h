//
//  CustomInput.h
//  LingZhi
//
//  Created by kping on 14-8-12.
//
//

#import "ITTXibView.h"

@protocol CustomInputDelegate <NSObject>

@optional

-(void)textInputDidBecomeEditing;
-(void)textInputValue:(NSString *)string sender:(id)sender;


@end

@interface CustomInput : ITTXibView
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (readonly,nonatomic) NSString            * inputText;
@property (strong,nonatomic  ) UIView              * superestView;
@property (assign,nonatomic  ) id<CustomInputDelegate> delegate;

-(void)makeDisabledForTextFieldAndBtn;

@end
