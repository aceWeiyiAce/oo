//
//  RecordViewController.m
//  JiuBa
//
//  Created by apple on 15/2/12.
//
//

#import "RecordViewController.h"
#import "GoodsInfoCell.h"
@interface RecordViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"购买记录";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodsInfoCell *cell = [GoodsInfoCell cellWithTableView:tableView];
    return cell;
}

#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
@end
