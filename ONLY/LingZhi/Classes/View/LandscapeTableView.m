//
//  LandscapeTableView.m
//  FengHui_iPad
//
//  Created by iPhuan on 13-1-5.
//  Copyright (c) 2013年 iTotem. All rights reserved.
//

#import "LandscapeTableView.h"

#define DEFUALT_FRAME   CGRectMake(0, 0, 20, 20)

@interface LandscapeTableView () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    UIDeviceOrientation _orientation;
}

@end

@implementation LandscapeTableView

//- (void)dealloc
//{
//    [_tableView release];
//    [super dealloc];
//}


- (id)init
{
    return [self initWithFrame:DEFUALT_FRAME];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.width)];
    _tableView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.transform = CGAffineTransformMakeRotation(-M_PI/2);
    [self addSubview:_tableView];
}

#pragma mark - Set

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _tableView.transform = CGAffineTransformIdentity;
    _tableView.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.width);
    _tableView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _tableView.transform = CGAffineTransformMakeRotation(-M_PI/2);
}

- (void)setFrame:(CGRect)frame animateWithDuration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        [super setFrame:frame];
    }];
    _tableView.transform = CGAffineTransformIdentity;

    [UIView animateWithDuration:duration animations:^{
        _tableView.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.width);
        _tableView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    }];
    
    _tableView.transform = CGAffineTransformMakeRotation(-M_PI/2);
}

- (void)setAllowsSelection:(BOOL)allowsSelection
{
    _tableView.allowsSelection = allowsSelection;
}

- (void)setContentOffset:(CGPoint)contentOffset
{
    _tableView.contentOffset = CGPointMake(0, contentOffset.x);
}

- (void)setContentSize:(CGSize)contentSize
{
    _tableView.contentSize = CGSizeMake(_tableView.frame.size.width, contentSize.width);
}

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    _tableView.contentInset = UIEdgeInsetsMake(contentInset.left, 0, contentInset.right, 0);
//    self.contentOffset = CGPointMake(-contentInset.left, 0);
}

- (void)setBounces:(BOOL)bounces
{
    _tableView.bounces = bounces;
}

- (void)setAlwaysBounceHorizontal:(BOOL)alwaysBounceHorizontal
{
    _tableView.alwaysBounceHorizontal = alwaysBounceHorizontal;
}

- (void)setPagingEnabled:(BOOL)pagingEnabled
{
    _tableView.pagingEnabled = pagingEnabled;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled
{
    _tableView.scrollEnabled = scrollEnabled;
}

- (void)setDecelerationRate:(float)decelerationRate
{
    _tableView.decelerationRate = decelerationRate;
}

//UIView property
- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    [super setUserInteractionEnabled:userInteractionEnabled];
    _tableView.userInteractionEnabled = userInteractionEnabled;
}

- (void)setClipsToBounds:(BOOL)clipsToBounds
{
    [super setClipsToBounds:clipsToBounds];
    _tableView.clipsToBounds = clipsToBounds;
}

//UIView+ITTAdditions

- (void)setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    super.frame = frame;
}

- (void)setTop:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    super.frame = frame;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    super.frame = frame;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    super.frame = frame;
}

//- (void)setWidth:(CGFloat)width {
//    CGRect frame = self.frame;
//    frame.size.width = width;
//    super.frame = frame;
//}
//
//- (void)setHeight:(CGFloat)height {
//    CGRect frame = self.frame;
//    frame.size.height = height;
//    super.frame = frame;
//}

#pragma mark - Get

- (BOOL)allowsSelection
{
    return _tableView.allowsSelection;
}

- (CGPoint)contentOffset
{
    return CGPointMake(_tableView.contentOffset.y, 0);
}

- (CGSize)contentSize
{
    return CGSizeMake(_tableView.contentSize.height, _tableView.frame.size.width);
}

- (UIEdgeInsets)contentInset
{
    return UIEdgeInsetsMake(0, _tableView.contentInset.top,0, _tableView.contentInset.bottom);
}

- (BOOL)bounces
{
    return _tableView.bounces;
}

- (BOOL)alwaysBounceHorizontal
{
    return _tableView.alwaysBounceVertical;
}

- (BOOL)isPagingEnabled
{
    return _tableView.pagingEnabled;
}

