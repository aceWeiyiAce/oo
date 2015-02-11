//
//  MyDragView.m
//  LingZhi
//
//  Created by pk on 14-3-9.
//
//

#import "MyDragView.h"

@interface MyDragView ()
{
    CGPoint startPoint;
    CGPoint endPoint;
}
@end

@implementation MyDragView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    startPoint = [touch locationInView:self];
    NSLog(@"startPoint = %@",NSStringFromCGPoint(startPoint));
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    endPoint = [touch locationInView:self];
    NSLog(@"endPoint = %@",NSStringFromCGPoint(endPoint));
    if(endPoint.y>0&&(startPoint.y-endPoint.y)>100.0)
    {
        _animotionAction();
    }
    if (startPoint.y<0) {
        [self resignFirstResponder];
    }
}

@end
