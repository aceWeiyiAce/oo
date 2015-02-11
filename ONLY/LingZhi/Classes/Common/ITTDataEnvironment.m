//
//  DataEnvironment.m
//  
//
//  Copyright 2010 itotem. All rights reserved.
//


#import "ITTDataEnvironment.h"
#import "ITTDataCacheManager.h"
#import "ITTNetworkTrafficManager.h"
#import "ITTObjectSingleton.h"
@interface ITTDataEnvironment()
- (void)restore;
- (void)registerMemoryWarningNotification;
@end
@implementation ITTDataEnvironment
@synthesize address = _address;
@synthesize userInfo = _userInfo;
ITTOBJECT_SINGLETON_BOILERPLATE(ITTDataEnvironment, sharedDataEnvironment)

#pragma mark - UserInfo
#define keyUserInfo @"asdlkfje322342342sdfsdfuserInfo"
-(void)setUserInfo:(UserInfo *)userInfo
{
    _userInfo = userInfo;
//    if (userInfo) {
        [[ITTDataCacheManager sharedManager] addObject:userInfo forKey:keyUserInfo];
//    } else {
//        [[ITTDataCacheManager sharedManager] removeObjectInCacheByKey:keyUserInfo];
//    }
}

-(UserInfo *)userInfo
{
    if (_userInfo == nil) {
        _userInfo = (UserInfo *)[[ITTDataCacheManager sharedManager] getCachedObjectByKey:keyUserInfo];
    }
    return _userInfo;
}

#pragma mark - Address
#define keyAddress @"asdlkfje322342342sdfsdfaddress"
-(void)setAddress:(AddressModel *)address
{
    _address = address;
//    if (address) {
        [[ITTDataCacheManager sharedManager] addObject:_address forKey:keyAddress];
//    } else {
//        [[ITTDataC    acheManager sharedManager] removeObjectInCacheByKey:keyAddress];
//    }
}

-(AddressModel *)address
{
    if (_address == nil) {
        _address = (AddressModel *)[[ITTDataCacheManager sharedManager] getCachedObjectByKey:keyAddress];
    }
    return _address;
}

#pragma mark - lifecycle methods


- (id)init
{
    self = [super init];
	if ( self) {
		[self restore];
        [self registerMemoryWarningNotification];
	}
	return self;
}


-(void)clearNetworkData
{
    [[ITTDataCacheManager sharedManager] clearAllCache];
}

#pragma mark - public methods

- (void)clearCacheData
{
    //clear cache data if needed
}

#pragma mark - private methods

- (void)restore
{
    _urlRequestHost = REQUEST_DOMAIN;
}

- (void)registerMemoryWarningNotification
{
#if TARGET_OS_IPHONE
    // Subscribe to app events
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearCacheData)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];    
#ifdef __IPHONE_4_0
    UIDevice *device = [UIDevice currentDevice];
    if ([device respondsToSelector:@selector(isMultitaskingSupported)] && device.multitaskingSupported){
        // When in background, clean memory in order to have less chance to be killed
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearCacheData)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
#endif
#endif        
}

@end