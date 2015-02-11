//
//  OrderDetailController.h
//  LingZhi
//
//  Created by pk on 3/11/14.
//
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
#import "BaseViewController.h"

@protocol  OrderDetailControllerDelegate<NSObject>

-(void)makePreviewControllerRefresh:(NSMutableArray *)array;

@end

@interface OrderDetailController : BaseViewController

@property(nonatomic,strong)OrderModel * order;

@property(nonatomic,assign)id<OrderDetailControllerDelegate> delegate;

@end
