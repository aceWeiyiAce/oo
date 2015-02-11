//
//  MapListCell.m
//  LingZhi
//
//  Created by boguoc on 14-3-5.
//
//

#import "MapListCell.h"

@interface MapListCell ()
{
    __weak IBOutlet UILabel *_storeLabel;
    __weak IBOutlet UILabel *_distanceLabel;
}

@end

@implementation MapListCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)layoutMapListCellWithModel:(MapModel *)model
{
    _storeLabel.text = model.name;
    if ([model.num floatValue]>1000) {
        _distanceLabel.text = [NSString stringWithFormat:@"%.1f公里",[model.num floatValue] /1000.0f];
    } else {
        _distanceLabel.text = [NSString stringWithFormat:@"%@米",model.num];
    }
}

@end
