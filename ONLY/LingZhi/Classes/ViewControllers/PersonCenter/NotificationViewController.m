//
//  NotificationViewController.m
//  LingZhi
//
//  Created by boguoc on 14-3-19.
//
//

#import "NotificationViewController.h"
#import "UserInfo.h"
#import "APService.h"

@interface NotificationViewController ()
{
    __weak IBOutlet UIButton *_soundButton;
    __weak IBOutlet UIButton *_silentButton;
    __weak IBOutlet UIButton *_vilButton;
    __weak IBOutlet UIButton *_isOpenNoti;
    __weak IBOutlet UIButton *_backButton;

    UserInfo * _defaultUserInfo;
}
@end

@implementation NotificationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _defaultUserInfo = [[UserInfo alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout= UIRectEdgeNone;
    }
    _defaultUserInfo = DATA_ENV.userInfo;
    //update by pk at 20140611
    
//    _silentButton.selected = ![DATA_ENV.userInfo.silent boolValue];
//    _soundButton.selected = ![DATA_ENV.userInfo.sound boolValue];
//    _vilButton.selected = ![DATA_ENV.userInfo.vibration boolValue];
//    _isOpenNoti.selected = ![DATA_ENV.userInfo.isOpenNoti boolValue];
    
    _silentButton.selected = ![_defaultUserInfo.silent boolValue];
    _soundButton.selected = ![_defaultUserInfo.sound boolValue];
    _vilButton.selected = ![_defaultUserInfo.vibration boolValue];
    _isOpenNoti.selected = ![_defaultUserInfo.isOpenNoti boolValue];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    DATA_ENV.userInfo = _defaultUserInfo;
}

#pragma mark - Button Methods

- (IBAction)backToPreviewAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onOpenNotificationButton:(id)sender
{
//    UIButton *button = (UIButton *)sender;
//    _isOpenNoti.selected = !button.selected;
    //update by pk at 20140611
    _isOpenNoti.selected = !_isOpenNoti.selected;
    
//    UserInfo *userInfo = DATA_ENV.userInfo;
//    userInfo.isOpenNoti = _isOpenNoti.selected?@"0":@"1";
//    DATA_ENV.userInfo = userInfo;

    _defaultUserInfo.isOpenNoti = _isOpenNoti.selected?@"0":@"1";
    
    
    [self settingNotification];
}

- (IBAction)onAudioButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    _soundButton.selected = !button.selected;
    
    //update by pk at 20140611
//    UserInfo *userInfo = DATA_ENV.userInfo;
//    userInfo.sound = _soundButton.selected?@"0":@"1";
//    DATA_ENV.userInfo = userInfo;
    
    _defaultUserInfo.sound = _soundButton.selected?@"0":@"1";
    [self settingNotification];
}

- (IBAction)onBadgeButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    _vilButton.selected = !button.selected;
    
    //update by pk at 20140611
//    UserInfo *userInfo = DATA_ENV.userInfo;
//    userInfo.vibration = _vilButton.selected?@"0":@"1";
//    DATA_ENV.userInfo = userInfo;
    
    _defaultUserInfo.vibration = _vilButton.selected?@"0":@"1";
    [self settingNotification];
}

- (IBAction)onNightButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    _silentButton.selected = !button.selected;
    
    //update by pk at 20140611
//    UserInfo *userInfo = DATA_ENV.userInfo;
//    userInfo.silent = _silentButton.selected?@"0":@"1";
//    DATA_ENV.userInfo = userInfo;
    
    _defaultUserInfo.silent = _silentButton.selected?@"0":@"1";
    
    [self settingNotification];
}


