//
//  PayViewController.m
//  JiuBa
//
//  Created by apple on 15/2/11.
//
//

#import "PayViewController.h"
#import "UPViewController.h"
@interface PayViewController ()

@end

@implementation PayViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购买时间太币";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
    银联充值
 */
- (IBAction)payAction:(UIButton *)sender {
    UPViewController *vc = [[UPViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
