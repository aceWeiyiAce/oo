//
//  ImageSliderView.m
//  WSJJ_iPad
//
//  Created by lian jie on 2/12/11.
//  Copyright 2011 2009-2010 Dow Jones & Company, Inc. All rights reserved.
//

#import "ITTImageSliderView.h"
#import "ITTImageView.h"

@interface ITTImageSliderView()
{
    NSInteger       _currentIndex;
    NSMutableSet    *_recycledPages;
    NSMutableSet    *_visiblePages;
    
    UIScrollView    *_scrollView;        
}

- (void)updateFrame;
- (void)tilePages;
- (void)clearPages;
- (void)cancelAllDownloader;
- (void)configurePage:(ITTImageView *)page forIndex:(NSInteger)index;

- (BOOL)isDisplayingPageForIndex:(NSInteger)index;
- (BOOL)isCurrentPageIndexChanged;

- (NSInteger)getCurrentPageIndex;

- (CGRect)frameForPageAtIndex:(NSInteger)index;
- (CGSize)contentSizeForPagingScrollView;

- (ITTImageView *)dequeueRecycledPageForIndex:(NSInteger)index;

@end


@implementation ITTImageSliderView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {        
        _recycledPages = [[NSMutableSet alloc] init];
        _visiblePages  = [[NSMutableSet alloc] init];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:_scrollView];
        
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.clipsToBounds = NO;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.alpha = 0;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
        _recycledPages = [[NSMutableSet alloc] init];
        _visiblePages  = [[NSMutableSet alloc] init];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:_scrollView];
        
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.clipsToBounds = NO;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.alpha = 0;
    }
    return self;
}

- (void)setImageUrls:(NSArray*)imageUrls
{
    [self clearPages];
    _imageUrls = imageUrls;
    _scrollView.alpha = 1;
    _scrollView.contentSize = [self contentSizeForPagingScrollView];
        
    [_scrollView setContentOffset:CGPointZero];
    if ([_delegate respondsToSelector:@selector(imageDidEndDeceleratingWithIndex:)]) {
        [_delegate imageDidEndDeceleratingWithIndex:_scrollView.contentOffset.x/_scrollView.bounds.size.width];
    }
    [self tilePages];
}

- (void)dealloc
{
    _delegate = nil;
    [self cancelAllDownloader];
}

