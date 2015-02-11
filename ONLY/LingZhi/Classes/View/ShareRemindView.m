//
//  shareRemindView.m
//  LingZhi
//
//  Created by pk on 3/3/14.
//
//

#import "ShareRemindView.h"
#import "MainViewController.h"

@interface ShareRemindView ()
{
    IBOutlet UIImageView *_imageView;
    IBOutlet UILabel *_message;
    __weak IBOutlet UIButton *_clickBtn;
    
}
@end



@implementation ShareRemindView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShareRemindView" owner:self options:nil];
        self = [nib objectAtIndex:0];
        
      
    }
    return self;
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    
    CGPoint supCenter = self.center;
    
    CGSize  size = CGSizeMake(320, SCREEN_HEIGHT - 64);
    self.size = size;
    
    if (SCREEN_HEIGHT == 568) {
        _imageView.center = CGPointMake(_imageView.centerX, supCenter.y-20);
        _message.center = CGPointMake(_message.centerX, supCenter.y + 70);

    }else{
        _imageView.center = CGPointMake(_imageView.centerX, supCenter.y-40);
        _message.center = CGPointMake(_message.centerX, supCenter.y + 40);

    }
    //        _clickBtn.origin = CGPointMake(_clickBtn.origin.x,self.size.height + _clickBtn.size.height - 10);
    _clickBtn.center = CGPointMake(_clickBtn.centerX,self.size.height - 10);
    
}

- (IBAction)backToHomePage:(id)sender {
    _btn_block() ;
}



/**
 *  根据图片和提示信息显示
 *
 *  @param image
 *  @param msg
 */
-(void)showRemindInfoWithImage:(UIImage *)image andMsg:(NSString *)msg
{
    if(image == Nil){
        _imageView.backgroundColor = [UIColor yellowColor];
        
    }else{
        _imageView.image = image;
    }

    NSLog(@"self.frame = %@",NSStringFromCGRect(self.frame));
    
    _message.textAlignment = UITextAlignmentCenter;
//    _message.numberOfLines = 1;
    _message.text = msg;
//    [_message sizeToFit];
    NSLog(@"_message frame = %@",NSStringFromCGRect(_message.frame));
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
