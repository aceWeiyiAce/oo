//
//  UITableView+Wave.m
//  TableViewWaveDemo
//
//  Created by jason on 14-4-23.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import "UITableView+Wave.h"

@implementation UITableView (Wave)


- (void)reloadDataAnimateWithWave:(WaveAnimation)animation;
{
//    [self setContentOffset:self.contentOffset animated:NO];
    
//    [UIView animateWithDuration:.8 animations:^{
//        [self setHidden:YES];
//        [self reloadData];
//    } completion:^(BOOL finished) {
        //Do something after that...
//        [self setHidden:NO];
//        [self visibleRowsBeginAnimation:animation];
//    }];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self setHidden:YES];
        [self reloadData];
    } completion:^(BOOL finished) {
        [self setHidden:NO];

        [self visibleRowsBeginAnimation:animation];
    }];
//    [self performSelector:@selector(delayPerformActionWithWave) withObject:nil afterDelay:0];
}

-(void)delayPerformActionWithWave
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self setHidden:YES];
        [self reloadData];
    } completion:^(BOOL finished) {
        [self setHidden:NO];
        
        [self visibleRowsBeginAnimation:RightToLeftWaveAnimation];
    }];

}

- (void)visibleRowsBeginAnimation:(WaveAnimation)animation
{
    NSArray *array = [self indexPathsForVisibleRows];
    for (int i=0 ; i < [array count]; i++) {
        NSIndexPath *path = [array objectAtIndex:i];
        UITableViewCell *cell = [self cellForRowAtIndexPath:path];
        cell.hidden = YES;

        NSArray *array = @[path,[NSNumber numberWithInt:animation]];
        [self performSelector:@selector(animationStart:) withObject:array afterDelay:0.3 + i/10.0];
        
    }
}


- (void)animationStart:(NSArray *)array
{
    NSIndexPath *path = [array objectAtIndex:0];
    float i = [((NSNumber*)[array objectAtIndex:1]) floatValue] ;
    UITableViewCell *cell = [self cellForRowAtIndexPath:path];
//    CGPoint originPoint = cell.center;
    CGPoint originPoint = cell.center;
    
    cell.center = CGPointMake(cell.frame.size.width+100, originPoint.y);
    [UIView animateWithDuration:0.4
						  delay:0
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
                         cell.center = CGPointMake(originPoint.x-i*kBOUNCE_DISTANCE , originPoint.y);
                         cell.hidden = NO;
                     }
                     completion:^(BOOL f) {
						 [UIView animateWithDuration:0.1 delay:0
											 options:UIViewAnimationOptionTransitionFlipFromRight
										  animations:^{
//                                              cell.center = CGPointMake(originPoint.x+i*kBOUNCE_DISTANCE, originPoint.y);
                                          }
										  completion:^(BOOL f) {
											  [UIView animateWithDuration:0.1 delay:0
                                                                  options:UIViewAnimationOptionTransitionFlipFromRight
                                                               animations:^{
                                                                   cell.center= originPoint;
                                                               }
                                                               completion:NULL];
										  }];
                     }];
    
    
}

@end
