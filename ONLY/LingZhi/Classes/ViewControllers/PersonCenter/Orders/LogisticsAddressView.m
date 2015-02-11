//
//  LogisticsAddressView.m
//  LingZhi
//
//  Created by feng on 14-8-26.
//
//

#import "LogisticsAddressView.h"

@implementation LogisticsAddressView

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
{265
    // Drawing code
}
*/

- (void)setViewTime:(NSString *)time andDate:(NSString *)date andTitle:(NSString *)thingh
{
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 10, 90, 20)];
    timeLabel.text = time;
    timeLabel.textColor = [UIColor blackColor];
    timeLabel.font = [UIFont systemFontOfSize:12.0f];
    
}

@end
