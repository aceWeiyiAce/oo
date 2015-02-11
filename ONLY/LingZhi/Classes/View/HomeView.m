//
//  HomeView.m
//  LingZhi
//
//  Created by boguoc on 14-3-7.
//
//

#import "HomeView.h"
#import "HomeListModel.h"
#import "HomeCell.h"
#import "XLCycleScrollView.h"
#import "LYBaseRequest.h"
#import "Reachability.h"
#import "UserDetailInfo.h"
#import "PKBaseRequest.h"


@interface HomeView ()<UITableViewDataSource,UITableViewDelegate,HomeCellDelegate,UIScrollViewDelegate>
{
    __weak IBOutlet UITableView     *_tableView;
    
    float                           _cellHeight;
    NSMutableArray                  *_homes;
    
    __weak IBOutlet UIButton *_completeInfoBtn;
}

-(void)showCompleteButton;

@end

@implementation HomeView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveReachability) name:kReachabilityChangedNotification object:nil];

    if (is4InchScreen()) {
        self.height = 504;
    } else {
        self.height = 416;
    }
    if (!_homes) {
        _homes = [[NSMutableArray alloc]init];
        [self getHomeRecommendListRequest];
    }
    [self showCompleteButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCompleteButton) name:KEY_SHOW_COMPLETEBTN object:nil];
}


- (IBAction)onFooterViewButton:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectFooterView)]) {
        [self.delegate didSelectFooterView];
    }
}
- (IBAction)onLingzhiWebButton:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.only.cn/"]];
}

- (void)receiveReachability
{
    if (isReachability) {
        if (_homes.count < 1) {
            [self getHomeRecommendListRequest];
        }
    }
}

- (void)getHomeRecommendListRequest
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:@"1" forKey:@"state"];
    //新增系统标签参数 at 20140704 by Pk
    [parameter setObject:AppSystemId forKey:@"brandCode"];
    [HomeRecommendListRequest requestWithParameters:parameter
                                  withIndicatorView:self
                                  withCancelSubject:@"HomeRecommendListRequest"
                                     onRequestStart:nil
                                  onRequestFinished:^(ITTBaseDataRequest *request) {
                                      if ([request isSuccess]) {
                                          [_homes addObjectsFromArray:request.handleredResult[@"keyModel"]];
                                          [_tableView reloadData];

                                      }
                                  }
                                  onRequestCanceled:nil
                                    onRequestFailed:^(ITTBaseDataRequest *request) {
                                        
                                    }];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_homes.count - 1 == indexPath.row) {
        return 363;
    } else {
        return 370;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _homes.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeListModel *model = [_homes objectAtIndex:indexPath.row];
    static NSString *identifier = @"HomeCell";
    
    HomeCell *homeCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!homeCell) {
        homeCell = [HomeCell loadFromXib];
        homeCell.delegate = self;
    }
    homeCell.pageNum = model.pageNum;
    homeCell.row = indexPath.row;
    homeCell.home = model;
    
    return homeCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"middleView" object:nil];
}

#pragma mark HomeCellDelegate

-(void)didOnPageAtId:(HomeModel *)homeModel
{
    self.hidden = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectHomeViewAtProductId:)]) {
        [self.delegate didSelectHomeViewAtProductId:homeModel];
    }
}

- (IBAction)gotoControllerAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(didClickCompleteButton)]) {
        [_delegate didClickCompleteButton];
    }
}

- (IBAction)hideCompleteView:(id)sender {
    _completeInfoBtn.hidden = YES;
}


#pragma mark -    app1.4 addMethods

-(void)showCompleteButton
{
    if (DATA_ENV.userInfo.userId.length>0) {
        _completeInfoBtn.hidden = NO;
    }else{
        _completeInfoBtn.hidden = YES;
    }
}




@end
