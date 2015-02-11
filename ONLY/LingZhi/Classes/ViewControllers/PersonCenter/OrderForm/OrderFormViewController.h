//
//  OrderFormViewController.h
//  LingZhi
//
//  Created by feng on 14-8-25.
//
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"

@interface OrderFormViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIView *orderTypeView;
@property (weak, nonatomic) IBOutlet UIView *topNavBar;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *consigneeAddressView;
@property (strong, nonatomic) IBOutlet UIView *expressageView;
@property (strong, nonatomic) IBOutlet UIView *retreatView;
@property (strong, nonatomic) IBOutlet UIView *footPayView;

@property NSInteger kTypeNum;
@property (nonatomic, strong) NSString *orderId;

- (IBAction)buttonPressForOrderForm:(UIButton *)btn;

@end
