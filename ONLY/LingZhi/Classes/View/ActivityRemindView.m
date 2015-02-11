//
//  ActivityRemindView.m
//  LingZhi
//
//  Created by pk on 14-4-14.
//
//

#import "ActivityRemindView.h"

@interface ActivityRemindView ()
{
    UIView   *_control;
}

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (strong, nonatomic) IBOutlet UILabel *remindMsg;


@end

@implementation ActivityRemindView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.cornerRadius = 5.0f;
    self.layer.masksToBounds = YES;

}

-(void)showActivityViewInView:(UIView *)view withMsg:(NSString *)msg
{
    _control = [[UIView alloc]initWithFrame:view.bounds];
//    _control.layer.cornerRadius = 20.f;
//    _control.layer.masksToBounds = YES;
    _control.backgroundColor = [UIColor clearColor];
    _control.center = self.center;
    [view addSubview:_control];

//    [_activity startAnimating];
    _remindMsg.width = [UILabel layoutLabelWidthWithText:msg font:[UIFont systemFontOfSize:17] height:_remindMsg.height];
    self.width = _remindMsg.width + 20;
    _remindMsg.left = self.left + 10;
    _remindMsg.text = [NSString stringWithFormat:@"%@",msg];
    
    self.center = view.center;
    [view addSubview:self];
}

-(void)hideActivity
{
    if (self) {
        
        [UIView animateWithDuration:0.4 animations:^{
            self.backgroundColor = [UIColor lightGrayColor];
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.hidden = YES;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [_control removeFromSuperview];
        }];
        
        
    }
}

-(void)showActivityViewInView:(UIView *)view withMsg:(NSString *)msg inSeconds:(int)seconds
{
//    if (is4InchScreen()) {
//        _control.backgroundColor = [UIColor blackColor];
//        _remindMsg.textColor = [UIColor whiteColor];
//    } else {
//        _control.backgroundColor = [UIColor whiteColor];
//        _remindMsg.textColor = [UIColor blackColor];
//    }

    [self showActivityViewInView:view withMsg:msg];
    _activity.hidden = YES;
//    _remindMsg.top -= 20;
    [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(hideActivity) userInfo:Nil repeats:NO];
}


@end
