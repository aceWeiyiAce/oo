//
//  MainViewController.m
//  iTotemMinFramework
//
//  Created by  on 12-8-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "ProductListViewController.h"
#import "PersonCenterView.h"
#import "CartViewController.h"
#import "MyFavoriteViewController.h"
#import "MyOrderViewController.h"
#import "AddressViewController.h"
#import "AddressEditViewController.h"
#import "ScanningCodeViewController.h"
#import "ChangePasswordViewController.h"
#import "HomeListCell.h"
#import "HomeView.h"
#import "ClassificationModel.h"
#import "SecondClassModel.h"
#import "AboutUsViewController.h"
#import "SearchViewController.h"
#import "ReturnGoodsViewController.h"
#import "NotificationViewController.h"
#import "LYBaseRequest.h"

#import "BaseDataInitManager.h"
#import "PhoneView.h"
#import "MyTrackViewController.h"
#import "MapListViewController.h"
#import "CustomAlertView.h"

#import "MapListViewController.h"
#import "AppDelegate.h"

#import "LoadingViewController.h"
#import "ObjectiveRecord.h"
#import "MyTrack.h"
#import "Reachability.h"
#import "CustomDefaultView.h"
#import "LogisticsTrackingViewController.h"
#import "ReturnGoodsViewController.h"
#import "UITableView+Wave.h"
#import "CompleteSelfInfomationController.h"

#import "ChangePsdViewController.h"
#import "GoodsUpViewController.h"


@interface MainViewController ()<PersonCenterViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,HomeViewDelegate>
{
    __weak IBOutlet UIView          *_contentView;
    __weak IBOutlet UIView          *_moreView;
    __weak IBOutlet UIView          *_moreDetailView;
    IBOutlet UIView                 *_arrowView;
    __weak IBOutlet UITableView     *_moreTableView;
    __weak IBOutlet UITableView     *_secondTableView;

    HomeListCell                    *_moreCell;
    
    NSMutableArray                  *_firstArray;
    NSMutableArray                  *_secondArray;
    ClassificationModel             *_classificationModel;
    HomeView                        *_home;
    MoreFunctionType                _moreFunctionType;
    BOOL                            _isMoreChoose;
    NSString                        *_sortType;
    NSInteger                       _productPage;
    HomeModel                        *_homeModel;
    float                           _scorllY;
    BOOL                            _isBackFromProductDetail;
    
    CustomDefaultView               *_defaultView;
    BOOL                            _hasDefaultView;
}
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveReachability) name:checkMainData object:nil];
    }
    return self;
}

