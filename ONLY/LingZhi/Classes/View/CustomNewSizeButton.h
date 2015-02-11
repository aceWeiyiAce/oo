//
//  CustomSizeButton.h
//  LingZhi
//
//  Created by pk on 4/2/14.
//
//

#import "ITTXibView.h"
#import "SizeModel.h"

@interface CustomNewSizeButton : UIButton

@property (strong, nonatomic) IBOutlet UILabel *codeLbl;
@property (strong, nonatomic) IBOutlet UILabel *sizeLbl;

@property (strong, nonatomic) SizeModel * size;

@end
