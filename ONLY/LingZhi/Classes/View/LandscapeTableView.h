//
//  LandscapeTableView.h
//  FengHui_iPad
//
//  Created by iPhuan on 13-1-5.
//  Copyright (c) 2013年 iTotem. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LandscapeTableView;
@protocol LandscapeTableViewDataSource;

@protocol LandscapeTableViewDelegate <NSObject>

@optional
- (void)landscapeTableView:(LandscapeTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)landscapeTableView:(LandscapeTableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;


- (void)landscapeTableViewDidScroll:(LandscapeTableView *)tableView;
- (void)landscapeTableViewWillBeginDragging:(LandscapeTableView *)tableView;
- (void)landscapeTableViewDidEndDragging:(LandscapeTableView *)tableView willDecelerate:(BOOL)decelerate;
- (void)landscapeTableViewWillBeginDecelerating:(LandscapeTableView *)tableView;
- (void)landscapeTableViewDidEndDecelerating:(LandscapeTableView *)tableView;

- (void)landscapeTableViewDidEndScrollingAnimation:(LandscapeTableView *)tableView;

- (BOOL)landscapeTableViewShouldScrollToTop:(LandscapeTableView *)tableView;
- (void)landscapeTableViewDidScrollToTop:(LandscapeTableView *)tableView;


@end


@interface LandscapeTableView : UIView

@property (nonatomic,assign) IBOutlet id <LandscapeTableViewDelegate> delegate;
@property (nonatomic,assign) IBOutlet id <LandscapeTableViewDataSource> dataSource;
@property(nonatomic) BOOL allowsSelection;

//UIScrollView property
@property (nonatomic) CGPoint contentOffset;
@property (nonatomic) CGSize  contentSize;
@property (nonatomic) UIEdgeInsets contentInset;
@property (nonatomic) BOOL bounces; 
@property (nonatomic) BOOL alwaysBounceHorizontal;
@property (nonatomic,getter=isPagingEnabled) BOOL pagingEnabled;
@property (nonatomic,getter=isScrollEnabled) BOOL scrollEnabled;
@property (nonatomic) float decelerationRate NS_AVAILABLE_IOS(3_0);
@property (nonatomic,readonly,getter=isTracking) BOOL tracking;
@property (nonatomic,readonly,getter=isDragging) BOOL dragging;
@property (nonatomic,readonly,getter=isDecelerating) BOOL decelerating;



- (void)reloadData;
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;

- (void)reloadDataWithRowAnimation:(UITableViewRowAnimation)animation;
- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;


- (NSIndexPath *)indexPathForCell:(UITableViewCell *)cell;
- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSArray *)visibleCells;
- (NSArray *)indexPathsForVisibleRows;

- (NSIndexPath *)indexPathForSelectedRow;

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;
- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;
- (void)scrollToNearestSelectedRowAtScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;

//UIScrollView Method
- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;

- (void)setFrame:(CGRect)frame animateWithDuration:(NSTimeInterval)duration;


@end


@protocol LandscapeTableViewDataSource<NSObject>

@required

- (NSInteger)numberOfRowsInLandscapeTableView:(LandscapeTableView *)tableView;
- (CGFloat)landscapeTableView:(LandscapeTableView *)tableView widthForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)landscapeTableView:(LandscapeTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

