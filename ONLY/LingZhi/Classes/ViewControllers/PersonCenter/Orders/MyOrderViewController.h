//
//  MyOrderViewController.h
//  LingZhi
//
//  Created by boguoc on 14-2-27.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface MyOrderViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) UIViewController *productController;
@property (strong, nonatomic) NSMutableArray * allOrders;

@end
