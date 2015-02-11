//
//  GoodsTableViewCell.m
//  LingZhi
//
//  Created by iFangSoft on 15/1/29.
//
//

#import "GoodsTableViewCell.h"

@implementation GoodsTableViewCell
@synthesize GoodaImageView;
@synthesize GoodsAroundLabel;
@synthesize GoodsIsLinLabel;
@synthesize GoodsNameLabel;
@synthesize GoodsTimeLabel;
@synthesize GoodsSexLabel;
@synthesize image;

-(void)setImage:(NSString *)image
{
    self.GoodaImageView.image = [UIImage imageNamed:[image copy]];
}

-(void)setName:(NSString *)name
{
    self.GoodsNameLabel.text = [name copy];
}

-(void)setSex:(NSString *)sex
{
    self.GoodsSexLabel.text = [sex copy];
}

-(void)setTime:(NSString *)time
{
    self.GoodsTimeLabel.text = [time copy];
}

-(void)setIslin:(NSString *)islin
{
    self.GoodsIsLinLabel.text = [islin copy];
}

-(void)setAround:(NSString *)around
{
    self.GoodsAroundLabel.text = [around copy];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
