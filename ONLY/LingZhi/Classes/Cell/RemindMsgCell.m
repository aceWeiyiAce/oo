//
//  RemindMsgCell.m
//  LingZhi
//
//  Created by pk on 14-5-19.
//
//

#import "RemindMsgCell.h"

@interface RemindMsgCell ()
{

}

@property (weak, nonatomic) IBOutlet UILabel *remindMsg;

@end

@implementation RemindMsgCell

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
    [super awakeFromNib];
}

-(void)setRemindStr:(NSString *)remindStr
{
    self.remindMsg.frame = CGRectMake(35, 5, 270, 0);
    _remindMsg.textColor       = [UIColor grayColor];
    _remindMsg.font            = [UIFont systemFontOfSize:13.0];
    _remindMsg.text            = remindStr;
    _remindMsg.numberOfLines   = 0;
    [_remindMsg sizeToFit];
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
