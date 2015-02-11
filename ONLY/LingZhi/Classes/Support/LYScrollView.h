//
//  LYScrollView.h
//  LingZhi
//
//  Created by boguoc on 14-3-26.
//
//

#import <UIKit/UIKit.h>
#import "XLPageControl.h"

@protocol LYScrollViewDelegate;

@protocol LYScrollViewDatasource <NSObject>

@required
- (NSInteger)numberOfPages;
- (UIView *)pageAtIndex:(NSInteger)index;

@end

@interface LYScrollView : UIView<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    XLPageControl *_pageControl;
    
    NSInteger _totalPages;
    NSInteger _curPage;
    
    NSMutableArray *_curViews;
}

@property (nonatomic,strong) NSString *pageNum;
@property (nonatomic,readonly) UIScrollView *scrollView;
@property (nonatomic,readonly) XLPageControl *pageControl;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign,setter = setDataource:) id<LYScrollViewDatasource> datasource;
@property (nonatomic,assign,setter = setDelegate:) id<LYScrollViewDelegate> delegate;

- (void)reloadData;
//- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index;

@end

@protocol LYScrollViewDelegate <NSObject>

@optional
- (void)didClickPage:(LYScrollView *)csView atIndex:(NSInteger)index;
- (void)didScrollPage:(LYScrollView *)csView atIndex:(NSInteger)index;
@end

