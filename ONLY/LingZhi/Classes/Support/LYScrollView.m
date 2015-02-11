//
//  LYScrollView.m
//  LingZhi
//
//  Created by boguoc on 14-3-26.
//
//

#import "LYScrollView.h"

@implementation LYScrollView

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize currentPage = _curPage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentOffset = CGPointMake(0, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = YES;
        [self addSubview:_scrollView];
        
        CGRect rect = self.bounds;
        rect.origin.y = 10;
        rect.origin.x = 20;
        rect.size.height = 30;
        _pageControl = [[XLPageControl alloc] initWithFrame:rect];
        _pageControl.userInteractionEnabled = NO;
        
        [self addSubview:_pageControl];
//        _curPage = [_pageNum integerValue];

    }
    return self;
}

-(void)setDataource:(id<LYScrollViewDatasource>)datasource
{
    _curPage = [_pageNum integerValue];

    _datasource = datasource;
    [self reloadData];
}

- (void)reloadData
{
    _totalPages = [_datasource numberOfPages];
    if (_totalPages == 0) {
        return;
    }
    _scrollView.contentSize = CGSizeMake(self.bounds.size.width * _totalPages + 0.5, self.bounds.size.height);
    _pageControl.numberOfPages = _totalPages;
    _pageControl.currentPage = _curPage;

    [self loadData];
}

- (void)loadData
{
    
    if (!_curViews) {
        _curViews = [[NSMutableArray alloc]init];
    }
    for (int i = 0; i<_totalPages; i++) {
        [_curViews addObject:[_datasource pageAtIndex:i]];
    }
    
    for (int i = 0; i <_totalPages; i++) {
        UIView *v = [_curViews objectAtIndex:i];
        v.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTap:)];
        [v addGestureRecognizer:singleTap];
        //        [singleTap release];
        v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
        [_scrollView addSubview:v];
    }
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * _curPage, 0)];
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    if ([_delegate respondsToSelector:@selector(didClickPage:atIndex:)]) {
        [_delegate didClickPage:self atIndex:_curPage];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    int x = aScrollView.contentOffset.x;
    if (0 == x) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"middleView" object:nil];
    }
    if (0 == x%320) {
        _curPage = x/320;
        _pageControl.currentPage = _curPage;
        if (self.delegate && [self.delegate respondsToSelector:@selector(didScrollPage:atIndex:)]) {
            [self.delegate didScrollPage:self atIndex:_curPage];
        }
    }
    
}

@end
