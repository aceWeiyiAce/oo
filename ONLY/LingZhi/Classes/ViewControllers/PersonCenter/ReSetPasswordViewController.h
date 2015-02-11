//
//  ReSetPasswordViewController.h
//  LingZhi
//
//  Created by pk on 14-3-16.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol ReSetPasswordViewControllerDelegate <NSObject>

-(void)updateMobileNumber:(NSString *)mobile;

@end



@interface ReSetPasswordViewController : BaseViewController

@property (nonatomic,assign) id<ReSetPasswordViewControllerDelegate> delegate;

@end