//如果之前是断网的,那么当重新连接网络之后,判断tableView有没有数据,如果没有数据的话,就重新请求
- (void)receiveReachability
{
    if (isReachability) {
        if (_firstArray.count<1) {
            [self initCategoryListArray];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addDefaultImageView];

    _hasDefaultView = YES;
    _isBackFromProductDetail = NO;
    _isMoreChoose = NO;
    _productPage = 1;
    
//在loadFromXib方法中进行首页的网络请求
    _home = [HomeView loadFromXib];
    _home.delegate = self;
    _home.top = 44;
    _home.height = _contentView.height - 44;
    [_contentView addSubview:_home];
    [_contentView bringSubviewToFront:_moreView];
    
    [self initCategoryListArray];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    //update by pk at 20140611
//    if (_isBackFromProductDetail) {
//        _isBackFromProductDetail = NO;
//        return;
//    }

    _home.hidden = NO;
    _moreView.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{

    [self openOrCloseMoreDetailViewIsOpen:NO];
    _classificationModel.isSelect = @"0";
}

- (void)addDefaultImageView
{
    if (_hasDefaultView) {
        _defaultView = [CustomDefaultView loadFromXib];
        [_defaultView showCustomDefaultViewWithView:self.view];
    }
}

- (void)getCategoryListRequest
{
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"state",AppSystemId,@"brandCode", nil];
    [GetCategoryListRequest requestWithParameters:dic
                                withIndicatorView:_moreView
                                withCancelSubject:@"GetCategoryListRequest"
                                   onRequestStart:nil
                                onRequestFinished:^(ITTBaseDataRequest *request) {
                                    if ([request isSuccess]) {
                                        
                                        [_defaultView removeCustomDefaultView];
                                        _defaultView = nil;
                                        _hasDefaultView = NO;
                                        ITTDPRINT(@"--------------%@",request.handleredResult);
                                        [_firstArray removeAllObjects];
                                        [_firstArray addObjectsFromArray: request.handleredResult[@"keyModel"]];
                                        
//                                        [_moreTableView reloadData];
                                        [_moreTableView reloadDataAnimateWithWave:1];
                                    }
                                }
                                onRequestCanceled:nil
                                  onRequestFailed:^(ITTBaseDataRequest *request) {
//                                      ActivityRemindView *activity = [ActivityRemindView loadFromXib];
//                                      [activity showActivityViewInView:self.view withMsg:@"请检查网络连接" inSeconds:2];
//                                      [self getCategoryListRequest];
                                  }];
}

- (void)initCategoryListArray
{
    if (!_firstArray) {
        _firstArray = [[NSMutableArray alloc]init];
        _secondArray = [[NSMutableArray alloc]init];
        [self getCategoryListRequest];
        return;
    }
    if (_firstArray.count < 1) {
        [self getCategoryListRequest];
    }
}

#pragma mark - Button methods

- (IBAction)onPersonCenterButton:(id)sender
{
    if ([self isLogin]) {
//        [[PersonCenterView loadFromXib] showPersonCenterViewWithView:_contentView delegate:self];
        LoadingViewController *loadViewController = [[LoadingViewController alloc]initWithNibName:@"LoadingViewController" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:loadViewController animated:YES];
//        _homeModel = [[HomeModel alloc] init];
//        _homeModel.pId = @"0";
//        _homeModel.productClassId = _classificationModel.classId;
//        _productPage = 1;
//        
//        ProductListViewController *product = [[ProductListViewController alloc]init];
//        _isBackFromProductDetail = YES;
//        product.home = _homeModel;
//        
//        [self.navigationController pushViewController:product animated:NO];
    }else
    {
    GoodsUpViewController *goodsUpViewController = [[GoodsUpViewController alloc]initWithNibName:@"GoodsUpViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:goodsUpViewController animated:YES];
    }
}

- (IBAction)onZXCodeButton:(id)sender
{
    _isBackFromProductDetail = YES;
    ScanningCodeViewController *code = [[ScanningCodeViewController alloc]init];
    [self.navigationController pushViewController:code animated:YES];
}

- (IBAction)onChooseMoreButton:(id)sender
{
    if (!_moreView.hidden) {
        _classificationModel.isSelect = @"0";
//        [_moreTableView reloadData];
        [self openOrCloseMoreDetailViewIsOpen:NO];
    }
    _moreView.hidden = !_moreView.hidden;
    if (!_moreView.hidden) {
        NSLog(@"_moreTableView.frame = %@",NSStringFromCGRect(_moreTableView.frame));
        if (_firstArray.count > 0) {
            [_moreTableView reloadDataAnimateWithWave:1];
        }
    }
}

- (void)openOrCloseMoreDetailViewIsOpen:(BOOL)open
{
    [UIView animateWithDuration:.3f
                     animations:^{
                         if (open) {
                             _moreDetailView.left = 140;
                             _arrowView.left = 140;
                         } else {
                             _moreDetailView.left = _moreView.right;
                             _moreTableView.width = 320;
                         }
    }
                     completion:^(BOOL finished) {
                         if (open) {
                             [_moreView addSubview:_arrowView];
                         } else {
                             [_arrowView removeFromSuperview];
                         }
                     }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _moreTableView) {
        return _firstArray.count;
    } else if (tableView == _secondTableView){
        return _secondArray.count;
    } else {
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _moreTableView) {
        static NSString *classIdentifier = @"HomeListCell";

        HomeListCell *homeCell = [tableView dequeueReusableCellWithIdentifier:classIdentifier];
        if (!homeCell) {
            homeCell = [HomeListCell loadFromXib];
        }
        ClassificationModel *model = [_firstArray objectAtIndex:indexPath.row];
        [homeCell layoutHomeListCellWith:model];
        
        return homeCell;
        
    } else if (tableView == _secondTableView){
        static NSString *secondIdentifier = @"secondCell";
        
        UITableViewCell *secondCell = [tableView dequeueReusableCellWithIdentifier:secondIdentifier];
        if (!secondCell) {
            secondCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:secondIdentifier];
        }
        secondCell.backgroundColor = [UIColor clearColor];
        secondCell.selectionStyle = UITableViewCellSelectionStyleNone;
        HomeModel *model = [_secondArray objectAtIndex:indexPath.row];
        secondCell.textLabel.text = model.className;
        secondCell.textLabel.font = [UIFont systemFontOfSize:12.0f];
        secondCell.textLabel.textColor = [UIColor grayColor];
        return secondCell;
    }
    else {
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _moreTableView) {
        if (0 == indexPath.row) {
            _home.hidden = NO;
            _moreView.hidden = YES;
            _classificationModel.isSelect = @"0";
//            _classificationModel = [_firstArray objectAtIndex:indexPath.row];
//            _classificationModel.isSelect = @"1";
            [self openOrCloseMoreDetailViewIsOpen:NO];
            [_moreTableView reloadData];
            return;
        }
        
        
        _classificationModel.isSelect = @"0";
        _classificationModel = [_firstArray objectAtIndex:indexPath.row];
        _classificationModel.isSelect = @"1";
        
        [_moreTableView reloadData];
        
        [_secondArray removeAllObjects];
        [_secondArray addObjectsFromArray:_classificationModel.classArray];
        [_secondTableView reloadData];
        
        if (_secondArray.count == 0) {
            _homeModel = [[HomeModel alloc] init];
            _homeModel.pId = @"0";
            _homeModel.productClassId = _classificationModel.classId;
            _productPage = 1;
            
            ProductListViewController *product = [[ProductListViewController alloc]init];
            _isBackFromProductDetail = YES;
            product.home = _homeModel;
            
            [self.navigationController pushViewController:product animated:NO];
            return;
        }
        
        [self openOrCloseMoreDetailViewIsOpen:YES];
        _arrowView.top = 40 * indexPath.row - _scorllY;

        
        if (indexPath.row == _firstArray.count-1) {
            _isMoreChoose = YES;
        } else {
            _isMoreChoose = NO;
        }
    } else if (tableView == _secondTableView){
        if (_isMoreChoose) {
            _moreFunctionType = indexPath.row;
            [self chooesMoreInControll];
        } else {
            _homeModel = [_secondArray objectAtIndex:indexPath.row];
            _productPage = 1;

            ProductListViewController *product = [[ProductListViewController alloc]init];
            _isBackFromProductDetail = YES;
            product.home = _homeModel;
            
            [self.navigationController pushViewController:product animated:NO];
        }
    }
}

#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _moreTableView) {
        _arrowView.top = _arrowView.top - (scrollView.contentOffset.y - _scorllY);
        _scorllY = scrollView.contentOffset.y;
    }
}

