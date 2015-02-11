//
//  WaitPostOrderViewController.h
//  LingZhi
//
//  Created by kping on 14-8-26.
//
//

#import "BaseViewController.h"
#import "OrderModel.h"

@protocol  WaitPostOrderViewControllerDelegate<NSObject>

-(void)makeOrderControllerRefresh:(NSMutableArray *)array;

@end


@interface WaitPostOrderViewController : BaseViewController

@property(nonatomic,strong)OrderModel * order;
@property(nonatomic,assign)id<WaitPostOrderViewControllerDelegate> delegate;

@end
