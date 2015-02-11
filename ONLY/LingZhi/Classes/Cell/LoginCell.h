//
//  LoginCell.h
//  LingZhi
//
//  Created by pk on 3/13/14.
//
//

#import "ITTXibView.h"

@protocol LoginCellTextFieldDelegate <NSObject>

@optional
-(void)autoSetTextFieldFrameWithView:(UIView *)view;

@end


@interface LoginCell : ITTXibCell
@property (strong, nonatomic) IBOutlet UITextField *txtField;
@property (strong, nonatomic) IBOutlet UILabel *remindLBl;

//@property (strong, nonatomic) NSIndexPath          *cellIndexPath;
@property (nonatomic,assign)  BOOL                  isWrong;
@property (nonatomic,assign) BOOL isShowBtn;

@property (strong, nonatomic) IBOutlet UIButton *pullBtn;


//-(void)showRemindInfoWithMsg:(NSString *)msg;

@end
