//
//  LogisticsTrackingViewController.m
//  LingZhi
//
//  Created by boguoc on 14-3-12.
//
//

#import "LogisticsTrackingViewController.h"
#import "LogisticsTrackModel.h"
#import "LogisticsTrackCell.h"

@interface LogisticsTrackingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UITableView     *_tableView;
    __weak IBOutlet UILabel         *_dealTimeLabel;
    __weak IBOutlet UILabel         *_companyLabel;
    __weak IBOutlet UILabel         *_orderNumLabel;
    
    
    NSMutableArray                  *_trackArray;
}
@end

@implementation LogisticsTrackingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self getDeliveryListRequest];
}

#pragma mark - DeliveryListRequest

- (void)getDeliveryListRequest
{
    if (!_trackArray) {
        _trackArray = [[NSMutableArray alloc]init];
    }
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:self.orderId forKey:@"orderId"];
    
    [GetDeliveryListRequest requestWithParameters:parameter
                                withIndicatorView:self.view
                                withCancelSubject:@"GetDeliveryListRequest"
                                   onRequestStart:nil
                                onRequestFinished:^(ITTBaseDataRequest *request) {
                                    if ([request isSuccess]) {
                                        NSString *timeStr = [request.handleredResult[@"data"][@"payDate"] substringToIndex:10];
                                        _dealTimeLabel.text = [NSString stringWithFormat:@"成交时间: %@",timeStr];
                                        _companyLabel.text = request.handleredResult[@"data"][@"expressCompany"];
                                        _orderNumLabel.text = request.handleredResult[@"data"][@"expressNumber"];
                                        
                                        [_trackArray removeAllObjects];
                                        [_trackArray addObjectsFromArray:request.handleredResult[@"kModel"]];
                                        [_tableView reloadData];
                                    }
                                }
                                onRequestCanceled:nil
                                  onRequestFailed:^(ITTBaseDataRequest *request) {
                                      
                                  }];
}

#pragma mark - Button methods

- (IBAction)onBackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _trackArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"LogisticsTrackCell";
    
    LogisticsTrackCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [LogisticsTrackCell loadFromXib];
    }
    [cell layoutLogisticeTrackCellWithModel:[_trackArray objectAtIndex:indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
