//
//  CustomDefaultView.m
//  LingZhi
//
//  Created by boguoc on 14-5-12.
//
//

#import "CustomDefaultView.h"
#import "AppDelegate.h"

@interface CustomDefaultView ()
{
    __weak IBOutlet UIImageView *_backgroundImageView;
    
}

@end

@implementation CustomDefaultView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
//    UIWindow *window = [AppDelegate GetAppDelegate].window;
//    NSLog(@"%@",window);
//    [window addSubview:self];
    
}

- (void)showCustomDefaultViewWithView:(UIView *)superView
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    self.frame = window.bounds;
    _backgroundImageView.frame = window.bounds;
    self.backgroundColor = [UIColor whiteColor];
    
    if (is4InchScreen()) {
        _backgroundImageView.image = [UIImage imageNamed:@"Default-568h@2x"];
    } else {
        _backgroundImageView.image = [UIImage imageNamed:@"Default.png"];
    }
    
    NSLog(@"%@",self);
    NSLog(@"%@",_backgroundImageView);
    NSLog(@"%@",[[UIApplication sharedApplication].delegate window]);
    [window addSubview:self];
}

- (void)removeCustomDefaultView
{
    [self removeFromSuperview];
}

@end
