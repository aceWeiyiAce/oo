//
//  CustomAlertView.m
//  LingZhi
//
//  Created by pk on 3/19/14.
//
//

#import "CustomAlertView.h"


@interface CustomAlertView ()
{
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UILabel *_phoneNumLabel;
    __weak IBOutlet UIButton *_oneButton;
    __weak IBOutlet UIButton *_twoButton;
    
    UIControl               *_bgControl;
    
    
}
@property (nonatomic,copy) ButtonBlock leftBtnClickBlock;
@property (nonatomic,copy) ButtonBlock rightBtnClickBlock;

@end


@implementation CustomAlertView

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

- (void)showCustomViewWithSuperView:(UIView *)superView title:(NSString *)atitle content:(NSString *)acontent oneButtonText:(NSString *)text1 twoButtonText:(NSString *)text2 oneButtonActionBlock:(ButtonBlock) leftBlock twoButtonBlock:(ButtonBlock) rightBlock;
{
    
    if (text2 == nil) {
        _twoButton.hidden = YES;
        _oneButton.centerX = self.centerX;
    }
    
    self.leftBtnClickBlock = leftBlock;
    self.rightBtnClickBlock = rightBlock;
    
    _titleLabel.text = atitle;
    
    _phoneNumLabel.textAlignment = NSTextAlignmentCenter;
    _phoneNumLabel.text = acontent;
//    _phoneNumLabel.numberOfLines = 0;
//    [_phoneNumLabel sizeToFit];
    
//    _oneButton.titleLabel.text = text1;
//    _twoButton.titleLabel.text = text2;
    
    [_oneButton setTitle:text1 forState:UIControlStateNormal];
    [_twoButton setTitle:text2 forState:UIControlStateNormal];
    
    _bgControl.frame = superView.bounds;
    [superView addSubview:_bgControl];
    self.center = superView.center;
    [superView addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
        [self.layer addAnimation:[CustomAlertView scaleAnimation:YES] forKey:@"VIEWWILLAPPEAR"];
    } completion:^(BOOL finished){
        if (finished) {
        }
    }];
    
}

#pragma mark - Button methods
- (IBAction)leftButtonAction:(id)sender {
        _leftBtnClickBlock();
//    UIWebView *phoneCallWebView = [[UIWebView alloc] init];
//    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_phoneNumLabel.text]]];
    
    [UIView animateWithDuration:0.3 animations:^{
//        self.alpha = 0;
        [self.layer addAnimation:[CustomAlertView scaleAnimation:NO] forKey:@"VIEWWILLAPPEAR"];
        [_bgControl removeFromSuperview];
    } completion:^(BOOL finished){
        if (finished) {
            [self removeFromSuperview];
        }
    }];


}
- (IBAction)rightButtonAction:(id)sender {
    
    _rightBtnClickBlock();
    [UIView animateWithDuration:0.3 animations:^{
//        self.alpha = 0;
        [self.layer addAnimation:[CustomAlertView scaleAnimation:NO] forKey:@"VIEWWILLAPPEAR"];
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