#pragma mark - HomeViewDelegate

-(void)didSelectHomeViewAtProductId:(HomeModel *)homeModel
{
    [_defaultView removeCustomDefaultView];
    _defaultView = nil;
    _hasDefaultView = NO;
    
    _homeModel = homeModel;
    _productPage = 1;
    ProductListViewController *product = [[ProductListViewController alloc]init];
    product.home = homeModel;
    [self.navigationController pushViewController:product animated:NO];
}

-(void)didSelectFooterView
{
    ReturnGoodsViewController *directions = [[ReturnGoodsViewController alloc]init];
    [self.navigationController pushViewController:directions animated:YES];
}


-(void)didClickCompleteButton
{
    CompleteSelfInfomationController * comVC = [[CompleteSelfInfomationController alloc] init];
    comVC.isShowSaveText = YES;
    [self.navigationController pushViewController:comVC animated:YES];
}

#pragma mark - MoreFunction
- (void)chooesMoreInControll
{
    _isBackFromProductDetail = YES;

    switch (_moreFunctionType) {
        case kMoreMyTrack:
        {
            MyTrackViewController *myTrack = [[MyTrackViewController alloc]init];
            [self.navigationController pushViewController:myTrack animated:YES];
        }
            break;
        case kMoreMap:
        {
            MapListViewController *map = [[MapListViewController alloc]init];
            [self.navigationController pushViewController:map animated:YES];
        }
            break;
        case kMoreClearMemory:
        {
            [UIAlertView promptTipViewWithTitle:Nil message:@"即将清除缓存..." cancelBtnTitle:@"取消" otherButtonTitles:@[@"确定"] onDismiss:^(int buttonIndex) {
                
                CoreDataManagerGlobalSetting(@"SqlModel", @"coreData.sqlite");
                [MyTrack deleteAll];
                
            } onCancel:^{
                
            }];
            
        }
            break;
        case kMoreExchange:
        {
            ReturnGoodsViewController *score = [[ReturnGoodsViewController alloc]init];
            [self.navigationController pushViewController:score animated:YES];
        }
            break;
        case kMoreNotification:
        {
            NotificationViewController *noti = [[NotificationViewController alloc]init];
            [self.navigationController pushViewController:noti animated:YES];
        }
            break;
        case kMoreAbout:
        {
            AboutUsViewController *about = [[AboutUsViewController alloc]init];
            [self.navigationController pushViewController:about animated:YES];
        }
            break;
        case kMoreContact:
        {
            [RequestToGetContactTel requestWithParameters:nil
                                        withIndicatorView:self.view
                                        withCancelSubject:@"RequestToGetContactTel"
                                           onRequestStart:nil
                                        onRequestFinished:^(ITTBaseDataRequest *request) {
                                            if ([request isSuccess]) {
                                                NSString *phoneNum = request.handleredResult[@"data"][@"preSales"];
 
                                                if ([[[UIDevice currentDevice] model] isEqualToString:@"iPhone"]) {
                                                    PhoneView *phone = [PhoneView loadFromXib];
                                                    [phone showPhoneViewWithSuperView:self.view title:@"联系我们" content: phoneNum oneButtonText:@"呼叫" twoButtonText:@"取消"];
                                                } else {
                                                    CustomAlertView *alert = [CustomAlertView loadFromXib];
                                                    [alert showCustomViewWithSuperView:self.view title:@"联系我们" content:@"设备不支持呼叫功能" oneButtonText:@"ok" twoButtonText:nil oneButtonActionBlock:^{
                                                        
                                                    } twoButtonBlock:^{
                                                        
                                                    }];
                                                }
                                            }
                                        } onRequestCanceled:nil
                                          onRequestFailed:^(ITTBaseDataRequest *request) {
                                              
                                          }];
        }
            break;
        case kMoreScore:
        {
            NSString *ios7Str = @"itms-apps://itunes.apple.com/app/id847986160";
            NSString *ios7before =  [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=847986160"];
            
            if(IOS7) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ios7Str]];
            } else {
                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ios7before]];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - PersonCenterViewDelegate

