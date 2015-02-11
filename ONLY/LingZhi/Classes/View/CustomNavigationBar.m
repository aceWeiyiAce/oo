//
//  MainViewController.m
//  iTotemMinFramework
//
//  Created by  on 12-8-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomNavigationBar.h"
#import "PersonCenterView.h"
#import "CartViewController.h"
#import "MyFavoriteViewController.h"
#import "MyOrderViewController.h"
#import "AddressViewController.h"
#import "ScanningCodeViewController.h"

#import "ChangePasswordViewController.h"
#import "HomeListCell.h"

@interface CustomNavigationBar ()<PersonCenterViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    __weak IBOutlet UIView          *_contentView;
    __weak IBOutlet UIView          *_moreView;
    __weak IBOutlet UIView          *_moreDetailView;
    IBOutlet UIView                 *_arrowView;
    __weak IBOutlet UITableView     *_moreTableView;
    
    HomeListCell                    *_moreCell;
    
    NSMutableArray                  *_moreArray;
    NSMutableArray                  *_isSelectArray;
    float                           _scorllY;
}
@end

@implementation CustomNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomNavigationBar" owner:self options:nil];
        self = [nib objectAtIndex:0];
        
        //        _message.width = self.bounds.size.width;
        if (!_moreArray) {
            _moreArray = [[NSMutableArray alloc]initWithObjects:@"特别推荐",@"新品上市",@"牛仔裤", @"皮衣", @"毛衣", @"皮靴", @"裙子", @"外套/西装", @"配饰",@"牛仔裤", @"皮衣", @"毛衣", @"皮靴", @"裙子", @"外套/西装", @"配饰",  nil];
            _isSelectArray = [[NSMutableArray alloc]initWithObjects:@"NO",@"NO",@"NO",@"NO",@"NO",@"NO",@"NO",@"NO",@"NO",@"NO",@"NO",@"NO",@"NO",@"NO",@"NO",@"NO", nil];
        }
        

        
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    _moreView.hidden = !_moreView.hidden;
}

#pragma mark - Button methods

- (IBAction)onPersonCenterButton:(id)sender
{
    [[PersonCenterView loadFromXib] showPersonCenterViewWithView:_contentView delegate:self];
}

- (IBAction)onChooseMoreButton:(id)sender
{
    NSLog(@"%d",_moreTableView.hidden);
    _moreView.hidden = !_moreView.hidden;
    NSLog(@"%d",_moreTableView.hidden);
    if (!_moreView.hidden) {
        [self openOrCloseMoreDetailViewIsOpen:NO];
    }
    
}

- (void)openOrCloseMoreDetailViewIsOpen:(BOOL)open
{
    [UIView animateWithDuration:.1f
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
    return _moreArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    
//    if (tableView == _moreTableView) {
//        _moreCell = [HomeListCell loadFromXib];
//        [_moreCell layoutHomeListCellWith:[_moreArray objectAtIndex:indexPath.row] isSelect:[_isSelectArray objectAtIndex:indexPath.row]];
//        return _moreCell;
//    } else {
//        return nil;
//    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self openOrCloseMoreDetailViewIsOpen:YES];
//    _arrowView.top = 44 * indexPath.row - _scorllY + 2;
//    
//    for (int i = 0; i < _isSelectArray.count; i ++) {
//        if (i == indexPath.row) {
//            NSString * str = [_isSelectArray objectAtIndex:indexPath.row];
//            str = @"YES";
//            [_isSelectArray removeObjectAtIndex:i];
//            [_isSelectArray insertObject:str atIndex:i];
//        } else {
//            NSString * str = [_isSelectArray objectAtIndex:indexPath.row];
//            str = @"NO";
//            [_isSelectArray removeObjectAtIndex:i];
//            [_isSelectArray insertObject:str atIndex:i];
//        }
//    }
//    [_moreTableView reloadData];
}

#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _arrowView.top = _arrowView.top - (scrollView.contentOffset.y - _scorllY);
    _scorllY = scrollView.contentOffset.y;
}

#pragma mark - PersonCenterViewDelegate

-(void)didOnPersonCenterButtonWithType:(PersonCenterButtonType)type
{
    if (!self.navigationVC) {
        return;
    }
    switch (type) {
        case kPersonCenterCart:
        {
            CartViewController *cart = [[CartViewController alloc]init];
            [self.navigationVC pushViewController:cart animated:YES];
        }
            break;
        case kPersonCenterFavorite:
        {
            
            MyFavoriteViewController *favorite = [[MyFavoriteViewController alloc]init];
            [self.navigationVC pushViewController:favorite animated:YES];
        }
            break;
        case kPersonCenterOrder:
        {
            MyOrderViewController *order = [[MyOrderViewController alloc] init];
            [self.navigationVC pushViewController:order animated:YES];
        }
            break;
        case kPersonCenterAddress:
        {
            AddressViewController *address = [[AddressViewController alloc]init];
            [self.navigationVC pushViewController:address animated:YES];
        }
            break;
        case kPersonCenterPassword:
        {
            ChangePasswordViewController *password = [[ChangePasswordViewController alloc]init];
            [self.navigationVC pushViewController:password animated:YES];
        }
            break;
        case kPersonCenterLogin:
        {

        }
            break;
        default:
            break;
    }
}

@end
