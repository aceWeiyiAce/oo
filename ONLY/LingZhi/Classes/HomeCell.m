//
//  HomeCell.m
//  LingZhi
//
//  Created by boguoc on 14-3-7.
//
//

#import "HomeCell.h"
#import "LYScrollView.h"
#import "HomeCellView.h"

@interface HomeCell ()<LYScrollViewDelegate,LYScrollViewDatasource>
{
    __weak IBOutlet UIView      *_cellContentView;
    LYScrollView *xlCycle;
    UILabel                     *_middleLabel;
    UILabel                     *_rightLabel;
}

@end

@implementation HomeCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    xlCycle = [[LYScrollView alloc]initWithFrame:self.bounds];
    xlCycle.pageNum = _pageNum;
    xlCycle.delegate = self;
    xlCycle.datasource = self;
    [_cellContentView addSubview:xlCycle];
}

-(void)setHome:(HomeListModel *)home
{
    _home = home;

    if (is4InchScreen()) {
        self.bounds = CGRectMake(0, 0, 320, 504);
    } else {
        self.bounds = CGRectMake(0, 0, 320, 416);
    }
    [xlCycle reloadData];
//    LYScrollView *xlCycle = [[LYScrollView alloc]initWithFrame:self.bounds];
//    xlCycle.pageNum = _pageNum;
//    xlCycle.delegate = self;
//    xlCycle.datasource = self;
//    [_cellContentView addSubview:xlCycle];
}

#pragma mark - LYScrollViewDatasource && LYScrollViewDelegate

-(NSInteger)numberOfPages
{
    return _home.homes.count;
}

-(UIView *)pageAtIndex:(NSInteger)index
{
    HomeModel *homeModel = [_home.homes objectAtIndex:index];

    HomeCellView *cell = [HomeCellView loadFromXib];
    cell.index = index;
    [cell layoutHomeCellView:homeModel];
    
    return cell;
}

-(void)didClickPage:(LYScrollView *)csView atIndex:(NSInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didOnPageAtId:)]) {
        HomeModel *homeModel = [_home.homes objectAtIndex:index];
        [self.delegate didOnPageAtId:homeModel];
    }
}

-(void)didScrollPage:(LYScrollView *)csView atIndex:(NSInteger)index
{
    _home.pageNum = [NSString stringWithFormat:@"%d",index];
}


@end
