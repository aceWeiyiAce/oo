//
//  AppDelegate.h
//  iTotemMinFramework
//
//  Created by  on 12-8-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mainViewController.h"
#import "Constant.h"
#import "JBshouyeViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) JBshouyeViewController *JBshouyeViewController;

+(AppDelegate*)GetAppDelegate;
- (void)beganLocation;
- (void)stopLocation;
@end
