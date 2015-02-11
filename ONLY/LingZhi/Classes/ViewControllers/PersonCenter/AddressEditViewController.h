//
//  AddressEditViewController.h
//  LingZhi
//
//  Created by boguoc on 14-5-16.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol AddressEditViewControllerDelegate <NSObject>

- (void)didChooseAddress:(AddressModel *)model;

@end

@interface AddressEditViewController : BaseViewController

@property (nonatomic ,assign) id<AddressEditViewControllerDelegate>delegate;

@end
