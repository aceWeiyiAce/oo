//
//  AppDelegate.m
//  iTotemMinFramework
//
//  Created by  on 12-8-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "ObjectiveRecord.h"
#import "MyTrack.h"
#import "PKBaseRequest.h"
#import "BaseDataInitManager.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "ActivityRemindView.h"


@interface AppDelegate ()<CLLocationManagerDelegate>
{

}
@property (strong, nonatomic) NSString *wbtoken;
@end


@implementation AppDelegate

- (void)dealloc
{
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
        
    _mainViewController = [[MainViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:_mainViewController];
    
    nav.navigationBar.tintColor = [UIColor blackColor];
    nav.navigationBarHidden = YES;
    nav.hidesBottomBarWhenPushed = YES;
    self.window.rootViewController = nav;

//    UIViewController * vc= [[UIViewController alloc] init];
//    vc.view.frame = self.window.bounds;
//    vc.view.backgroundColor = [UIColor whiteColor];
//    
//    
//    self.window.rootViewController = vc;
//
//    ActivityRemindView * activity = [ActivityRemindView loadFromXib];
////    [activity showActivityViewInView:vc.view withMsg:@"正在加载"];
//    [activity showActivityViewInView:vc.view withMsg:@"努力加载中" inSeconds:5.0];
//
    
    
    [self.window makeKeyAndVisible];
    
    NSLog(@"%@",NSHomeDirectory());
    
    CoreDataManagerGlobalSetting(@"SqlModel", @"coreData.sqlite");
    
//    MyTrack * trackCreate = [MyTrack create];
//    trackCreate.productId = @"12343453";
//    trackCreate.imageUrl =@"fsdfdsfsf";
//    trackCreate.productInfo = @"made in china";
//    trackCreate.productPrice = @"499.00";
//    trackCreate.date = [NSDate date];
//    
//    if ([trackCreate hasChanges]) {
//        [trackCreate delete];
//        [trackCreate save];
//    }

    NSArray * one = [MyTrack all];
    NSLog(@"one =  %@",one);
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self setLoginDataCache];
    
    
    [UMSocialData setAppKey:@"5331460e56240bb2670075ff"];
    [UMSocialWechatHandler setWXAppId:@"wx8949e2f8b78e171d" url:nil];
    return YES;
}

-(void)setLoginDataCache
{
    [[ITTDataCacheManager sharedManager] addObject:@"13810720433" forKey:UserNameKey];
    [[ITTDataCacheManager sharedManager] addObject:@"1234567890" forKey:PWDKey];
    [[ITTDataCacheManager sharedManager] addObject:@"13810720433" forKey:TicketKey];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
