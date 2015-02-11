//
//  CustomError.h
//  LingZhi
//
//  Created by kping on 14-8-13.
//
//

#import "ITTXibView.h"
#import "ITTObjectSingleton.h"

@interface CustomError : ITTXibView



-(void)showErrorMsg:(NSString *)msg;
-(void)hideErrorMsg;


@end
