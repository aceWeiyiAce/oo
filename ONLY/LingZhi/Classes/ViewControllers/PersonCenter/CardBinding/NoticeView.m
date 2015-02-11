//
//  NoticeView.m
//  LingZhi
//
//  Created by feng on 14-8-12.
//
//

#import "NoticeView.h"

@implementation NoticeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andView:(UIView *)backview
{
    self = [self initWithFrame:frame];
    [self createBackgroundView];
    [self addImageAndLabel];
    [backview addSubview:self];
    self.alpha = 0.0f;
    return self;
}

- (void)makeViewShow:(NSString *)message
{
    if (self.alpha == 1.0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self toHiddenView];
    }
    UILabel *label = ((UILabel *)[self viewWithTag:9999]);
    UIImageView *img = ((UIImageView *)[self viewWithTag:1990]);
    label.text = message;
    UIView *view = ((UIView *)[self viewWithTag:888]);
    NSInteger height = 44;
    if (IOS7) {
        height = 64;
    }
    CGRect frame = self.frame;
    frame.size.height = 40;
    frame.origin.y = height;
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 1.0f;
        self.frame = frame;
        view.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        view.alpha = 0.8f;
        label.frame = CGRectMake(40, (self.bounds.size.height-20)/2, self.bounds.size.width-40, 20);
        img.frame = CGRectMake(16, (self.bounds.size.height-17)/2, 17, 17);
    } completion:^(BOOL finished) {
        [self performSelector:@selector(toHiddenView) withObject:self afterDelay:3.0f];
    }];
}

- (void)toHiddenView
{
    UIView *view = ((UIView *)[self viewWithTag:888]);
    NSInteger height = 44;
    if (IOS7) {
        height = 64;
    }
    CGRect frame = self.frame;
    frame.size.height = 0;
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0.0f;
        self.frame = frame;
        view.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
    }];
}

- (void)createBackgroundView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    view.backgroundColor = [UIColor colorWithRed:1.00f green:0.30f blue:0.58f alpha:1.00f];
    view.alpha = 0.8f;
    view.tag = 888;
    [self addSubview:view];
}

- (void)addImageAndLabel
{
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(16, (self.bounds.size.height-20)/2, 20, 20)];
    img.tag = 1990;
    img.image = [UIImage imageNamed:@"icon_"];
    [self addSubview:img];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, (self.bounds.size.height-20)/2, self.bounds.size.width-40, 20)];
    label.tag = 9999;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15.0f];
    label.textAlignment = NSTextAlignmentLeft;
    [self addSubview:label];
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
