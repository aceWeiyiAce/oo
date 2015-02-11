//
//  HomeCellView.m
//  LingZhi
//
//  Created by boguoc on 14-4-16.
//
//

#import "HomeCellView.h"

@interface HomeCellView ()
{
    __weak IBOutlet ITTImageView *_imageView;
    __weak IBOutlet UILabel *_middleLabel;
    __weak IBOutlet UILabel *_rightLabel;
    BOOL _hasMiddleView;
}
@end

@implementation HomeCellView

-(void)awakeFromNib
{
    [super awakeFromNib];
    _hasMiddleView = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReciveNotification) name:@"middleView" object:nil];
}

- (void)layoutHomeCellView:(HomeModel *)model 
{
    [_imageView loadImage:model.imageUrl];
    _middleLabel.text = model.className;
    _rightLabel.text = model.className;
    if (_index == 0) {
        _rightLabel.hidden = YES;
//        [self performSelector:@selector(showMiddleLabel) withObject:nil afterDelay:.1f];
        [self showMiddleLabel];
    }
//    _rightLabel.width = [UILabel layoutLabelWidthWithText:model.className font:[_rightLabel font] height:30.f];
    _rightLabel.right = self.right - 30;
}

- (void)showMiddleLabel
{
    if (_hasMiddleView) {
        return;
    }
    _hasMiddleView = YES;
    _middleLabel.alpha = 0;
    _middleLabel.hidden = NO;
    [UIView animateWithDuration:.5f
                     animations:^{
        _middleLabel.alpha = 1;
    }
                     completion:^(BOOL finished) {
                         //update by pk at 2014.09.22
                         //取消隐藏
//                         if (finished) {
//                             [self performSelector:@selector(hidenMiddleLabel) withObject:nil afterDelay:2];
//                         }
                     }];
}

- (void)hidenMiddleLabel
{
    [UIView animateWithDuration:.6f
                     animations:^{
                         _middleLabel.alpha = 0;
                     } completion:^(BOOL finished) {
                         if (finished) {
                             _middleLabel.hidden = YES;
                             _hasMiddleView = NO;
                         }
                     }];
}

- (void)didReciveNotification
{
    if (_index == 0) {
        [self showMiddleLabel];
    }
}
@end
