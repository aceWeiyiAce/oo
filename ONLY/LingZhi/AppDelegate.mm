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
#import "BMapKit.h"
#import "Base64.h"
#import "APService.h"
#import <AudioToolbox/AudioToolbox.h>
#import "LoginViewController.h"
#import "ITTDataCacheManager.h"

#import "Reachability.h"
#import "AlixPayResult.h"
#import "ActivityRemindView.h"
//#import "DataVerifier.h"
#import "WXApi.h"
#import "JBshouyeViewController.h"
#import "LoadingViewController.h"



@interface AppDelegate ()<BMKMapViewDelegate,BMKGeneralDelegate,WXApiDelegate,UITabBarDelegate>
{
    BMKMapManager *_mapManager;
    BMKMapView *_mapView;
    __weak id<WXApiDelegate> _app_wxApiDelegate;
}
@property (strong, nonatomic) NSString *wbtoken;
@end


@implementation AppDelegate
static AppDelegate *appdelegate;

+(AppDelegate*)GetAppDelegate
{
    return appdelegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    sleep(1);
    
    [self initSystemNoticationSetting];
    [self initBaiduMap];
    [self initPushNotification:launchOptions];
    
//    DATA_ENV.userInfo.userId = nil;
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    if (![[NSUserDefaults standardUserDefaults]stringForKey:@"uid"]) {
        LoadingViewController *loginVC = [[LoadingViewController alloc]initWithNibName:@"LoadingViewController" bundle:[NSBundle mainBundle]];
        UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:loginVC];
        self.window.rootViewController = nav1;
    }else{
    
    _JBshouyeViewController = [[JBshouyeViewController alloc] initWithNibName:@"JBshouyeViewController" bundle:[NSBundle mainBundle]];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:_JBshouyeViewController];
    
    self.window.rootViewController = nav;
    }

    
    
    
    [self.window makeKeyAndVisible];
    
    CoreDataManagerGlobalSetting(@"SqlModel", @"coreData.sqlite");

//    [self setLoginDataCache];
    
    [UMSocialData setAppKey:@"5331460e56240bb2670075ff"];
    [UMSocialWechatHandler setWXAppId:WEICHAT_AppKey url:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveReachability) name:kReachabilityChangedNotification object:nil];

    return YES;
}

- (void)receiveReachability
{
    if (isReachability) {
        [[NSNotificationCenter defaultCenter] postNotificationName:checkMainData object:nil];
    } else {
        ActivityRemindView *view = [ActivityRemindView loadFromXib];
        [view showActivityViewInView:self.window withMsg:@"联网失败,请检查网络" inSeconds:2];
    }
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

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
}

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    return  [WXApi handleOpenURL:url delegate:self];
//}
//
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    return  [WXApi handleOpenURL:url delegate:self];
//}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSString * urlAbsulte = [url absoluteString];
    if ([urlAbsulte hasPrefix:@"AliPayForOnly"]) {
        
        [self parse:url application:application];
        return YES;
    }
    if ([urlAbsulte hasPrefix:@"weixinPayForOnly"]) {
        _app_wxApiDelegate = self;
        return  [WXApi handleOpenURL:url delegate:_app_wxApiDelegate];
    }

    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSLog(@"url = %@",url);
    
    NSString * urlAbsulte = [url absoluteString];
    if ([urlAbsulte hasPrefix:APPURLSCHEME]) {
        
        [self parse:url application:application];
        return YES;
    }
    if ([urlAbsulte hasPrefix:@"weixinPayForOnly"]) {
        _app_wxApiDelegate = self;
        return  [WXApi handleOpenURL:url delegate:_app_wxApiDelegate];
    }
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess: {
                if (_app_wxApiDelegate && [_app_wxApiDelegate respondsToSelector:@selector(PaySuccess)]) {
//                    [_app_wxApiDelegate PaySuccess];
                }
            }
                break;
            default: {
                if (_app_wxApiDelegate && [_app_wxApiDelegate
                                  respondsToSelector:@selector(PayFail:)]) {
//                    [_app_wxApiDelegate PayFail:response.errCode];
                }
            }
            break; }
    }

}

