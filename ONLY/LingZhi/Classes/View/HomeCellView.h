//
//  HomeCellView.h
//  LingZhi
//
//  Created by boguoc on 14-4-16.
//
//

#import "ITTXibView.h"
#import "HomeModel.h"

@interface HomeCellView : ITTXibCell

@property (nonatomic ,assign) int index;

- (void)layoutHomeCellView:(HomeModel *)model;

@end
