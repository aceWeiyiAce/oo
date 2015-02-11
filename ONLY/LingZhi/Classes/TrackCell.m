//
//  TrackCell.m
//  LingZhi
//
//  Created by pk on 3/5/14.
//
//

#import "TrackCell.h"


@interface TrackCell ()
{
    __weak IBOutlet ITTImageView *_imageView;
    __weak IBOutlet UILabel *_info;
    __weak IBOutlet UILabel *_price;
    NSString * _productId;
}
@end


@implementation TrackCell

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
    _imageView.userInteractionEnabled = YES;
}


-(void)setTrack:(MyTrack *)track
{
    _track = track;
    if (track) {
        NSLog(@"imageUrl  = %@",track.imageUrl);
        
        NSLog(@"imageView.frame = %@",NSStringFromCGRect(_imageView.frame));
        [_imageView loadImage:track.imageUrl];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _price.text = track.productPrice;
        _info.text = track.productInfo;
        _productId = track.productId;
    }
}

-(void)showTrackWithModel:(MyTrack *)track
{
    NSLog(@"imageView.frame = %@",NSStringFromCGRect(_imageView.frame));
    [_imageView loadImage:track.imageUrl];
    
    _price.text = track.productPrice;
    _info.text = track.productInfo;
    _productId = track.productId;
}




/**
 *  根据传回的足迹显示对应的信息
 *
 *  @param track
 */
- (void) showTrackInfoWithTrack:(MyTrack *)track
{
    //正式打开代码
    NSLog(@"track = %@",track);
    [_imageView loadImage:track.imageUrl];
    
    _price.text = track.productPrice;
    _info.text = track.productInfo;
    _productId = track.productId;
    
}

- (IBAction)tapToProductDetailAction:(id)sender {
    
    _tapAction(_productId);
    
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