-(void)PaySuccess
{
    NSLog(@"支付成功!");
}

-(void)PayFail:(PayResp *)resulst
{
    NSLog(@"支付失败:%@",resulst);
}

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    return  [WXApi handleOpenURL:url delegate:self];
//}
//
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    return  [WXApi handleOpenURL:url delegate:self];
//}
- (void)parse:(NSURL *)url application:(UIApplication *)application {
    
    //结果处理
    AlixPayResult* result = [self handleOpenURL:url];
    NSLog(@"result = %@",result);
    
	if (result)
    {
		
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
//            NSString* key = @"签约帐户后获取到的支付宝公钥";
//			id<DataVerifier> verifier;
//            verifier = CreateRSADataVerifier(key);
//
//			if ([verifier verifyString:result.resultString withSign:result.signString])
//            {
//                //验证签名成功，交易结果无篡改
//			}
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ALIPAY_KEY object:nil];
        }
        else
        {
            [[ActivityRemindView loadFromXib] showActivityViewInView:self.window withMsg:result.statusMessage inSeconds:1.0];
        }
    }
    else
    {
        //失败
    }
    
}



- (AlixPayResult *)resultFromURL:(NSURL *)url {
	NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

	return [[AlixPayResult alloc] initWithString:query];

}

- (AlixPayResult *)handleOpenURL:(NSURL *)url {
	AlixPayResult * result = nil;
	
	if (url != nil && [[url host] compare:@"safepay"] == 0) {
		result = [self resultFromURL:url];
	}
    
	return result;
}

- (void)initBaiduMap
{
    // 要使用百度地图，请先启动BaiduMapManager
	_mapManager = [[BMKMapManager alloc]init];
	BOOL ret = [_mapManager start:BAIDU_MAP_KEY generalDelegate:self];
    if (!ret) {
		NSLog(@"manager start failed!");
        [UIAlertView promptTipViewWithTitle:@"manager start failed!" message:nil cancelBtnTitle:@"确认" otherButtonTitles:nil onDismiss:^(int buttonIndex) {} onCancel:^{}];
	}
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
//        _mapView = [[BMKMapView alloc]init];
//        [_mapView viewWillAppear];
//        [self beganLocation];
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

- (void)beganLocation
{
    _mapView.delegate = self;
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
}

- (void)stopLocation
{
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = NO;//显示定位图层
}

- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
	NSLog(@"start locate");
}

/**
 *用户位置更新后，会调用此函数
 *@param mapView 地图View
 *@param userLocation 新的用户位置
 */

- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
	if (userLocation != nil) {
		NSLog(@"%f %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
        [self stopLocation];
        _mapView.delegate = nil;

	}
	
}
/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error%@",error);
     [self stopLocation];
    _mapView.delegate = nil;

}

-(NSString *)encodeString:(NSString *)str inTimes:(int)times
{
    NSString * str2 = [NSString stringWithBase64EncodedString:@"1"];
    NSLog(@"str2 = %@",[str2 base64EncodedString]);
    NSMutableString * result = [NSMutableString stringWithFormat:@"%@%@",str,@"onlyh5orderid&%"];
    for (int i =0; i<times; i++) {
        
        NSData * data = [[NSData alloc] initWithData:[result dataUsingEncoding:NSUTF8StringEncoding]];
        result = [NSMutableString stringWithString:[data base64EncodedString]];
        result = [NSMutableString stringWithString:[result encodeUrl]];
        NSLog(@"result = %@",result);
    }
    return result;
}

#pragma mark - Push

