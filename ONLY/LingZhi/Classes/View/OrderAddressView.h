//
//  OrderAddressView.h
//  LingZhi
//
//  Created by pk on 3/28/14.
//
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"


@protocol OrderAddressViewDelegate <NSObject>

@optional

-(void)changeViewToShow:(AddressModel *)model;

@end


typedef void(^UseUseFulBLOCK)(void);

typedef void(^SaveAdderessBlock)(AddressModel *model);

@interface OrderAddressView : UIView


@property (nonatomic,assign)id<OrderAddressViewDelegate>delegate;
@property (nonatomic,copy) UseUseFulBLOCK usefulAction;
@property (nonatomic,copy) SaveAdderessBlock saveAddressAction;

@property (nonatomic,strong) NSString * orderId;

/**
 *  计算得到tableView的高度
 *
 *  @return
 */
-(CGFloat)tableHeight;
@end
