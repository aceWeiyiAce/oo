//
//  OrderProductCell.m
//  LingZhi
//
//  Created by pk on 3/26/14.
//
//

#import "OrderProductCell.h"

@implementation OrderProductCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    self.infoLbl.width = 192;
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
