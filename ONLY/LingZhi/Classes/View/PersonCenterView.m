//
//  PersonCenterView.m
//  LingZhi
//
//  Created by boguoc on 14-2-27.
//
//

#import "PersonCenterView.h"


@interface PersonCenterView()
{
    UIControl               *_bgControl;
    PersonCenterButtonType  _buttonType;
    __weak IBOutlet UIImageView *_bgView;
    
    UIView * _containsView;
}

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) CGRect boxFrame;


@end

@implementation PersonCenterView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    
}

-(void)showPersonCenterViewWithView:(UIView *)superView delegate:(id)delegate
{
//    self.delegate = delegate;
//    if (DATA_ENV.userInfo.userId.length > 0) {
//        _bgView.image = [UIImage imageNamed:@"moreView_logout"];
//    } else {
//        _bgView.image = [UIImage imageNamed:@"moreView_login"];
//    }
//    
//    _bgControl = [[UIControl alloc] initWithFrame:superView.bounds];
//    _bgControl.backgroundColor = [UIColor clearColor];
//    [_bgControl addTarget:self action:@selector(cancelPersonCenterView) forControlEvents:UIControlEventTouchUpInside];
//    [superView addSubview:_bgControl];
//    
//    self.top = 46;
//    self.right = superView.right - 10;
//    self.alpha = 0;
//    [superView addSubview:self];
//    
//    [UIView animateWithDuration:.3f animations:^{
//        self.alpha = 1;
//    } completion:^(BOOL finished) {
//    }];
    
    
    _bgControl = [[UIControl alloc] initWithFrame:superView.bounds];
    _bgControl.backgroundColor = [UIColor clearColor];
    [_bgControl addTarget:self action:@selector(cancelPersonCenterView) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:_bgControl];
    
    CGPoint startPoint = CGPointMake(self.origin.x + GET_VIEW_WIDTH(self), self.top);
    
    [self showPopoverAtPoint:startPoint inView:superView withContentView:self];
    
    self.delegate = delegate;
    if (DATA_ENV.userInfo.userId.length > 0) {
        _bgView.image = [UIImage imageNamed:@"moreView_logout"];
    } else {
        _bgView.image = [UIImage imageNamed:@"moreView_login"];
    }

}

-(void)cancelPersonCenterView
{
//    [UIView animateWithDuration:.3f animations:^{
//        self.alpha = 0;
//        
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//        [_bgControl removeFromSuperview];
//    }];
    [self dismiss];
}

#pragma mark - Button methods

- (IBAction)onChoosePersonCenterButton:(id)sender
{
    [self cancelPersonCenterView];
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 0:
            _buttonType = kPersonCenterCart;
            break;
        case 1:
            _buttonType = kPersonCenterFavorite;
            break;
        case 2:
            _buttonType = kPersonCenterOrder;
            break;
        case 3:
            _buttonType = kPersonCenterAddress;
            break;
        case 4:
            _buttonType = kPersonCenterPassword;
            break;
        case 5:
            _buttonType = kPersonCenterLogin;
            break;
    
        default:
            break;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didOnPersonCenterButtonWithType:)]) {
        [self.delegate didOnPersonCenterButtonWithType:_buttonType];
    }
}

- (void)showPopoverAtPoint:(CGPoint)point inView:(UIView *)view withContentView:(UIView *)cView
{
    _containsView = [[UIView alloc] init];
    _containsView.origin = CGPointMake(140, 45);
    _containsView.size = cView.size;
    _containsView.backgroundColor =[UIColor clearColor];
    [view addSubview:_containsView];
    
    self.boxFrame = cView.frame;
    self.contentView = cView;

    UIView *topView = view;
    
    CGPoint topPoint = [topView convertPoint:point fromView:view];
    CGRect topViewBounds = topView.bounds;
    _contentView.frame = _boxFrame;
    _contentView.hidden = NO;
    [_containsView addSubview:_contentView];
    
    self.layer.anchorPoint = CGPointMake(topPoint.x / topViewBounds.size.width, topPoint.y / topViewBounds.size.height);
    self.frame = topViewBounds;
    [self setNeedsDisplay];
    
    self.userInteractionEnabled = YES;
    
    self.alpha = 0.f;
    self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    
    [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1.f;
        self.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

#define kGradientTopColor [UIColor clearColor]
#define kGradientBottomColor [UIColor clearColor]
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGRect frame = _boxFrame;
    
    float xMin = CGRectGetMinX(frame);
    float yMin = CGRectGetMinY(frame);
    
    float xMax = CGRectGetMaxX(frame);
    float yMax = CGRectGetMaxY(frame);
    
    float radius = 4.f;
    
    float cpOffset = 1.8f;
    
    UIBezierPath *popoverPath = [UIBezierPath bezierPath];
    [popoverPath moveToPoint:CGPointMake(CGRectGetMinX(frame), CGRectGetMinY(frame) + radius)];//
    [popoverPath addCurveToPoint:CGPointMake(xMin + radius, yMin) controlPoint1:CGPointMake(xMin, yMin + radius - cpOffset) controlPoint2:CGPointMake(xMin + radius - cpOffset, yMin)];//
    
    [popoverPath addLineToPoint:CGPointMake(xMax - radius, yMin)];
    [popoverPath addCurveToPoint:CGPointMake(xMax, yMin + radius) controlPoint1:CGPointMake(xMax - radius + cpOffset, yMin) controlPoint2:CGPointMake(xMax, yMin + radius - cpOffset)];//
    [popoverPath addLineToPoint:CGPointMake(xMax, yMax - radius)];
    [popoverPath addCurveToPoint:CGPointMake(xMax - radius, yMax) controlPoint1:CGPointMake(xMax, yMax - radius + cpOffset) controlPoint2:CGPointMake(xMax - radius + cpOffset, yMax)];//
    [popoverPath addLineToPoint:CGPointMake(xMin + radius, yMax)];
    [popoverPath addCurveToPoint:CGPointMake(xMin, yMax - radius) controlPoint1:CGPointMake(xMin + radius - cpOffset, yMax) controlPoint2:CGPointMake(xMin, yMax - radius + cpOffset)];//
    [popoverPath closePath];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor* shadow = [UIColor colorWithWhite:0.f alpha:0.4f];
    CGSize shadowOffset = CGSizeMake(0, 1);
    CGFloat shadowBlurRadius = 10;
    
    NSArray* gradientColors = [NSArray arrayWithObjects:
                               (id)kGradientTopColor.CGColor,
                               (id)kGradientBottomColor.CGColor, nil];
    CGFloat gradientLocations[] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)gradientColors, gradientLocations);
    
    float bottomOffset = 0.f;
    float topOffset = 0.f;
    
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
    CGContextBeginTransparencyLayer(context, NULL);
    [popoverPath addClip];
    CGContextDrawLinearGradient(context, gradient, CGPointMake(CGRectGetMidX(frame), CGRectGetMinY(frame) - topOffset), CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame) + bottomOffset), 0);
    CGContextEndTransparencyLayer(context);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
}

//- (void)tapped:(UITapGestureRecognizer *)tap
//{
//    [self dismiss];
//}

- (void)dismiss {
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0.1f;
        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [_containsView removeFromSuperview];
        [_bgControl removeFromSuperview];
    }];
    
}

@end


