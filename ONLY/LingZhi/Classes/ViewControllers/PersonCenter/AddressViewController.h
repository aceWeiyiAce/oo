//
//  AddressViewController.h
//  LingZhi
//
//  Created by boguoc on 14-2-27.
//
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"
#import "BaseViewController.h"

@protocol AddressViewControllerDelegate <NSObject>

- (void)didFinishAddressEditReturnAddress:(NSArray *)address;
- (void)didBackAddressEditReturnAddress:(NSArray *)address;

@end

@interface AddressViewController : BaseViewController

@property (nonatomic ,strong) UIViewController *addressClass;
@property (nonatomic ,strong) NSArray *addresses;
@property (nonatomic ,assign) BOOL isAddressEdit;
@property (nonatomic ,assign) BOOL isAddAddress;
@property (nonatomic ,assign) id<AddressViewControllerDelegate>delegate;


@property (nonatomic ,strong) UIViewController *productController;

@end
