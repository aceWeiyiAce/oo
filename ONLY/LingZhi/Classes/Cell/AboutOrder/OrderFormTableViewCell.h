//
//  OrderFormTableViewCell.h
//  LingZhi
//
//  Created by feng on 14-8-27.
//
//

#import "ITTXibView.h"

@interface OrderFormTableViewCell : ITTXibCell
@property (weak, nonatomic) IBOutlet ITTImageView *orderImage;
@property (weak, nonatomic) IBOutlet UILabel *orderName;
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
@property (weak, nonatomic) IBOutlet UILabel *orderColor;
@property (weak, nonatomic) IBOutlet UILabel *orderType;
@property (weak, nonatomic) IBOutlet UILabel *orderPrice;
@property (weak, nonatomic) IBOutlet UILabel *orderNO;

@end
