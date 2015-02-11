//
//  XLPageControl.m
//  LingZhi
//
//  Created by boguoc on 14-3-25.
//
//
#define currentImage @"blackPoint.png"
#define defaultImage @"whitePoint.png"

#import "XLPageControl.h"

@interface XLPageControl ()
{
    UIImageView *_imageView;
    
    NSMutableArray *_pages;
    NSInteger _number;
}

@end

@implementation XLPageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.numberOfPages = 0;
        self.currentPage = 0;
        _pages = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)setNumberOfPages:(NSInteger)numberOfPages
{
    [_pages removeAllObjects];
    [self removeAllSubviews];
    for (int i = 0; i < numberOfPages; i++) {
        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:defaultImage]];
//        _imageView.backgroundColor = [UIColor whiteColor];
        _imageView.tag = i;
        _imageView.frame = CGRectMake(i*10, 0, 7, 6);
        [self addSubview:_imageView];
        [_pages addObject:_imageView];
    }
    _number = numberOfPages;
}

-(void)setCurrentPage:(NSInteger)currentPage
{
    for (int i = 0; i<_number; i++) {
        _imageView = _pages[i];
        _imageView.image = [UIImage imageNamed:defaultImage];
    }
    
    if (_number == 0) {
        _imageView.hidden = YES;
        return;
    }
    currentPage = MIN(currentPage, _pages.count - 1);
    _imageView = _pages[currentPage];
    _imageView.image = [UIImage imageNamed:currentImage];
//    imageView.image = [UIImage imageNamed:currentImage];
    _currentPage = currentPage;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