#pragma mark - Tiling and page configuration
- (void)updateFrame
{
    [_scrollView setContentSize:[self contentSizeForPagingScrollView]];
    CGFloat offsetX = floorf(_scrollView.contentOffset.x/_scrollView.width)*_scrollView.width;
    [_scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

- (void)tilePages
{
	int firstIndex = 0;
	int lastIndex = [_imageUrls count] - 1;
	// Calculate which pages are visible
    NSInteger currentPageIndex = [self getCurrentPageIndex];
    _currentIndex = currentPageIndex;
    
	int previousPageIndex = currentPageIndex - 1;
	int nextPageIndex = currentPageIndex + 1;
	
	previousPageIndex = MAX(previousPageIndex, firstIndex);
	nextPageIndex  = MIN(nextPageIndex, lastIndex);
	
	// Recycle no-longer-visible pages 
	for (ITTImageView *page in _visiblePages) {
        NSInteger index = page.tag;
        if (index < previousPageIndex || index > nextPageIndex){
			ITTDINFO(@"image at index %d is recycled", index);            
            page.tag = NSNotFound;
            page.image = nil;
			[_recycledPages addObject:page];
			[page removeFromSuperview];
		}
	}
	[_visiblePages minusSet:_recycledPages];
	
	//relayout visible pages
    for (NSInteger pageIndex = previousPageIndex; pageIndex <= nextPageIndex; pageIndex++) {
        ITTImageView *page = nil;
        if (![self isDisplayingPageForIndex:pageIndex]) {
            page = [self dequeueRecycledPageForIndex:pageIndex];
            if(!page){
				page = [[ITTImageView alloc] initWithFrame:_scrollView.bounds];
                page.contentMode = UIViewContentModeScaleAspectFill;
                page.clipsToBounds = TRUE;
            }
            page.tag = pageIndex;
            [_scrollView addSubview:page];
            [_visiblePages addObject:page];
        }
        else {
            page = [self visiblePageAtIndex:pageIndex];
        }
        ITTDINFO(@"layout index %d", pageIndex);
        [self configurePage:page forIndex:pageIndex];
    }
}

- (void)clearPages
{
    for (ITTImageView *page in _visiblePages) {
        page.tag = NSNotFound;
        page.image = nil;
        [_recycledPages addObject:page];
        [page removeFromSuperview];
	}
	[_visiblePages minusSet:_recycledPages];
}

- (ITTImageView *)dequeueRecycledPageForIndex:(int)index
{
    ITTImageView *page = [_recycledPages anyObject];
    if (page) {
        [_recycledPages removeObject:page];
    }
    return page;
}

- (BOOL)isDisplayingPageForIndex:(NSInteger)index
{
	BOOL found = NO;
	for (ITTImageView *page in _visiblePages) {
		int pageIndex = page.tag;
		if (pageIndex == index) {
			found = YES;
			break;
		}
	}
	return found;
}

- (BOOL)isCurrentPageIndexChanged
{
    NSInteger currentPageIndex = [self getCurrentPageIndex];
    return _currentIndex != currentPageIndex;
}

- (ITTImageView*)visiblePageAtIndex:(NSInteger)pageIndex
{
	ITTImageView *foundPage = nil;
	for (ITTImageView *page in _visiblePages) {
		int index = page.tag;
		if (index == pageIndex) {
            foundPage = page;
			break;
		}
	}
	return foundPage;
}

- (void)configurePage:(ITTImageView *)page forIndex:(NSInteger)index
{
    page.delegate = self;
    page.enableTapEvent = TRUE;
    NSString *imageUrl = _imageUrls[index];
    ITTDINFO(@"page %d image url %@", index, imageUrl);
    page.tag = index;
    if (imageUrl && [imageUrl length]) {
        [page loadImage:imageUrl placeHolder:[UIImage imageNamed:@"default_image_news_top.png"]];
    }
    else {
        page.image = [UIImage imageNamed:@"default_image_news_top.png"];
    }
	page.frame = [self frameForPageAtIndex:index];
}

- (void)cancelAllDownloader
{
    [_visiblePages enumerateObjectsUsingBlock:^(id object, BOOL *stop){
        [object cancelCurrentImageRequest];
    }];
    [_recycledPages enumerateObjectsUsingBlock:^(id object, BOOL *stop){
        [object cancelCurrentImageRequest];
    }];
}

#pragma mark - Frame calculations
- (NSInteger)getCurrentPageIndex
{
	CGRect visibleBounds = _scrollView.bounds;
	NSInteger currentIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
	currentIndex = MAX(currentIndex, 0);
	currentIndex = MIN(currentIndex, [_imageUrls count] - 1);
    return currentIndex;
}

- (CGRect)frameForPageAtIndex:(NSInteger)index
{
	CGRect bounds = _scrollView.bounds;
	CGRect pageFrame = bounds;
	pageFrame.origin.x = (bounds.size.width * index);
	return pageFrame;
}

- (CGSize)contentSizeForPagingScrollView
{
	return CGSizeMake(_scrollView.bounds.size.width * [_imageUrls count] , _scrollView.bounds.size.height);
}

- (void)clearCache 
{
	[_recycledPages removeAllObjects];
}

#pragma mark - UIScrollViewDelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self isCurrentPageIndexChanged]) {
        [self tilePages];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([self isCurrentPageIndexChanged]) {
        [self tilePages];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _currentIndex = [self getCurrentPageIndex];    
    if ([_delegate respondsToSelector:@selector(imageDidEndDeceleratingWithIndex:)]) {
        [_delegate imageDidEndDeceleratingWithIndex:scrollView.contentOffset.x/scrollView.bounds.size.width];
    }
}

#pragma mark - ITTImageView delegate
- (void)imageViewDidClicked:(ITTImageView *)imageView
{
    int indexInImages = [self getCurrentPageIndex];
    if (_delegate && [_delegate respondsToSelector:@selector(imageClickedWithIndex:)]) {
        [_delegate imageClickedWithIndex:indexInImages];
    }
}
@end