- (BOOL)isScrollEnabled
{
    return _tableView.scrollEnabled;
}

- (BOOL)isTracking
{
    return _tableView.tracking;
}

- (BOOL)isDragging
{
    return _tableView.dragging;
}

- (BOOL)isDecelerating
{
    return _tableView.decelerating;
}



#pragma mark - Public

- (void)reloadData
{
    [_tableView reloadData];
}
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    return [_tableView dequeueReusableCellWithIdentifier:identifier];
}


- (void)reloadDataWithRowAnimation:(UITableViewRowAnimation)animation
{
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:animation];
}
- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [_tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}


- (NSIndexPath *)indexPathForCell:(UITableViewCell *)cell
{
    return [_tableView indexPathForCell:cell];
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_tableView cellForRowAtIndexPath:indexPath];
}



- (NSArray *)visibleCells
{
    return [_tableView visibleCells];
}

- (NSArray *)indexPathsForVisibleRows
{
    return [_tableView indexPathsForVisibleRows];
}


- (NSIndexPath *)indexPathForSelectedRow
{
    return [_tableView indexPathForSelectedRow];
}


- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition
{
    [_tableView selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
}
- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    [_tableView deselectRowAtIndexPath:indexPath animated:animated];
}


- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}
- (void)scrollToNearestSelectedRowAtScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    [_tableView scrollToNearestSelectedRowAtScrollPosition:scrollPosition animated:animated];
}

#pragma mark - UIScrollView Method

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated
{
    [_tableView setContentOffset:CGPointMake(0, contentOffset.x) animated:animated];
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataSource && [_dataSource respondsToSelector:@selector(numberOfRowsInLandscapeTableView:)])
    {
        return [_dataSource numberOfRowsInLandscapeTableView:self];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (_dataSource && [_dataSource respondsToSelector:@selector(landscapeTableView:cellForRowAtIndexPath:)])
    {
        cell = [_dataSource landscapeTableView:self cellForRowAtIndexPath:indexPath];

    }
    else
    {
        static NSString *CellIdentifier = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.transform = CGAffineTransformMakeRotation(M_PI/2);

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataSource && [_dataSource respondsToSelector:@selector(landscapeTableView:widthForRowAtIndexPath:)])
    {
        return [_dataSource landscapeTableView:self widthForRowAtIndexPath:indexPath];
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(landscapeTableView:didSelectRowAtIndexPath:)])
    {
        [_delegate landscapeTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(landscapeTableView:didDeselectRowAtIndexPath:)])
    {
        [_delegate landscapeTableView:self didDeselectRowAtIndexPath:indexPath];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_delegate && [_delegate respondsToSelector:@selector(landscapeTableViewDidScroll:)])
    {
        [_delegate landscapeTableViewDidScroll:self];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_delegate && [_delegate respondsToSelector:@selector(landscapeTableViewWillBeginDragging:)])
    {
        [_delegate landscapeTableViewWillBeginDragging:self];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_delegate && [_delegate respondsToSelector:@selector(landscapeTableViewDidEndDragging:willDecelerate:)])
    {
        [_delegate landscapeTableViewDidEndDragging:self willDecelerate:decelerate];
    }
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (_delegate && [_delegate respondsToSelector:@selector(landscapeTableViewWillBeginDecelerating:)])
    {
        [_delegate landscapeTableViewWillBeginDecelerating:self];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_delegate && [_delegate respondsToSelector:@selector(landscapeTableViewDidEndDecelerating:)])
    {
        [_delegate landscapeTableViewDidEndDecelerating:self];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (_delegate && [_delegate respondsToSelector:@selector(landscapeTableViewDidEndScrollingAnimation:)])
    {
        [_delegate landscapeTableViewDidEndScrollingAnimation:self];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    if (_delegate && [_delegate respondsToSelector:@selector(landscapeTableViewShouldScrollToTop:)])
    {
        return [_delegate landscapeTableViewShouldScrollToTop:self];
    }
    
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    if (_delegate && [_delegate respondsToSelector:@selector(landscapeTableViewDidScrollToTop:)])
    {
        [_delegate landscapeTableViewDidScrollToTop:self];
    }
}




@end