- (void)initPushNotification:(NSDictionary *)dic
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self selector:@selector(networkDidSetup:) name:kAPNetworkDidSetupNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidClose:) name:kAPNetworkDidCloseNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidRegister:) name:kAPNetworkDidRegisterNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidLogin:) name:kAPNetworkDidLoginNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kAPNetworkDidReceiveMessageNotification object:nil];
    
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)];
    [APService setupWithOption:dic];
    
    UserInfo * _user = DATA_ENV.userInfo;
    
    if ([_user.isOpenNoti isEqualToString:@"1"]) {
        if (_user.userId.length>0) { //注册用户
            if (![_user.silent boolValue] && [_user.sound boolValue]) {
                //没开勿扰有声音1
                [APService setTags:nil alias:@"noSlientS" callbackSelector:@selector(tagsAliasCallback) target:self];
            } else if (![_user.silent boolValue] && ![_user.sound boolValue]) {
                //没开勿扰没声音2
                [APService setTags:nil alias:@"noSlientNoS" callbackSelector:@selector(tagsAliasCallback) target:self];
            } else if ([_user.silent boolValue] && [_user.sound boolValue]) {
                //开勿扰有声音3
                [APService setTags:nil alias:@"sound" callbackSelector:@selector(tagsAliasCallback) target:self];
            } else if ([_user.silent boolValue] && ![_user.sound boolValue]) {
                //开勿扰没声音4
                [APService setTags:nil alias:@"noSound" callbackSelector:@selector(tagsAliasCallback) target:self];
            }
        } else {
            if (![_user.silent boolValue] && [_user.sound boolValue]) {
                //没开勿扰有声音5
                [APService setTags:nil alias:@"anoSlientS" callbackSelector:@selector(tagsAliasCallback) target:self];
            } else if (![_user.silent boolValue] && ![_user.sound boolValue]) {
                //没开勿扰没声音6
                [APService setTags:nil alias:@"anoSlientNos" callbackSelector:@selector(tagsAliasCallback) target:self];
            } else if ([_user.silent boolValue] && [_user.sound boolValue]) {
                //开勿扰有声音7
                [APService setTags:nil alias:@"asound" callbackSelector:@selector(tagsAliasCallback) target:self];
            } else if ([_user.silent boolValue] && ![_user.sound boolValue]) {
                //开勿扰没声音8
                [APService setTags:nil alias:@"anoSound" callbackSelector:@selector(tagsAliasCallback) target:self];
            }
        }
    } else {
        [APService setTags:nil alias:@"closeNoti" callbackSelector:@selector(tagsAliasCallback) target:self];
    }
}

- (void)initSystemNoticationSetting
{
    if (DATA_ENV.userInfo.sound.length<1 && !DATA_ENV.userInfo.sound) {
        UserInfo *userInfo = [[UserInfo alloc]init];
        userInfo.sound = @"1";
        userInfo.silent = @"0";
        userInfo.vibration = @"1";
        userInfo.isOpenNoti = @"1";
        DATA_ENV.userInfo = userInfo;
    }
}


- (void)tagsAliasCallback{
}


- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);

}

- (void)networkDidSetup:(NSNotification *)notification
{
    NSLog(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification
{
    NSLog(@"未连接。。。");
}

- (void)networkDidRegister:(NSNotification *)notification
{
    NSLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification
{
    NSLog(@"已登录");
}

- (void)networkDidReceiveMessage:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSString *str = userInfo[@"content"];
    [UIAlertView promptTipViewWithTitle:str message:nil
                         cancelBtnTitle:@"ok" otherButtonTitles:nil
                              onDismiss:^(int buttonIndex) {
                                  
                              } onCancel:^{
                                  
                              }];
    if (DATA_ENV.userInfo.sound) {
        //        NSString *path = [[NSBundle mainBundle] pathForResource:@"sound" ofType:@"caf"];
        //        if (path) {
        //            //注册声音到系统
        //            NSLog(@"找到声音");
        //            AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
        //            AudioServicesPlaySystemSound(shake_sound_male_id);
        //            AudioServicesPlaySystemSound(shake_sound_male_id);//如果无法再下面播放，可以尝试在此播放
        //        }
    }
    if ([DATA_ENV.userInfo.vibration boolValue]) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [APService handleRemoteNotification:userInfo];
    
}

//avoid compile error for sdk under 7.0
#ifdef __IPHONE_7_0
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNoData);
}
#endif

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}
-(BOOL)isLogin
{
    if ([USER_DEFAULT valueForKey:UserNameKey]!=Nil && [USER_DEFAULT valueForKey:PWDKey]!=Nil) {
        return YES;
    }
    return NO;
}

@end
