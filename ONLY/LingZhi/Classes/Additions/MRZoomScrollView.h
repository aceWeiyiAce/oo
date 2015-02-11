//
//  MRZoomScrollView.h
//  ScrollViewWithZoom
//
//  Created by xuym on 13-3-27.
//  Copyright (c) 2013年 xuym. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface MRZoomScrollView : UIScrollView <UIScrollViewDelegate>
{
    ITTImageView *imageView;
    UITapGestureRecognizer *doubleTapGesture;
    float currentScale;
    float maxScale;
    float minScale;
}

@property (nonatomic,strong) ITTImageView *imageView;

@property (nonatomic,strong)UITapGestureRecognizer *doubleTapGesture;

@end
