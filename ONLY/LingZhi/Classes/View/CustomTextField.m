//
//  CustomTextField.m
//  LingZhi
//
//  Created by kping on 14-8-14.
//
//

#import "CustomTextField.h"

@interface CustomTextField ()
{
    UIButton * _button;
}
@end

@implementation CustomTextField

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
    
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.leftView = view;
    self.leftViewMode = UITextFieldViewModeAlways;
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(0, 0, 40, 40);
    [_button addTarget:self action:@selector(deleteSelfText) forControlEvents:UIControlEventTouchUpInside];
    [_button setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    _button.imageEdgeInsets = UIEdgeInsetsMake(13,18,13,8);
    UIView * rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightView addSubview:_button];
    self.rightView = rightView;
    self.rightViewMode = UITextFieldViewModeAlways;
    _button.hidden = YES;
    [self addTarget:self action:@selector(textHadLength) forControlEvents:UIControlEventAllEvents];
}

-(void)deleteSelfText{    
    self.text = _alwaysShowStr;
    if (!_alwaysShowStr) {
         _button.hidden = YES;
    }
}

-(void)textHadLength
{
    if (self.text.length>=1) {
        _button.hidden = NO;
    }else{
        _button.hidden = YES;
    }
    if (!self.editing) {
        _button.hidden = YES;
    }
}

-(CGRect)rightViewRectForBounds:(CGRect)bounds
{
    return CGRectMake(self.width-40, 0, 40, 40);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
