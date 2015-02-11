//
//  EditAddressViewController.h
//  LingZhi
//
//  Created by boguoc on 14-3-11.
//
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"
#import "BaseViewController.h"

@protocol EditAddressViewControllerDelegate <NSObject>

- (void)didFinishEditAddressModel:(AddressModel *)model areaId:(NSString *)areaId;

@end

@interface EditAddressViewController : BaseViewController

@property (nonatomic ,strong) UIViewController *addressClass;
@property (nonatomic ,assign) BOOL isAddressEdit;
@property (nonatomic ,strong) NSArray        *addressArr;
@property (nonatomic ,strong) AddressModel   *addressModel;
@property (nonatomic ,assign) id<EditAddressViewControllerDelegate>delegate;

@end
