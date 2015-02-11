//
//  MyTrackViewController.m
//  LingZhi
//
//  Created by pk on 3/5/14.
//
//

#import "MyTrackViewController.h"
#import "TrackCell.h"
#import "MyTrack.h"
#import "ObjectiveRecord.h"
#import "NSDate+Utilities.h"
#import "ProductDetailInfoController.h"


@interface MyTrackViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    __weak IBOutlet UITableView *_tableView;
    
    NSMutableArray * _trackArr;
    
    __weak IBOutlet UILabel *_remindLbl;
}

@end

@implementation MyTrackViewController

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
    _tableView.dataSource = self;
    _tableView.delegate   = self;
    [self deleteOldTrack];

}


-(void)viewWillAppear:(BOOL)animated
{
    _trackArr = [NSMutableArray arrayWithArray:[MyTrack allWithOrder:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]];
    
    if ([_trackArr count]== 0 || !_trackArr) {
        _tableView.hidden = YES;
        return;
    }
    
    [_tableView reloadData];
}

/**
 *  删除离当前时间间距7天的历史记录
 */
-(void)deleteOldTrack
{
    [[MyTrack all] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MyTrack * trackObj = (MyTrack *)obj;
        if ([trackObj.date daysBeforeDate:[NSDate date]]>=7) {
            [trackObj delete];
            
        }
        if ([trackObj hasChanges]) {
            [trackObj save];
        }
    }];
    
}


#pragma mark - Table view data source and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_trackArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TrackCell";
    TrackCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // Configure the cell...
    if(!cell){
        cell = [TrackCell loadFromXib];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    [cell showTrackInfoWithTrack:_trackArr[indexPath.row]];
    cell.track = _trackArr[indexPath.row];
    
    cell.tapAction = ^(NSString * productId){
        
        ProductDetailInfoController * productVc = [[ProductDetailInfoController alloc] init];
        productVc.productId = productId;
        productVc.productIdArr = [NSArray arrayWithObjects:productId, nil];
        [self.navigationController pushViewController:productVc animated:YES];
    
    };

    return cell;
}




- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
