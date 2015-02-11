//
//  CustomError.m
//  LingZhi
//
//  Created by kping on 14-8-13.
//
//

#import "CustomError.h"

@interface CustomError ()

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (assign,nonatomic) BOOL isShowed;

@end

@implementation CustomError


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)showErrorMsg:(NSString *)msg
{
    if (_isShowed) {
        return;
    }
    self.superview.alpha = 0.0;
    self.superview.hidden = NO;
    self.errorLabel.text = msg;
    [UIView animateWithDuration:1.0 animations:^{
        [self.superview setAlpha:1.0];
        _isShowed = YES;
    } completion:^(BOOL finished) {
         [self performSelector:@selector(hideErrorMsg) withObject:nil afterDelay:1.0];
    }];

}

-(void)hideErrorMsg
{
    [UIView animateWithDuration:1.0 animations:^{
        [self.superview setAlpha:0.0];
        
    } completion:^(BOOL finished) {
        self.superview.hidden = YES;
        _isShowed = NO;
    }];
    
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
