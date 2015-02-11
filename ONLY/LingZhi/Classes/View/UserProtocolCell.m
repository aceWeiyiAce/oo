
//
//  UserProtocolCell.m
//  LingZhi
//
//  Created by boguoc on 14-5-8.
//
//

#import "UserProtocolCell.h"
#import "UILabel+ITTAdditions.h"

@interface UserProtocolCell ()
{
    __weak IBOutlet UILabel     *_contentLabel;
    float                       _cellHeight;
    __weak IBOutlet UIImageView *_headView;
}

@end

@implementation UserProtocolCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    _cellHeight = 0;
}

- (void)layoutUserProtocolCellWithString:(NSString *)string
{
    NSString *imageStr = [NSString stringWithFormat:@"server_%d.png",_index +1];
    _headView.image = [UIImage imageNamed:imageStr];
    
    _contentLabel.text = string;
    _contentLabel.height = [UILabel layoutLabelHeightText:[NSString stringWithFormat:@"塑料袋口附近是浪费空间塑料袋福建省的浪费空间死定了空间收到了副科级是 %@",string] font:_contentLabel.font width:270.f];
    
    _contentLabel.top = _headView.bottom + 5;
    _cellHeight = _contentLabel.height + 30;
}

- (CGFloat)getUserProtocolCellHeight
{
    return _cellHeight;
}


@end
