//
//  PhoneView.m
//  LingZhi
//
//  Created by boguoc on 14-3-5.
//
//

#import "PhoneView.h"

@interface PhoneView ()
{
    __weak IBOutlet UILabel     *_titleLabel;
    __weak IBOutlet UILabel     *_phoneNumLabel;
    __weak IBOutlet UIButton    *_oneButton;
    __weak IBOutlet UIButton    *_twoButton;
    
    UIControl                   *_bgControl;
    NSString                    *_phoneNum;
}

@end

@implementation PhoneView

-(void)awakeFromNib
{
    [super awakeFromNib];
    _bgControl = [[UIControl alloc] init];
    _bgControl.backgroundColor = [UIColor whiteColor];
    _bgControl.alpha = .4f;
    [_bgControl addTarget:self action:@selector(removeControl) forControlEvents:UIControlEventTouchUpInside];

}

-(void)removeControl
{
    [_bgControl removeFromSuperview];
    [self removeFromSuperview];
    
}

- (void)showPhoneViewWithSuperView:(UIView *)superView title:(NSString *)atitle content:(NSString *)acontent oneButtonText:(NSString *)text1 twoButtonText:(NSString *)text2
{
    _titleLabel.text = atitle;
    NSString *number =nil;
    if (acontent && ![acontent isEqualToString:@""] && acontent.length == 10) {
        number = [NSString stringWithFormat:@"%@-%@-%@",[acontent substringToIndex:3],[[acontent substringFromIndex:3] substringToIndex:3],[[acontent substringFromIndex:6] substringToIndex:4]];
    }
    
    _phoneNumLabel.text = number;
    _phoneNum = number;
    _oneButton.titleLabel.text = text1;
    _twoButton.titleLabel.text = text2;
    
    _bgControl.frame = superView.bounds;
    [superView addSubview:_bgControl];
    self.center = superView.center;
    [superView addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
        [self.layer addAnimation:[PhoneView scaleAnimation:YES] forKey:@"VIEWWILLAPPEAR"];
    } completion:^(BOOL finished){
        if (finished) {
        }
    }];
}


- (void)showPhoneViewForMapViewWithSuperView:(UIView *)superView title:(NSString *)atitle content:(NSString *)acontent oneButtonText:(NSString *)text1 twoButtonText:(NSString *)text2
{
    _titleLabel.text = atitle;
//    NSString *number = [NSString stringWithFormat:@"%@-%@-%@",[acontent substringToIndex:3],[[acontent substringFromIndex:3] substringToIndex:3],[[acontent substringFromIndex:6] substringToIndex:4]];
    _phoneNumLabel.text = acontent;
    _phoneNum = acontent;
    _oneButton.titleLabel.text = text1;
    _twoButton.titleLabel.text = text2;
    
    _bgControl.frame = superView.bounds;
    [superView addSubview:_bgControl];
    self.center = superView.center;
    [superView addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
        [self.layer addAnimation:[PhoneView scaleAnimation:YES] forKey:@"VIEWWILLAPPEAR"];
    } completion:^(BOOL finished){
        if (finished) {
        }
    }];
}


#pragma mark - Button methods

- (IBAction)onCallButton:(id)sender
{
//    UIWebView *phoneCallWebView = [[UIWebView alloc] init];
//    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"80770623"]]];
    
//    UIWebView*callWebview =[[UIWebView alloc] init];
//    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_phoneNum]];
//    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    //记得添加到view上
//    [self addSubview:callWebview];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_phoneNum]]];//打电话
}

- (IBAction)onCancelButton:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        [self.layer addAnimation:[PhoneView scaleAnimation:NO] forKey:@"VIEWWILLAPPEAR"];
        [_bgControl removeFromSuperview];
    } completion:^(BOOL finished){
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - Animation
+ (CAKeyframeAnimation*)scaleAnimation:(BOOL)show{
    CAKeyframeAnimation *scaleAnimation = nil;
    scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.delegate = self;
    scaleAnimation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    if (show){
        scaleAnimation.duration = 0.5;
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    }else{
        scaleAnimation.duration = 0.3;
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6, 0.6, 1.0)]];
    }
    scaleAnimation.values = values;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation.removedOnCompletion = TRUE;
    return scaleAnimation;
}

@end
