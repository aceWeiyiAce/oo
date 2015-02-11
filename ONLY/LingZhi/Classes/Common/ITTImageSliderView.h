//
//  ImageSliderView.h
//  WSJJ_iPad
//
//  Created by lian jie on 2/12/11.
//  Copyright 2011 2009-2010 , Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITTImageView.h"

@protocol ITTImageSliderViewDelegate <NSObject>
@optional
- (void)imageClickedWithIndex:(int)imageIndex;
- (void)imageDidEndDeceleratingWithIndex:(int)imageIndex;
@end


@interface ITTImageSliderView : UIView <UIScrollViewDelegate,ITTImageViewDelegate>
{
//   __unsafe_unretained  id<ITTImageSliderViewDelegate> _delegate;
    NSArray                        *_imageUrls;           //image urls
}

@property (nonatomic,weak)id<ITTImageSliderViewDelegate> delegate;

- (void)setImageUrls:(NSArray*)imagesUrls;

@end
