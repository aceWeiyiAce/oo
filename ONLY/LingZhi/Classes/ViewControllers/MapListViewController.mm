//
//  MapListViewController.m
//  LingZhi
//
//  Created by boguoc on 14-3-5.
//
//

#import "MapListViewController.h"
#import "MapListCell.h"
#import "MapViewController.h"
#import "MapModel.h"

#import "BMKCloudSearchInfo.h"
#import "BMapKit.h"
#import "ActivityRemindView.h"
#import "BMKSearch.h"


@interface MapListViewController ()<UITableViewDataSource,UITableViewDelegate,BMKSearchDelegate,BMKMapViewDelegate,UIScrollViewDelegate>
{
    __weak IBOutlet UITableView     *_tableView;
    ITTMaskActivityView *           _tipView;
    NSMutableArray                  *_maps;
    
    BMKSearch                       *_search;
    BMKMapView                      *_mapView;
    
    double                          _latitude;
    double                          _longitude;
    
    BOOL                            _isMore;
    
    int                             _page;
    int                             _totalPage;
}
@end

@implementation MapListViewController

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
    _tipView = [ITTMaskActivityView loadFromXib];
    // Do any additional setup after loading the view from its nib.
    _isMore = NO;
    _page = 0;
    
    _search = [[BMKSearch alloc]init];
    _search.delegate = self;
    
    _mapView = [[BMKMapView alloc]init];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    
    if (![CLLocationManager locationServicesEnabled]//确定用户的位置服务启用
        ||   [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)//位置服务是在设置中禁用
    {
        [UIAlertView promptTipViewWithTitle:@"获取定位失败请确认定位服务是否开启" message:nil cancelBtnTitle:@"确认" otherButtonTitles:nil onDismiss:^(int buttonIndex) {
            
        } onCancel:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } else {
        [self beganLocation];
    }
    
    
    if (!_maps) {
        _maps = [[NSMutableArray alloc]init];
//        [self getMapListRequest];
    }

}



- (void)beganLocation
{
    
    if (!(isReachability)) {
        ActivityRemindView *activity = [ActivityRemindView loadFromXib];
        [activity showActivityViewInView:self.view withMsg:@"联网失败,请检查网络" inSeconds:2];
        return;
    }
    
    
    [_tipView showInView:self.view withHintMessage:@"正在寻找附近门店"];
    _mapView.delegate = self;
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
}

- (void)stopLocation
{
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = NO;//显示定位图层
}

- (void)getMapListRequest
{
    [_maps addObjectsFromArray:[MapModel createTestModels]];
}

#pragma mark  - Button methods

- (IBAction)onBackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _maps.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MapListCell";
    
    MapListCell *mapListCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (mapListCell == nil) {
        mapListCell = [MapListCell loadFromXib];
    }
    [mapListCell layoutMapListCellWithModel:[_maps objectAtIndex:indexPath.row]];
    
    return mapListCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MapViewController *map = [[MapViewController alloc]init];
    map.mapModel = _maps[indexPath.row];
    [self.navigationController pushViewController:map animated:YES];
}

#pragma mark BaiduMapViewDelegate

- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
	NSLog(@"start locate");

}

- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{

	if (userLocation != nil && userLocation.location.coordinate.latitude> 0.f) {
        [self stopLocation];
        _mapView.delegate = nil;
        
        [self SearchOnlyStoreWithLatitude:userLocation.location.coordinate.latitude longitude:fabs(userLocation.location.coordinate.longitude)];
	}
	
}

- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView
{

}

- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
    
    [_tipView hide];
    [self stopLocation];
    _mapView.delegate = nil;
}

- (void)SearchOnlyStoreWithLatitude:(float)lat longitude:(float)along
{
    _latitude = lat;
    _longitude = along;
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(lat, along);
    //	BOOL flag = [_search poiSearchInCity:@"北京" withKey:@"only" pageIndex:0];
    BOOL flag = [_search poiSearchNearBy:SEARCH_CODE center:location radius:99999 pageIndex:_page];

	if (flag) {
        [_tipView showInView:self.view withHintMessage:@"正在寻找附近门店"];
	}
    else{
        
    }
}

#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKSearch*)searcher result:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error
{
    if (error == BMKErrorOk) {
		[self setMapModelWithArray:poiResultList];

	} else if (error == BMKErrorRouteAddr){
        NSLog(@"起始点有歧义");
    } else {
        
        if (error == 2) {
            _tipView.hidden = YES;
            ActivityRemindView *activity = [ActivityRemindView loadFromXib];
            [activity showActivityViewInView:self.view withMsg:@"联网失败,请检查网络" inSeconds:2];
        }
        NSLog(@"%d",error);
        // 各种情况的判断。。。
    }
}

- (void)setMapModelWithArray:(NSArray *)array
{

    BMKPoiResult* result = [array objectAtIndex:0];
    _totalPage = result.pageNum;
    NSMutableArray *data = [[NSMutableArray alloc]init];
    for (int i = 0; i < result.poiInfoList.count; i++) {
        BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
        MapModel *map = [[MapModel alloc]init];
        map.name = poi.name;
        map.address = poi.address;
        map.city = poi.city;
        map.phone = poi.phone;
        map.latitude = [NSString stringWithFormat:@"%f",poi.pt.latitude];
        map.longitude = [NSString stringWithFormat:@"%f",poi.pt.longitude];
        map.num = [self betweenMapPointWithLat:map.latitude longitude:map.longitude];
        [data addObject:map];
    }
    [_maps addObjectsFromArray:data];
    [self mapAddressSequence];
    [_tableView reloadData];
    [_tipView hide];
    _isMore = NO;
}

- (NSString *)betweenMapPointWithLat:(NSString *)lat longitude:(NSString *)longitude
{
    BMKMapPoint currentP = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(_latitude, _longitude)
);
    BMKMapPoint storeP = BMKMapPointForCoordinate(CLLocationCoordinate2DMake([lat doubleValue], [longitude doubleValue]));
    
    CLLocationDistance distance = BMKMetersBetweenMapPoints(currentP, storeP);

    return [NSString stringWithFormat:@"%.f",distance];
}

- (void)mapAddressSequence//排序
{
    [_maps sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        if ([((MapModel *)obj1).num integerValue] > [((MapModel *)obj2).num integerValue]) {
            return NSOrderedDescending;
        } else if ([((MapModel *)obj1).num integerValue] < [((MapModel *)obj2).num integerValue]) {
            return NSOrderedAscending;
        } else {
            return NSOrderedSame;
        }
    }];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!_isMore) {
        if (scrollView.contentOffset.y > scrollView.contentSize.height - _tableView.height + 60 && _longitude > 0 && _page < _totalPage) {
            _page++;
            _isMore = YES;
            [self SearchOnlyStoreWithLatitude:_latitude longitude:_longitude];
        }
    }
    
}
//
@end
