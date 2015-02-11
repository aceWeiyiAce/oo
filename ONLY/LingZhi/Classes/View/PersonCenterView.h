//
//  PersonCenterView.h
//  LingZhi
//
//  Created by boguoc on 14-2-27.
//
//

#import "ITTXibView.h"

@protocol PersonCenterViewDelegate <NSObject>

- (void)didOnPersonCenterButtonWithType:(PersonCenterButtonType)type;

@end

@interface PersonCenterView : ITTXibView

@property (nonatomic ,assign) id<PersonCenterViewDelegate>delegate;

-(void)showPersonCenterViewWithView:(UIView *)superView delegate:(id)delegate;
-(void)cancelPersonCenterView;

@end
