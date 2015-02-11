//
//  LogisticsTrackCell.m
//  LingZhi
//
//  Created by boguoc on 14-3-12.
//
//

#import "LogisticsTrackCell.h"

@interface LogisticsTrackCell ()
{
    __weak IBOutlet UIImageView     *_typeImage;
    __weak IBOutlet UILabel         *_timeLabel;
    __weak IBOutlet UILabel         *_dateLabel;
    __weak IBOutlet UILabel         *_detailLabel;
    __weak IBOutlet UIImageView     *_lineImageView;
    __weak IBOutlet UIView          *_topLine;
    __weak IBOutlet UIView          *_bottomLine;
}
@end

@implementation LogisticsTrackCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)layoutLogisticeTrackCellWithModel:(LogisticsTrackModel *)model
{
    if ([model.status boolValue]) {
        _typeImage.image = [UIImage imageNamed:@"track.png"];
    } else {
        _typeImage.image = [UIImage imageNamed:@"track1.png"];
    }
    if ([model.line isEqualToString:@"1"]) {
        _topLine.hidden = NO;
    } else if ([model.line isEqualToString:@"2"]) {
        _bottomLine.hidden = NO;
    } else {
        _topLine.hidden = YES;
        _bottomLine.hidden = YES;
    }
    _timeLabel.text = model.time;
    _dateLabel.text = model.date;
    _detailLabel.text = model.detail;
    
}

@end
