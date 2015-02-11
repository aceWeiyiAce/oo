//
//  WebResultViewController.h
//  LingZhi
//
//  Created by xjm on 14-4-29.
//
//

#import <UIKit/UIKit.h>

@protocol WebResultViewControllerDelegate <NSObject>

@optional
-(void)reloadCamera;

@end

@interface WebResultViewController : UIViewController

@property (nonatomic,strong) NSString * url;
@property (nonatomic,assign) id<WebResultViewControllerDelegate> delegate;


@end
