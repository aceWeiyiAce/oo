//
//  PromptView.m
//  LingZhi
//
//  Created by feng on 14-8-15.
//
//

#import "PromptView.h"

@implementation PromptView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)PromptShow:(NSString *)promptTitle andMessage:(NSString *)message andSupview:(UIView *)supView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 281, 183)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 281, 40)];
    label.text = promptTitle;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:13.0f];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(75, 92, 22, 22)];
    img.image = [UIImage imageNamed:@"icon_green"];
    [view addSubview:img];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(103, 92, 150, 22)];
    lab.text =message;
    lab.textColor = [UIColor blackColor];
    lab.backgroundColor = [UIColor clearColor];
    lab.font = [UIFont systemFontOfSize:13.0f];
    [view addSubview:lab];
    
    UIView *blview = [[UIView alloc] init];
    [blview setFrame:supView.frame];
    [blview setBackgroundColor:[UIColor blackColor]];
    blview.alpha = 0.6f;
//    [blview addSubview:view];
    view.center = blview.center;
    [self addSubview:blview];
    [self addSubview:view];
    [supView addSubview:self];
    [self performSelector:@selector(removeBackview) withObject:Nil afterDelay:3.0];
}

- (void)removeBackview
{
    [self removeFromSuperview];
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
