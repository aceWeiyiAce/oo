//
//  MRZoomScrollView.m
//  ScrollViewWithZoom
//
//  Created by xuym on 13-3-27.
//  Copyright (c) 2013年 xuym. All rights reserved.
//

#import "MRZoomScrollView.h"

#define MRScreenWidth      CGRectGetWidth([UIScreen mainScreen].applicationFrame)
#define MRScreenHeight     CGRectGetHeight([UIScreen mainScreen].applicationFrame)

@interface MRZoomScrollView (Utility)
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;

@end

@implementation MRZoomScrollView

@synthesize imageView;
@synthesize doubleTapGesture;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.delegate = self;
//        self.frame = CGRectMake(0, 0, MRScreenWidth, MRScreenHeight);
        
        self.frame = frame;
        maxScale = 2.0;
        [self initImageView];
        self.decelerationRate = 2.0;
    }
    return self;
}



- (void)initImageView
{
    imageView = [[ITTImageView alloc]init];
    
    imageView.frame = self.bounds;
    
    
    // The imageView can be zoomed largest size
    imageView.frame = CGRectMake(0, 0, MRScreenWidth * 2.5, MRScreenHeight * 2.5);

    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
    
    // Add gesture,double tap zoom imageView.
    doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleDoubleTap:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [imageView addGestureRecognizer:doubleTapGesture];
    
    float minimumScale = self.frame.size.width / imageView.frame.size.width;
    minScale = minimumScale;
    [self setMinimumZoomScale:minimumScale];
    [self setZoomScale:minimumScale];

}


#pragma mark - Zoom methods

- (void)handleDoubleTap:(UIGestureRecognizer *)gesture
{
//    float newScale = self.zoomScale * 1.5;
//    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gesture locationInView:gesture.view]];
//    [self zoomToRect:zoomRect animated:YES];
    
    
    //当前倍数等于最大放大倍数
    //双击默认为缩小到原图
    if (currentScale==maxScale) {
        currentScale=minScale;
        
//        [self setZoomScale:currentScale animated:YES];
        [self setScrollViewScale:gesture andScale:currentScale];
        return;
    }
    //当前等于最小放大倍数
    //双击默认为放大到最大倍数
    if (currentScale==minScale) {
        currentScale=maxScale;
//        [self setZoomScale:currentScale animated:YES];
        [self setScrollViewScale:gesture andScale:currentScale];
        return;
    }
    
    CGFloat aveScale =minScale+(maxScale-minScale)/2.0;//中间倍数
    
    //当前倍数大于平均倍数
    //双击默认为放大最大倍数
    if (currentScale>=aveScale) {
        currentScale=maxScale;
//        [self setZoomScale:currentScale animated:YES];
        [self setScrollViewScale:gesture andScale:currentScale];
        return;
    }
    
    //当前倍数小于平均倍数
    //双击默认为放大到最小倍数
    if (currentScale<aveScale) {
        currentScale=self.minimumZoomScale;
//        [self setZoomScale:currentScale animated:YES];
        [self setScrollViewScale:gesture andScale:currentScale];
        return;
    }
    
    
}

-(void)setScrollViewScale:(UIGestureRecognizer *)gesture andScale:(float)scale
{
   
    CGRect zoomRect = [self zoomRectForScale:scale withCenter:[gesture locationInView:gesture.view]];
    [self zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
//    [scrollView setZoomScale:scale animated:NO];
    currentScale = scale;
}


@end
