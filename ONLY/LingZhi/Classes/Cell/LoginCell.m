//
//  LoginCell.m
//  LingZhi
//
//  Created by pk on 3/13/14.
//
//

#import "LoginCell.h"

@interface LoginCell ()
{
    
}
@end

@implementation LoginCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
//    self.remindLBl.layer.borderWidth = 1.0;
//    self.remindLBl.layer.borderColor = [UIColor colorWithRed:1.000 green:0.211 blue:0.407 alpha:1.000].CGColor;
    self.remindLBl.left = 15.0;
    
    self.txtField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
    self.txtField.leftViewMode = UITextFieldViewModeAlways;
    
    self.remindLBl.hidden = YES;

    

    
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
