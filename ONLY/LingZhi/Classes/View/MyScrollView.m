//
//  MyScrollView.m
//  LingZhi
//
//  Created by pk on 3/10/14.
//
//

#import "MyScrollView.h"

@implementation MyScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    UITouch * touch = [touches anyObject];
    _touchStartPoint = [touch locationInView:self];
    
//    NSLog(@"touchesPoint.frame =  %@",NSStringFromCGPoint(_touchStartPoint));
    return YES;
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
