//
//  CustomSizeButton.m
//  LingZhi
//
//  Created by pk on 4/2/14.
//
//

#import "CustomSizeButton.h"

@implementation CustomSizeButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"CustomSizeButton" owner:self options:nil];
        self = [nib objectAtIndex:0];

    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];

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
