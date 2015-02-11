//
//  GoodsTableViewCell.h
//  LingZhi
//
//  Created by iFangSoft on 15/1/29.
//
//

#import <UIKit/UIKit.h>

@interface GoodsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *GoodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *GoodsSexLabel;
@property (weak, nonatomic) IBOutlet UILabel *GoodsAroundLabel;
@property (weak, nonatomic) IBOutlet UILabel *GoodsIsLinLabel;
@property (weak, nonatomic) IBOutlet UILabel *GoodsTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *GoodaImageView;
@property (nonatomic , retain) NSString *image;
@property (nonatomic , retain) NSString *sex;
@property (nonatomic , retain) NSString *around;
@property (nonatomic , retain) NSString *islin;
@property (nonatomic , retain) NSString *time;
@property (nonatomic , retain) NSString *name;

@end
