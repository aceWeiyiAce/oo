//
//  HomeView.h
//  LingZhi
//
//  Created by boguoc on 14-3-7.
//
//

#import "ITTXibView.h"
#import "HomeModel.h"

@class UserDetailInfo;
@protocol HomeViewDelegate <NSObject>

- (void)didSelectHomeViewAtProductId:(HomeModel *)homeModel;
- (void)didSelectFooterView;

#pragma mark - app 1.4 add
-(void)didClickCompleteButton;

@end

@interface HomeView : ITTXibView

@property (nonatomic ,assign) id<HomeViewDelegate>delegate;

@end