- (void)settingNotification
{
//    _isOpenNoti.enabled = NO;
//    _backButton.enabled = NO;
    
    //update by pk at 20140611
//    if ([DATA_ENV.userInfo.isOpenNoti isEqualToString:@"1"]) {
//        if (DATA_ENV.userInfo.userId.length>0) { //注册用户
//            if (![DATA_ENV.userInfo.silent boolValue] && [DATA_ENV.userInfo.sound boolValue]) {
//                //没开勿扰有声音1
//                [APService setTags:nil alias:@"noSlientS" callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
//            } else if (![DATA_ENV.userInfo.silent boolValue] && ![DATA_ENV.userInfo.sound boolValue]) {
//                //没开勿扰没声音2
//                [APService setTags:nil alias:@"noSlientNoS" callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
//            } else if ([DATA_ENV.userInfo.silent boolValue] && [DATA_ENV.userInfo.sound boolValue]) {
//                //开勿扰有声音3
//                [APService setTags:nil alias:@"sound" callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
//            } else if ([DATA_ENV.userInfo.silent boolValue] && ![DATA_ENV.userInfo.sound boolValue]) {
//                //开勿扰没声音4
//                [APService setTags:nil alias:@"noSound" callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
//            }
//        } else {
//            if (![DATA_ENV.userInfo.silent boolValue] && [DATA_ENV.userInfo.sound boolValue]) {
//                //没开勿扰有声音5
//                [APService setTags:nil alias:@"anoSlientS" callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
//            } else if (![DATA_ENV.userInfo.silent boolValue] && ![DATA_ENV.userInfo.sound boolValue]) {
//                //没开勿扰没声音6
//                [APService setTags:nil alias:@"anoSlientNos" callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
//            } else if ([DATA_ENV.userInfo.silent boolValue] && [DATA_ENV.userInfo.sound boolValue]) {
//                //开勿扰有声音7
//                [APService setTags:nil alias:@"asound" callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
//            } else if ([DATA_ENV.userInfo.silent boolValue] && ![DATA_ENV.userInfo.sound boolValue]) {
//                //开勿扰没声音8
//                [APService setTags:nil alias:@"anoSound" callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
//            }
//        }
//    } else {
//        [APService setTags:nil alias:@"closeNoti" callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
//    }
    
    if ([_defaultUserInfo.isOpenNoti isEqualToString:@"1"]) {
        if (_defaultUserInfo.userId.length>0) { //注册用户
            if (![_defaultUserInfo.silent boolValue] && [_defaultUserInfo.sound boolValue]) {
                //没开勿扰有声音1
                [APService setTags:nil alias:@"noSlientS" callbackSelector:@selector(tagsAliasCallback) target:self];
            } else if (![_defaultUserInfo.silent boolValue] && ![_defaultUserInfo.sound boolValue]) {
                //没开勿扰没声音2
                [APService setTags:nil alias:@"noSlientNoS" callbackSelector:@selector(tagsAliasCallback) target:self];
            } else if ([_defaultUserInfo.silent boolValue] && [_defaultUserInfo.sound boolValue]) {
                //开勿扰有声音3
                [APService setTags:nil alias:@"sound" callbackSelector:@selector(tagsAliasCallback) target:self];
            } else if ([_defaultUserInfo.silent boolValue] && ![_defaultUserInfo.sound boolValue]) {
                //开勿扰没声音4
                [APService setTags:nil alias:@"noSound" callbackSelector:@selector(tagsAliasCallback) target:self];
            }
        } else {
            if (![_defaultUserInfo.silent boolValue] && [_defaultUserInfo.sound boolValue]) {
                //没开勿扰有声音5
                [APService setTags:nil alias:@"anoSlientS" callbackSelector:@selector(tagsAliasCallback) target:self];
            } else if (![_defaultUserInfo.silent boolValue] && ![_defaultUserInfo.sound boolValue]) {
                //没开勿扰没声音6
                [APService setTags:nil alias:@"anoSlientNos" callbackSelector:@selector(tagsAliasCallback) target:self];
            } else if ([_defaultUserInfo.silent boolValue] && [_defaultUserInfo.sound boolValue]) {
                //开勿扰有声音7
                [APService setTags:nil alias:@"asound" callbackSelector:@selector(tagsAliasCallback) target:self];
            } else if ([_defaultUserInfo.silent boolValue] && ![_defaultUserInfo.sound boolValue]) {
                //开勿扰没声音8
                [APService setTags:nil alias:@"anoSound" callbackSelector:@selector(tagsAliasCallback) target:self];
            }
        }
    } else {
        [APService setTags:nil alias:@"closeNoti" callbackSelector:@selector(tagsAliasCallback) target:self];
    }
}


- (void)tagsAliasCallback{

    _isOpenNoti.enabled = YES;
    _backButton.enabled = YES;
}


- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
//    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
    _isOpenNoti.enabled = YES;
    _backButton.enabled = YES;
}

@end
