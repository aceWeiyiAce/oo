//
//  WaitPayViewController.h
//  LingZhi
//
//  Created by apple on 14-8-26.
//
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@protocol WaitPayControllerDelegate <NSObject>

@end

@interface WaitPayViewController : UIViewController

@property (nonatomic,strong)OrderModel * order;

@property (nonatomic,assign)id<WaitPayControllerDelegate> delegate;

@end
