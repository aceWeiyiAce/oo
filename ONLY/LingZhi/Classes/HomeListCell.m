
//
//  HomeListCell.m
//  LingZhi
//
//  Created by boguoc on 14-2-28.
//
//

#import "HomeListCell.h"

@interface HomeListCell()
{
    __weak IBOutlet UIImageView     *_accessoryImageView;
    
}

@end

@implementation HomeListCell

-(void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)layoutHomeListCellWith:(ClassificationModel *)model
{
    _homeCellLabel.text = model.name;
    _homeCellLabel.textColor = [model.isSelect boolValue]? SelectedColor :[UIColor blackColor];
    
}

@end
















