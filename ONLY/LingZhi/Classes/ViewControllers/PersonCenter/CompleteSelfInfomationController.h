//
//  CompleteSelfInfomationController.h
//  LingZhi
//
//  Created by kping on 14-8-12.
//
//

#import "BaseViewController.h"
#import "UserDetailInfo.h"

@interface CompleteSelfInfomationController : BaseViewController

@property (strong,nonatomic) UserDetailInfo * detailInfo;
@property (assign,nonatomic) BOOL isShowSaveText;

@end