-(void)didOnPersonCenterButtonWithType:(PersonCenterButtonType)type
{
    _isBackFromProductDetail = YES;
    
    switch (type) {
        case kPersonCenterCart:
        {
            if (DATA_ENV.userInfo.userId.length > 1) {
                CartViewController *cart = [[CartViewController alloc]init];
                [self.navigationController pushViewController:cart animated:YES];
            } else {
                [self presentLoginViewControllerWithString:@"CartViewController"];
            }
        }
            break;
        case kPersonCenterFavorite:
        {
            if (DATA_ENV.userInfo.userId.length > 1) {
                MyFavoriteViewController *favorite = [[MyFavoriteViewController alloc]init];
                [self.navigationController pushViewController:favorite animated:YES];            } else {
                [self presentLoginViewControllerWithString:@"MyFavoriteViewController"];
            }

        }
            break;
        case kPersonCenterOrder:
        {
            if (DATA_ENV.userInfo.userId.length > 1) {
                MyOrderViewController *order = [[MyOrderViewController alloc] init];
                [self.navigationController pushViewController:order animated:YES];
            } else {
                    [self presentLoginViewControllerWithString:@"MyOrderViewController"];
            }
        }
            break;
        case kPersonCenterAddress:
        {
            if (DATA_ENV.userInfo.userId.length > 1) {
                AddressViewController *address = [[AddressViewController alloc]init];
//                address.isHomePush = YES;
//                AddressEditViewController *address = [[AddressEditViewController alloc]init];
                [self.navigationController pushViewController:address animated:YES];
            } else {
                [self presentLoginViewControllerWithString:@"AddressViewController"];
            }
        }
            break;
        case kPersonCenterPassword:
        {
            if (DATA_ENV.userInfo.userId.length > 1) {
                ChangePsdViewController *psd = [[ChangePsdViewController alloc] init];
//                ChangePasswordViewController *password = [[ChangePasswordViewController alloc]init];
                [self.navigationController pushViewController:psd animated:YES];
            } else {
                [self presentLoginViewControllerWithString:@"ChangePasswordViewController"];
            }
        }
            break;
        case kPersonCenterLogin:
        {
            if (DATA_ENV.userInfo.userId.length > 1) {
                
                [UIAlertView promptTipViewWithTitle:nil message:@"确认是否注销" cancelBtnTitle:@"取消" otherButtonTitles:@[@"确定"] onDismiss:^(int buttonIndex) {
                    UserInfo *userInfo = DATA_ENV.userInfo;
                    userInfo.userId = nil;
                    DATA_ENV.userInfo = userInfo;
                    ActivityRemindView *activity = [ActivityRemindView loadFromXib];
                    AddressModel *address = DATA_ENV.address;
                    address.addressId = nil;
                    DATA_ENV.address = address;
                    
                    [activity showActivityViewInView:self.view withMsg:@"注销成功" inSeconds:2];
                    [[NSNotificationCenter defaultCenter] postNotificationName:KEY_SHOW_COMPLETEBTN object:nil];
                } onCancel:^{
                    
                }];
                
//                UserInfo *userInfo = DATA_ENV.userInfo;
//                userInfo.userId = nil;
//                DATA_ENV.userInfo = userInfo;
//                ActivityRemindView *activity = [ActivityRemindView loadFromXib];
//                [activity showActivityViewInView:self.view withMsg:@"注销成功" inSeconds:2];
            } else {
                [self presentLoginViewControllerWithString:nil];
            }
        }
            break;
        default:
            break;
    }
}

- (void)presentLoginViewControllerWithString:(NSString *)name
{
    LoadingViewController *login = [[LoadingViewController alloc]init];
//    login.controllerName = name;
    [self.navigationController pushViewController:login animated:YES];
}
/**
 *  检测用户是否已经登录
 *
 *  @return
 */
-(BOOL)isLogin
{
    if ([USER_DEFAULT valueForKey:UserNameKey]!=Nil && [USER_DEFAULT valueForKey:PWDKey]!=Nil) {
        return YES;
    }
    return NO;
}

@end
